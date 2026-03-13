enum PlayerProfileStatus { initial, loading, loaded, error }

class FormatStats {
  final String format;
  final String label;
  final int matches;
  final int inningsBatted;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final int highestScore;
  final int notOuts;
  final int fifties;
  final int hundreds;
  final int inningsBowled;
  final int wickets;
  final int ballsBowled;
  final int runsConceded;
  final int maidens;
  final int bestBowlingWickets;
  final int bestBowlingRuns;

  const FormatStats({
    required this.format,
    required this.label,
    this.matches = 0,
    this.inningsBatted = 0,
    this.runs = 0,
    this.ballsFaced = 0,
    this.fours = 0,
    this.sixes = 0,
    this.highestScore = 0,
    this.notOuts = 0,
    this.fifties = 0,
    this.hundreds = 0,
    this.inningsBowled = 0,
    this.wickets = 0,
    this.ballsBowled = 0,
    this.runsConceded = 0,
    this.maidens = 0,
    this.bestBowlingWickets = 0,
    this.bestBowlingRuns = 0,
  });

  double get battingAverage {
    final outs = inningsBatted - notOuts;
    return outs > 0 ? runs / outs : runs.toDouble();
  }

  double get strikeRate =>
      ballsFaced > 0 ? (runs / ballsFaced) * 100 : 0;

  double get bowlingAverage =>
      wickets > 0 ? runsConceded / wickets : 0;

  double get economyRate =>
      ballsBowled > 0 ? (runsConceded / ballsBowled) * 6 : 0;

  String get bestBowling => '$bestBowlingWickets/$bestBowlingRuns';

  factory FormatStats.fromMap(Map<String, dynamic> map) {
    final format = map['match_format'] as String? ?? 'custom';
    String label;
    switch (format) {
      case 't10': label = 'T10'; break;
      case 't20': label = 'T20'; break;
      case 'odi': label = 'ODI'; break;
      default: label = 'Custom';
    }
    return FormatStats(
      format: format,
      label: label,
      matches: map['matches'] as int? ?? 0,
      inningsBatted: map['innings_batted'] as int? ?? 0,
      runs: map['runs'] as int? ?? 0,
      ballsFaced: map['balls_faced'] as int? ?? 0,
      fours: map['fours'] as int? ?? 0,
      sixes: map['sixes'] as int? ?? 0,
      highestScore: map['highest_score'] as int? ?? 0,
      notOuts: map['not_outs'] as int? ?? 0,
      fifties: map['fifties'] as int? ?? 0,
      hundreds: map['hundreds'] as int? ?? 0,
      inningsBowled: map['innings_bowled'] as int? ?? 0,
      wickets: map['wickets'] as int? ?? 0,
      ballsBowled: map['balls_bowled'] as int? ?? 0,
      runsConceded: map['runs_conceded'] as int? ?? 0,
      maidens: map['maidens'] as int? ?? 0,
      bestBowlingWickets: map['best_bowling_wickets'] as int? ?? 0,
      bestBowlingRuns: map['best_bowling_runs'] as int? ?? 0,
    );
  }
}

class PlayerProfileState {
  final PlayerProfileStatus status;
  final String? playerName;
  final int totalMatches;
  final int totalInningsBatted;
  final int totalInningsBowled;
  // Batting
  final int totalRuns;
  final int totalBallsFaced;
  final int totalFours;
  final int totalSixes;
  final int highestScore;
  final int totalNotOuts;
  final int totalFifties;
  final int totalHundreds;
  // Bowling
  final int totalWickets;
  final int totalBallsBowled;
  final int totalRunsConceded;
  final int totalMaidens;
  final int bestBowlingWickets;
  final int bestBowlingRuns;
  // Format stats
  final List<FormatStats> formatStats;
  // Error
  final String? errorMessage;

  const PlayerProfileState({
    this.status = PlayerProfileStatus.initial,
    this.playerName,
    this.totalMatches = 0,
    this.totalInningsBatted = 0,
    this.totalInningsBowled = 0,
    this.totalRuns = 0,
    this.totalBallsFaced = 0,
    this.totalFours = 0,
    this.totalSixes = 0,
    this.highestScore = 0,
    this.totalNotOuts = 0,
    this.totalFifties = 0,
    this.totalHundreds = 0,
    this.totalWickets = 0,
    this.totalBallsBowled = 0,
    this.totalRunsConceded = 0,
    this.totalMaidens = 0,
    this.bestBowlingWickets = 0,
    this.bestBowlingRuns = 0,
    this.formatStats = const [],
    this.errorMessage,
  });

  double get battingAverage {
    final outs = totalInningsBatted - totalNotOuts;
    return outs > 0 ? totalRuns / outs : totalRuns.toDouble();
  }

  double get strikeRate =>
      totalBallsFaced > 0 ? (totalRuns / totalBallsFaced) * 100 : 0;

  double get bowlingAverage =>
      totalWickets > 0 ? totalRunsConceded / totalWickets : 0;

  double get economyRate =>
      totalBallsBowled > 0 ? (totalRunsConceded / totalBallsBowled) * 6 : 0;

  String get bestBowling => '$bestBowlingWickets/$bestBowlingRuns';

  PlayerProfileState copyWith({
    PlayerProfileStatus? status,
    String? playerName,
    int? totalMatches,
    int? totalInningsBatted,
    int? totalInningsBowled,
    int? totalRuns,
    int? totalBallsFaced,
    int? totalFours,
    int? totalSixes,
    int? highestScore,
    int? totalNotOuts,
    int? totalFifties,
    int? totalHundreds,
    int? totalWickets,
    int? totalBallsBowled,
    int? totalRunsConceded,
    int? totalMaidens,
    int? bestBowlingWickets,
    int? bestBowlingRuns,
    List<FormatStats>? formatStats,
    String? errorMessage,
  }) {
    return PlayerProfileState(
      status: status ?? this.status,
      playerName: playerName ?? this.playerName,
      totalMatches: totalMatches ?? this.totalMatches,
      totalInningsBatted: totalInningsBatted ?? this.totalInningsBatted,
      totalInningsBowled: totalInningsBowled ?? this.totalInningsBowled,
      totalRuns: totalRuns ?? this.totalRuns,
      totalBallsFaced: totalBallsFaced ?? this.totalBallsFaced,
      totalFours: totalFours ?? this.totalFours,
      totalSixes: totalSixes ?? this.totalSixes,
      highestScore: highestScore ?? this.highestScore,
      totalNotOuts: totalNotOuts ?? this.totalNotOuts,
      totalFifties: totalFifties ?? this.totalFifties,
      totalHundreds: totalHundreds ?? this.totalHundreds,
      totalWickets: totalWickets ?? this.totalWickets,
      totalBallsBowled: totalBallsBowled ?? this.totalBallsBowled,
      totalRunsConceded: totalRunsConceded ?? this.totalRunsConceded,
      totalMaidens: totalMaidens ?? this.totalMaidens,
      bestBowlingWickets: bestBowlingWickets ?? this.bestBowlingWickets,
      bestBowlingRuns: bestBowlingRuns ?? this.bestBowlingRuns,
      formatStats: formatStats ?? this.formatStats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
