import 'dart:developer';

import 'package:cric_spot/bloc/tournament/tournament_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentCubit extends Cubit<TournamentState> {
  TournamentCubit() : super(const TournamentState());

  final SupabaseClient _client = Supabase.instance.client;

  /// Load all tournaments for the current user.
  Future<void> loadTournaments() async {
    emit(state.copyWith(status: TournamentStatus.loading));
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: TournamentStatus.error, errorMessage: 'Not authenticated'));
        return;
      }

      final response = await _client
          .from('tournaments')
          .select()
          .eq('created_by', userId)
          .order('created_at', ascending: false);

      emit(state.copyWith(
        status: TournamentStatus.loaded,
        tournaments: List<Map<String, dynamic>>.from(response),
      ));
    } catch (e) {
      log('TournamentCubit.loadTournaments error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
    }
  }

  /// Create a new tournament. Returns the tournament ID.
  Future<String?> createTournament({
    required String name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(state.copyWith(status: TournamentStatus.creating));
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: TournamentStatus.error, errorMessage: 'Not authenticated'));
        return null;
      }

      final response = await _client.from('tournaments').insert({
        'name': name,
        'created_by': userId,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'status': 'upcoming',
      }).select('id').single();

      await loadTournaments();
      return response['id'] as String;
    } catch (e) {
      log('TournamentCubit.createTournament error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
      return null;
    }
  }

  /// Load tournament details including teams, team players, and matches.
  Future<void> loadTournamentDetail(String tournamentId) async {
    emit(state.copyWith(status: TournamentStatus.loading));
    try {
      final tournament = await _client
          .from('tournaments')
          .select()
          .eq('id', tournamentId)
          .single();

      final teams = await _client
          .from('tournament_teams')
          .select('*, teams(*)')
          .eq('tournament_id', tournamentId);

      final matches = await _client
          .from('matches')
          .select()
          .eq('tournament_id', tournamentId)
          .order('created_at', ascending: false);

      // Load players for each team
      final teamPlayerMap = <String, List<Map<String, dynamic>>>{};
      for (final tt in teams) {
        final teamId = tt['team_id'] as String;
        final players = await _client
            .from('team_players')
            .select('*, players(*)')
            .eq('team_id', teamId);
        teamPlayerMap[teamId] = List<Map<String, dynamic>>.from(players);
      }

      emit(state.copyWith(
        status: TournamentStatus.loaded,
        selectedTournament: tournament,
        tournamentTeams: List<Map<String, dynamic>>.from(teams),
        tournamentMatches: List<Map<String, dynamic>>.from(matches),
        teamPlayers: teamPlayerMap,
      ));
    } catch (e) {
      log('TournamentCubit.loadTournamentDetail error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
    }
  }

  /// Create a new team and add it to the tournament.
  Future<void> createTeamForTournament(String tournamentId, String teamName) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      // Create team in Supabase
      final teamResponse = await _client.from('teams').insert({
        'name': teamName,
        'created_by': userId,
      }).select('id').single();

      final teamId = teamResponse['id'] as String;

      // Add to tournament
      await _client.from('tournament_teams').insert({
        'tournament_id': tournamentId,
        'team_id': teamId,
      });

      await loadTournamentDetail(tournamentId);
    } catch (e) {
      log('TournamentCubit.createTeamForTournament error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
    }
  }

  /// Add an existing team to a tournament.
  Future<void> addTeamToTournament(String tournamentId, String teamId) async {
    try {
      await _client.from('tournament_teams').insert({
        'tournament_id': tournamentId,
        'team_id': teamId,
      });
      await loadTournamentDetail(tournamentId);
    } catch (e) {
      log('TournamentCubit.addTeamToTournament error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
    }
  }

  /// Remove a team from a tournament.
  Future<void> removeTeamFromTournament(String tournamentId, String teamId) async {
    try {
      await _client
          .from('tournament_teams')
          .delete()
          .eq('tournament_id', tournamentId)
          .eq('team_id', teamId);
      await loadTournamentDetail(tournamentId);
    } catch (e) {
      log('TournamentCubit.removeTeamFromTournament error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
    }
  }

  /// Search players by name or username (for adding to teams).
  Future<void> searchPlayers(String query) async {
    if (query.trim().length < 2) {
      emit(state.copyWith(searchResults: const [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));
    try {
      final results = await _client.rpc('search_players', params: {
        'search_term': query.trim(),
      });
      emit(state.copyWith(
        searchResults: List<Map<String, dynamic>>.from(results),
        isSearching: false,
      ));
    } catch (e) {
      log('TournamentCubit.searchPlayers error: $e');
      // Fallback: simple name search
      try {
        final results = await _client
            .from('players')
            .select('id, name, total_matches, total_runs, total_wickets')
            .ilike('name', '%${query.trim()}%')
            .limit(20);
        emit(state.copyWith(
          searchResults: List<Map<String, dynamic>>.from(results),
          isSearching: false,
        ));
      } catch (_) {
        emit(state.copyWith(searchResults: const [], isSearching: false));
      }
    }
  }

  /// Clear search results.
  void clearSearch() {
    emit(state.copyWith(searchResults: const [], isSearching: false));
  }

  /// Add a player to a team.
  Future<void> addPlayerToTeam(String teamId, String playerId) async {
    try {
      await _client.from('team_players').insert({
        'team_id': teamId,
        'player_id': playerId,
      });
      // Refresh team players
      final players = await _client
          .from('team_players')
          .select('*, players(*)')
          .eq('team_id', teamId);
      final updated = Map<String, List<Map<String, dynamic>>>.from(state.teamPlayers);
      updated[teamId] = List<Map<String, dynamic>>.from(players);
      emit(state.copyWith(teamPlayers: updated));
    } catch (e) {
      log('TournamentCubit.addPlayerToTeam error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: 'Player already in team or error'));
    }
  }

  /// Create a new player and add to team.
  Future<void> createPlayerForTeam(String teamId, String playerName) async {
    try {
      final userId = _client.auth.currentUser?.id;
      final playerResponse = await _client.from('players').insert({
        'name': playerName,
        'created_by': userId,
      }).select('id').single();

      await addPlayerToTeam(teamId, playerResponse['id'] as String);
    } catch (e) {
      log('TournamentCubit.createPlayerForTeam error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
    }
  }

  /// Remove a player from a team.
  Future<void> removePlayerFromTeam(String teamId, String playerId) async {
    try {
      await _client
          .from('team_players')
          .delete()
          .eq('team_id', teamId)
          .eq('player_id', playerId);
      final players = await _client
          .from('team_players')
          .select('*, players(*)')
          .eq('team_id', teamId);
      final updated = Map<String, List<Map<String, dynamic>>>.from(state.teamPlayers);
      updated[teamId] = List<Map<String, dynamic>>.from(players);
      emit(state.copyWith(teamPlayers: updated));
    } catch (e) {
      log('TournamentCubit.removePlayerFromTeam error: $e');
    }
  }

  /// Create a match in Supabase for this tournament.
  /// Returns the Supabase match ID (remote UUID).
  Future<String?> createTournamentMatch({
    required String tournamentId,
    required String teamAId,
    required String teamBId,
    required String teamAName,
    required String teamBName,
    required int overs,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final format = overs == 10
          ? 't10'
          : overs <= 20
              ? 't20'
              : overs <= 50
                  ? 'odi'
                  : 'custom';

      final response = await _client.from('matches').insert({
        'created_by': userId,
        'tournament_id': tournamentId,
        'overs': overs,
        'match_format': format,
        'host_team_id': teamAId,
        'visitor_team_id': teamBId,
        'first_bat_team_name': teamAName,
        'second_bat_team_name': teamBName,
        'status': 'upcoming',
      }).select('id, share_code').single();

      await loadTournamentDetail(tournamentId);
      return response['id'] as String?;
    } catch (e) {
      log('TournamentCubit.createTournamentMatch error: $e');
      emit(state.copyWith(status: TournamentStatus.error, errorMessage: e.toString()));
      return null;
    }
  }

  /// Get players for a specific team in the tournament.
  List<Map<String, dynamic>> getTeamPlayers(String teamId) {
    return state.teamPlayers[teamId] ?? [];
  }
}
