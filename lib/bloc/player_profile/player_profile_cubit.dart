import 'dart:developer';

import 'package:cric_spot/bloc/player_profile/player_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerProfileCubit extends Cubit<PlayerProfileState> {
  PlayerProfileCubit() : super(const PlayerProfileState());

  final SupabaseClient _client = Supabase.instance.client;

  /// Load career stats for a player by their remote UUID.
  Future<void> loadProfile(String playerId) async {
    emit(state.copyWith(status: PlayerProfileStatus.loading));

    try {
      final response = await _client
          .from('players')
          .select()
          .eq('id', playerId)
          .maybeSingle();

      if (response == null) {
        emit(state.copyWith(
          status: PlayerProfileStatus.error,
          errorMessage: 'Player not found',
        ));
        return;
      }

      emit(PlayerProfileState(
        status: PlayerProfileStatus.loaded,
        playerName: response['name'] as String?,
        totalMatches: response['total_matches'] as int? ?? 0,
        totalInningsBatted: response['total_innings_batted'] as int? ?? 0,
        totalInningsBowled: response['total_innings_bowled'] as int? ?? 0,
        totalRuns: response['total_runs'] as int? ?? 0,
        totalBallsFaced: response['total_balls_faced'] as int? ?? 0,
        totalFours: response['total_fours'] as int? ?? 0,
        totalSixes: response['total_sixes'] as int? ?? 0,
        highestScore: response['highest_score'] as int? ?? 0,
        totalNotOuts: response['total_not_outs'] as int? ?? 0,
        totalFifties: response['total_fifties'] as int? ?? 0,
        totalHundreds: response['total_hundreds'] as int? ?? 0,
        totalWickets: response['total_wickets'] as int? ?? 0,
        totalBallsBowled: response['total_balls_bowled'] as int? ?? 0,
        totalRunsConceded: response['total_runs_conceded'] as int? ?? 0,
        totalMaidens: response['total_maidens'] as int? ?? 0,
        bestBowlingWickets: response['best_bowling_wickets'] as int? ?? 0,
        bestBowlingRuns: response['best_bowling_runs'] as int? ?? 0,
      ));

      // Load format-specific stats
      _loadFormatStats(playerId);
    } catch (e) {
      log('PlayerProfileCubit.loadProfile error: $e');
      emit(state.copyWith(
        status: PlayerProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _loadFormatStats(String playerId) async {
    try {
      final results = await _client.rpc('get_player_format_stats', params: {
        'p_player_id': playerId,
      });
      final stats = (results as List)
          .map((r) => FormatStats.fromMap(Map<String, dynamic>.from(r)))
          .toList();
      emit(state.copyWith(formatStats: stats));
    } catch (e) {
      log('PlayerProfileCubit._loadFormatStats error: $e');
      // Non-fatal — format stats are optional
    }
  }
}
