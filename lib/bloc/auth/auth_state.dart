import 'package:cric_spot/bloc/player_profile/player_profile_state.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? displayName;
  final String? username;
  final String? errorMessage;
  final String? pendingEmail;
  // Career stats (fetched from Supabase)
  final Map<String, dynamic>? careerStats;
  // Tournaments the user is part of
  final List<Map<String, dynamic>> myTournaments;
  // Format-specific stats
  final List<FormatStats> formatStats;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.displayName,
    this.username,
    this.errorMessage,
    this.pendingEmail,
    this.careerStats,
    this.myTournaments = const [],
    this.formatStats = const [],
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? displayName,
    String? username,
    String? errorMessage,
    String? pendingEmail,
    Map<String, dynamic>? careerStats,
    List<Map<String, dynamic>>? myTournaments,
    List<FormatStats>? formatStats,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      errorMessage: errorMessage,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      careerStats: careerStats ?? this.careerStats,
      myTournaments: myTournaments ?? this.myTournaments,
      formatStats: formatStats ?? this.formatStats,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;

  // Career stat getters
  int get totalMatches => careerStats?['total_matches'] as int? ?? 0;
  int get totalRuns => careerStats?['total_runs'] as int? ?? 0;
  int get totalBallsFaced => careerStats?['total_balls_faced'] as int? ?? 0;
  int get totalFours => careerStats?['total_fours'] as int? ?? 0;
  int get totalSixes => careerStats?['total_sixes'] as int? ?? 0;
  int get highestScore => careerStats?['highest_score'] as int? ?? 0;
  int get totalInningsBatted => careerStats?['total_innings_batted'] as int? ?? 0;
  int get totalNotOuts => careerStats?['total_not_outs'] as int? ?? 0;
  int get totalFifties => careerStats?['total_fifties'] as int? ?? 0;
  int get totalHundreds => careerStats?['total_hundreds'] as int? ?? 0;
  int get totalWickets => careerStats?['total_wickets'] as int? ?? 0;
  int get totalBallsBowled => careerStats?['total_balls_bowled'] as int? ?? 0;
  int get totalRunsConceded => careerStats?['total_runs_conceded'] as int? ?? 0;
  int get totalMaidens => careerStats?['total_maidens'] as int? ?? 0;
  int get totalInningsBowled => careerStats?['total_innings_bowled'] as int? ?? 0;
  int get bestBowlingWickets => careerStats?['best_bowling_wickets'] as int? ?? 0;
  int get bestBowlingRuns => careerStats?['best_bowling_runs'] as int? ?? 0;

  double get battingAverage {
    final outs = totalInningsBatted - totalNotOuts;
    return outs > 0 ? totalRuns / outs : totalRuns.toDouble();
  }

  double get strikeRate => totalBallsFaced > 0 ? (totalRuns / totalBallsFaced) * 100 : 0;
  double get bowlingAverage => totalWickets > 0 ? totalRunsConceded / totalWickets : 0;
  double get economyRate => totalBallsBowled > 0 ? (totalRunsConceded / totalBallsBowled) * 6 : 0;
  String get bestBowling => '$bestBowlingWickets/$bestBowlingRuns';

  @override
  List<Object?> get props => [
        status,
        user,
        displayName,
        username,
        errorMessage,
        pendingEmail,
        careerStats,
        myTournaments,
        formatStats,
      ];
}
