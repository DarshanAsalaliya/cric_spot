import 'dart:developer';

import 'package:cric_spot/core/enum/box_type.dart';
import 'package:cric_spot/model/inning/inning_model.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/model/player/player_model.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseSyncService {
  final SupabaseClient _client = Supabase.instance.client;
  static const _uuid = Uuid();

  bool get isAuthenticated => _client.auth.currentUser != null;
  String? get currentUserId => _client.auth.currentUser?.id;

  /// Generate a new UUID for remote ID mapping
  static String generateRemoteId() => _uuid.v4();

  /// Determine match format from overs count.
  static String getMatchFormat(int overs) {
    if (overs == 10) return 't10';
    if (overs <= 20) return 't20';
    if (overs <= 50) return 'odi';
    return 'custom';
  }

  /// Get display label for a match format.
  static String formatLabel(String format) {
    switch (format) {
      case 't10': return 'T10';
      case 't20': return 'T20';
      case 'odi': return 'ODI';
      default: return 'Custom';
    }
  }

  /// Create a match in Supabase and return the share code.
  /// Called during match creation when user is authenticated.
  Future<String?> createMatch(MatchModel match, {String? tournamentId}) async {
    if (!isAuthenticated) return null;

    try {
      final remoteId = match.remoteId ?? generateRemoteId();
      final overs = int.tryParse(match.over ?? '0') ?? 0;
      final data = <String, dynamic>{
        'id': remoteId,
        'created_by': currentUserId,
        'overs': overs,
        'player_per_match': int.tryParse(match.playerPerMatch ?? '11') ?? 11,
        'is_wide_ball': match.isWideBall ?? true,
        'is_wide_reball': match.isWideReball ?? false,
        'wide_run': match.wideRun ?? 1,
        'is_noball': match.isNoball ?? true,
        'is_noball_reball': match.isNoballReball ?? false,
        'noball_run': match.noballRun ?? 1,
        'first_bat_team_name': match.firstBatTeamName,
        'second_bat_team_name': match.secondBatTeamName,
        'first_bat_team_score': match.firstBatTeamScore ?? '0/0',
        'first_bat_team_over': match.firstBatTeamOver ?? '0.0',
        'second_bat_team_score': match.secondBatTeamScore ?? '0/0',
        'second_bat_team_over': match.secondBatTeamOver ?? '0.0',
        'match_format': getMatchFormat(overs),
        'status': 'live',
      };
      if (tournamentId != null) {
        data['tournament_id'] = tournamentId;
      }

      final response = await _client.from('matches').insert(data).select('share_code').single();
      return response['share_code'] as String?;
    } catch (e) {
      log('SupabaseSyncService.createMatch error: $e');
      return null;
    }
  }

  /// Sync current match state to Supabase (called after each saveData).
  /// Fire-and-forget — errors are logged but don't break the scoring flow.
  Future<void> syncMatchState(MatchModel match, InningModel? inningOne, InningModel? inningTwo) async {
    if (!isAuthenticated || match.remoteId == null) return;

    try {
      // Upsert match summary
      await _client.from('matches').upsert({
        'id': match.remoteId,
        'first_bat_team_score': match.firstBatTeamScore,
        'first_bat_team_over': match.firstBatTeamOver,
        'second_bat_team_score': match.secondBatTeamScore,
        'second_bat_team_over': match.secondBatTeamOver,
        'won_by_description': match.wonBy,
        'status': match.wonId != null ? 'completed' : 'live',
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Upsert innings
      if (inningOne != null && inningOne.remoteId != null) {
        await _syncInning(inningOne);
      }
      if (inningTwo != null && inningTwo.remoteId != null) {
        await _syncInning(inningTwo);
      }

      match.isSynced = true;
    } catch (e) {
      log('SupabaseSyncService.syncMatchState error: $e');
      match.isSynced = false;
    }
  }

  Future<void> _syncInning(InningModel inning) async {
    await _client.from('innings').upsert({
      'id': inning.remoteId,
      'total_run': inning.totalRun ?? 0,
      'total_wicket': inning.totalWicket ?? 0,
      'total_ball': inning.totalBall ?? 0,
      'extra_wide': inning.extraRun?.wide ?? 0,
      'extra_noball': inning.extraRun?.noBall ?? 0,
      'extra_legbye': inning.extraRun?.legBy ?? 0,
      'extra_bye': inning.extraRun?.by ?? 0,
      'extra_penalty': inning.extraRun?.penlaty ?? 0,
      'extra_total': inning.extraRun?.total ?? 0,
      'current_over': inning.currentOver ?? [],
      'overs': inning.overs ?? [],
      'fall_of_wicket': inning.fallOfWicket ?? [],
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Fetch match data by share code (for viewers).
  Future<Map<String, dynamic>?> getMatchByShareCode(String shareCode) async {
    try {
      final response = await _client
          .from('matches')
          .select()
          .eq('share_code', shareCode.toUpperCase())
          .maybeSingle();
      return response;
    } catch (e) {
      log('SupabaseSyncService.getMatchByShareCode error: $e');
      return null;
    }
  }

  /// Subscribe to real-time match updates (for viewers).
  Stream<Map<String, dynamic>> watchMatch(String matchId) {
    return _client
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('id', matchId)
        .map((list) => list.isNotEmpty ? list.first : <String, dynamic>{});
  }

  /// Subscribe to real-time inning updates (for viewers).
  Stream<List<Map<String, dynamic>>> watchInnings(String matchId) {
    return _client
        .from('innings')
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId);
  }

  /// Process a queued sync operation (called when connectivity is restored).
  Future<void> processSyncOperation(Map<String, dynamic> operation) async {
    final type = operation['type'] as String;
    final data = Map<String, dynamic>.from(operation['data'] as Map);

    switch (type) {
      case 'upsert_match':
        await _client.from('matches').upsert(data);
        break;
      case 'upsert_inning':
        await _client.from('innings').upsert(data);
        break;
      case 'complete_match':
        final id = data.remove('_id');
        await _client.from('matches').update(data).eq('id', id);
        break;
    }
  }

  /// Sync ALL local Hive data to Supabase.
  /// Called after user signs up or logs in to push guest data online.
  Future<void> syncAllLocalData() async {
    if (!isAuthenticated) return;

    try {
      final getIt = GetIt.instance;

      // Sync teams
      final teamBox = await getIt.getAsync<Box<TeamModel>>(instanceName: BoxType.team.name);
      for (final team in teamBox.values) {
        if (team.remoteId == null) {
          team.remoteId = generateRemoteId();
          team.save();
        }
        await _client.from('teams').upsert({
          'id': team.remoteId,
          'created_by': currentUserId,
          'name': team.name ?? '',
          'match_count': team.match ?? 0,
          'win': team.win ?? 0,
          'loss': team.loss ?? 0,
        });
        team.isSynced = true;
        team.save();
      }

      // Sync players
      final playerBox = await getIt.getAsync<Box<PlayerModel>>(instanceName: BoxType.player.name);
      for (final player in playerBox.values) {
        if (player.remoteId == null) {
          player.remoteId = generateRemoteId();
          player.save();
        }
        await _client.from('players').upsert({
          'id': player.remoteId,
          'created_by': currentUserId,
          'name': player.name ?? '',
        });
        player.isSynced = true;
        player.save();
      }

      // Sync matches and innings
      final matchBox = await getIt.getAsync<Box<MatchModel>>(instanceName: BoxType.match.name);
      final inningBox = await getIt.getAsync<Box<InningModel>>(instanceName: BoxType.inning.name);

      for (final match in matchBox.values) {
        if (match.remoteId == null) {
          match.remoteId = generateRemoteId();
          match.createdByUserId = currentUserId;
          match.save();
        }

        // Create/upsert match in Supabase
        final overs = int.tryParse(match.over ?? '0') ?? 0;
        final response = await _client.from('matches').upsert({
          'id': match.remoteId,
          'created_by': currentUserId,
          'overs': overs,
          'match_format': getMatchFormat(overs),
          'player_per_match': int.tryParse(match.playerPerMatch ?? '11') ?? 11,
          'is_wide_ball': match.isWideBall ?? true,
          'is_wide_reball': match.isWideReball ?? false,
          'wide_run': match.wideRun ?? 1,
          'is_noball': match.isNoball ?? true,
          'is_noball_reball': match.isNoballReball ?? false,
          'noball_run': match.noballRun ?? 1,
          'first_bat_team_name': match.firstBatTeamName,
          'second_bat_team_name': match.secondBatTeamName,
          'first_bat_team_score': match.firstBatTeamScore ?? '0/0',
          'first_bat_team_over': match.firstBatTeamOver ?? '0.0',
          'second_bat_team_score': match.secondBatTeamScore ?? '0/0',
          'second_bat_team_over': match.secondBatTeamOver ?? '0.0',
          'won_by_description': match.wonBy,
          'status': match.wonId != null ? 'completed' : 'live',
        }).select('share_code').single();

        if (match.shareCode == null && response['share_code'] != null) {
          match.shareCode = response['share_code'] as String;
        }
        match.isSynced = true;
        match.save();

        // Sync innings for this match
        if (match.inningOneId != null) {
          final inningOne = inningBox.get(int.tryParse(match.inningOneId!));
          if (inningOne != null) {
            if (inningOne.remoteId == null) {
              inningOne.remoteId = generateRemoteId();
              inningOne.save();
            }
            await _client.from('innings').upsert({
              'id': inningOne.remoteId,
              'match_id': match.remoteId,
              'is_first_inning': true,
              'bat_team_name': inningOne.batTeamName,
              'bowl_team_name': inningOne.bowlTeamName,
              'total_run': inningOne.totalRun ?? 0,
              'total_wicket': inningOne.totalWicket ?? 0,
              'total_ball': inningOne.totalBall ?? 0,
              'extra_wide': inningOne.extraRun?.wide ?? 0,
              'extra_noball': inningOne.extraRun?.noBall ?? 0,
              'extra_legbye': inningOne.extraRun?.legBy ?? 0,
              'extra_bye': inningOne.extraRun?.by ?? 0,
              'extra_penalty': inningOne.extraRun?.penlaty ?? 0,
              'extra_total': inningOne.extraRun?.total ?? 0,
              'current_over': inningOne.currentOver ?? [],
              'overs': inningOne.overs ?? [],
              'fall_of_wicket': inningOne.fallOfWicket ?? [],
            });
            inningOne.isSynced = true;
            inningOne.save();
          }
        }

        if (match.inningTwoId != null) {
          final inningTwo = inningBox.get(int.tryParse(match.inningTwoId!));
          if (inningTwo != null) {
            if (inningTwo.remoteId == null) {
              inningTwo.remoteId = generateRemoteId();
              inningTwo.save();
            }
            await _client.from('innings').upsert({
              'id': inningTwo.remoteId,
              'match_id': match.remoteId,
              'is_first_inning': false,
              'bat_team_name': inningTwo.batTeamName,
              'bowl_team_name': inningTwo.bowlTeamName,
              'total_run': inningTwo.totalRun ?? 0,
              'total_wicket': inningTwo.totalWicket ?? 0,
              'total_ball': inningTwo.totalBall ?? 0,
              'extra_wide': inningTwo.extraRun?.wide ?? 0,
              'extra_noball': inningTwo.extraRun?.noBall ?? 0,
              'extra_legbye': inningTwo.extraRun?.legBy ?? 0,
              'extra_bye': inningTwo.extraRun?.by ?? 0,
              'extra_penalty': inningTwo.extraRun?.penlaty ?? 0,
              'extra_total': inningTwo.extraRun?.total ?? 0,
              'current_over': inningTwo.currentOver ?? [],
              'overs': inningTwo.overs ?? [],
              'fall_of_wicket': inningTwo.fallOfWicket ?? [],
            });
            inningTwo.isSynced = true;
            inningTwo.save();
          }
        }
      }

      log('SupabaseSyncService.syncAllLocalData: completed successfully');
    } catch (e) {
      log('SupabaseSyncService.syncAllLocalData error: $e');
    }
  }

  /// Sync a single team to Supabase. Called when teams are created/updated.
  Future<void> syncTeam(TeamModel team) async {
    if (!isAuthenticated) return;
    try {
      if (team.remoteId == null) {
        team.remoteId = generateRemoteId();
        team.save();
      }
      await _client.from('teams').upsert({
        'id': team.remoteId,
        'created_by': currentUserId,
        'name': team.name ?? '',
        'match_count': team.match ?? 0,
        'win': team.win ?? 0,
        'loss': team.loss ?? 0,
      });
      team.isSynced = true;
      team.save();
    } catch (e) {
      log('SupabaseSyncService.syncTeam error: $e');
    }
  }

  /// Sync a single player to Supabase.
  Future<void> syncPlayer(PlayerModel player) async {
    if (!isAuthenticated) return;
    try {
      if (player.remoteId == null) {
        player.remoteId = generateRemoteId();
        player.save();
      }
      await _client.from('players').upsert({
        'id': player.remoteId,
        'created_by': currentUserId,
        'name': player.name ?? '',
      });
      player.isSynced = true;
      player.save();
    } catch (e) {
      log('SupabaseSyncService.syncPlayer error: $e');
    }
  }

  /// Mark match as completed in Supabase.
  Future<void> completeMatch(MatchModel match) async {
    if (!isAuthenticated || match.remoteId == null) return;

    try {
      await _client.from('matches').update({
        'status': 'completed',
        'won_by_description': match.wonBy,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', match.remoteId!);
    } catch (e) {
      log('SupabaseSyncService.completeMatch error: $e');
    }
  }
}
