part of 'match_setup_bloc.dart';

enum MatchSetupStatus { initial, loading, created, error }

class MatchSetupState extends Equatable {
  final List<MatchModel> matchList;
  final List<TeamModel> teams;
  final bool isNoBall;
  final bool isWideBall;
  final bool noBallReBall;
  final bool wideReBall;
  final String noBallRun;
  final String wideBallRun;
  final String playerPerMatch;
  final TeamType tossWonBy;
  final OptedType opted;
  final String hostTeamName;
  final String visitorTeamName;
  final String? hostTeamNameError;
  final String? visitorTeamNameError;
  final String strikerName;
  final String nonStrikerName;
  final String openingBowlerName;
  final String? strikerNameError;
  final String? nonStrikerNameError;
  final String? openingBowlerNameError;
  final String over;
  final String? overError;
  final bool isMatchNew;
  final MatchSetupStatus status;
  final String? matchId;
  final String? errorMessage;
  final String? tournamentId;

  const MatchSetupState({
    this.matchList = const [],
    this.teams = const [],
    this.isNoBall = true,
    this.isWideBall = true,
    this.noBallReBall = true,
    this.wideReBall = true,
    this.noBallRun = '1',
    this.wideBallRun = '1',
    this.playerPerMatch = '11',
    this.tossWonBy = TeamType.host,
    this.opted = OptedType.bat,
    this.hostTeamName = '',
    this.visitorTeamName = '',
    this.hostTeamNameError,
    this.visitorTeamNameError,
    this.strikerName = '',
    this.nonStrikerName = '',
    this.openingBowlerName = '',
    this.strikerNameError,
    this.nonStrikerNameError,
    this.openingBowlerNameError,
    this.over = '',
    this.overError,
    this.isMatchNew = true,
    this.status = MatchSetupStatus.initial,
    this.matchId,
    this.errorMessage,
    this.tournamentId,
  });

  /// Determines the batting team name based on toss winner and elected option.
  String get batTeamName {
    if ((tossWonBy == TeamType.host && opted == OptedType.bat) ||
        (tossWonBy == TeamType.visitor && opted == OptedType.bowl)) {
      return hostTeamName;
    }
    if ((tossWonBy == TeamType.host && opted == OptedType.bowl) ||
        (tossWonBy == TeamType.visitor && opted == OptedType.bat)) {
      return visitorTeamName;
    }
    return hostTeamName;
  }

  /// The bowling team is whichever team is not batting.
  String get bowlTeamName =>
      batTeamName == hostTeamName ? visitorTeamName : hostTeamName;

  /// Whether enough data has been entered to start the match.
  bool get canStartMatch =>
      hostTeamName.isNotEmpty &&
      visitorTeamName.isNotEmpty &&
      over.isNotEmpty &&
      hostTeamName != visitorTeamName;

  /// Whether opening player names have been filled in.
  bool get canSelectOpeningPlayer =>
      strikerName.isNotEmpty &&
      nonStrikerName.isNotEmpty &&
      openingBowlerName.isNotEmpty;

  MatchSetupState copyWith({
    List<MatchModel>? matchList,
    List<TeamModel>? teams,
    bool? isNoBall,
    bool? isWideBall,
    bool? noBallReBall,
    bool? wideReBall,
    String? noBallRun,
    String? wideBallRun,
    String? playerPerMatch,
    TeamType? tossWonBy,
    OptedType? opted,
    String? hostTeamName,
    String? visitorTeamName,
    String? Function()? hostTeamNameError,
    String? Function()? visitorTeamNameError,
    String? strikerName,
    String? nonStrikerName,
    String? openingBowlerName,
    String? Function()? strikerNameError,
    String? Function()? nonStrikerNameError,
    String? Function()? openingBowlerNameError,
    String? over,
    String? Function()? overError,
    bool? isMatchNew,
    MatchSetupStatus? status,
    String? Function()? matchId,
    String? Function()? errorMessage,
    String? tournamentId,
  }) {
    return MatchSetupState(
      matchList: matchList ?? this.matchList,
      teams: teams ?? this.teams,
      isNoBall: isNoBall ?? this.isNoBall,
      isWideBall: isWideBall ?? this.isWideBall,
      noBallReBall: noBallReBall ?? this.noBallReBall,
      wideReBall: wideReBall ?? this.wideReBall,
      noBallRun: noBallRun ?? this.noBallRun,
      wideBallRun: wideBallRun ?? this.wideBallRun,
      playerPerMatch: playerPerMatch ?? this.playerPerMatch,
      tossWonBy: tossWonBy ?? this.tossWonBy,
      opted: opted ?? this.opted,
      hostTeamName: hostTeamName ?? this.hostTeamName,
      visitorTeamName: visitorTeamName ?? this.visitorTeamName,
      hostTeamNameError:
          hostTeamNameError != null ? hostTeamNameError() : this.hostTeamNameError,
      visitorTeamNameError: visitorTeamNameError != null
          ? visitorTeamNameError()
          : this.visitorTeamNameError,
      strikerName: strikerName ?? this.strikerName,
      nonStrikerName: nonStrikerName ?? this.nonStrikerName,
      openingBowlerName: openingBowlerName ?? this.openingBowlerName,
      strikerNameError:
          strikerNameError != null ? strikerNameError() : this.strikerNameError,
      nonStrikerNameError: nonStrikerNameError != null
          ? nonStrikerNameError()
          : this.nonStrikerNameError,
      openingBowlerNameError: openingBowlerNameError != null
          ? openingBowlerNameError()
          : this.openingBowlerNameError,
      over: over ?? this.over,
      overError: overError != null ? overError() : this.overError,
      isMatchNew: isMatchNew ?? this.isMatchNew,
      status: status ?? this.status,
      matchId: matchId != null ? matchId() : this.matchId,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
      tournamentId: tournamentId ?? this.tournamentId,
    );
  }

  @override
  List<Object?> get props => [
        matchList,
        teams,
        isNoBall,
        isWideBall,
        noBallReBall,
        wideReBall,
        noBallRun,
        wideBallRun,
        playerPerMatch,
        tossWonBy,
        opted,
        hostTeamName,
        visitorTeamName,
        hostTeamNameError,
        visitorTeamNameError,
        strikerName,
        nonStrikerName,
        openingBowlerName,
        strikerNameError,
        nonStrikerNameError,
        openingBowlerNameError,
        over,
        overError,
        isMatchNew,
        status,
        matchId,
        errorMessage,
        tournamentId,
      ];
}
