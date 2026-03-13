enum TournamentStatus { initial, loading, loaded, creating, error }

class TournamentState {
  final TournamentStatus status;
  final List<Map<String, dynamic>> tournaments;
  final Map<String, dynamic>? selectedTournament;
  final List<Map<String, dynamic>> tournamentTeams;
  final List<Map<String, dynamic>> tournamentMatches;
  // Player search results
  final List<Map<String, dynamic>> searchResults;
  final bool isSearching;
  // Team players (team_id -> list of players)
  final Map<String, List<Map<String, dynamic>>> teamPlayers;
  final String? errorMessage;

  const TournamentState({
    this.status = TournamentStatus.initial,
    this.tournaments = const [],
    this.selectedTournament,
    this.tournamentTeams = const [],
    this.tournamentMatches = const [],
    this.searchResults = const [],
    this.isSearching = false,
    this.teamPlayers = const {},
    this.errorMessage,
  });

  TournamentState copyWith({
    TournamentStatus? status,
    List<Map<String, dynamic>>? tournaments,
    Map<String, dynamic>? selectedTournament,
    List<Map<String, dynamic>>? tournamentTeams,
    List<Map<String, dynamic>>? tournamentMatches,
    List<Map<String, dynamic>>? searchResults,
    bool? isSearching,
    Map<String, List<Map<String, dynamic>>>? teamPlayers,
    String? errorMessage,
  }) {
    return TournamentState(
      status: status ?? this.status,
      tournaments: tournaments ?? this.tournaments,
      selectedTournament: selectedTournament ?? this.selectedTournament,
      tournamentTeams: tournamentTeams ?? this.tournamentTeams,
      tournamentMatches: tournamentMatches ?? this.tournamentMatches,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      teamPlayers: teamPlayers ?? this.teamPlayers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
