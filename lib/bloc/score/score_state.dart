part of 'score_bloc.dart';

enum ScoreNavigationAction {
  none,
  selectBowler,
  inningEnd,
  matchWon,
}

class ScoreState {
  final int stateVersion;
  final MatchModel? matchData;
  final bool wide;
  final bool noBall;
  final bool byes;
  final bool legByes;
  final bool wicket;
  final InningModel? inningOne;
  final InningModel? inningTwo;
  final InningModel? currentInning;
  final int totalRun;
  final int totalBall;
  final int totalWicket;
  final ExtraRunModel? extraRun;
  final BattingLineUpModel? striker;
  final BattingLineUpModel? nonStriker;
  final BowlingLineUpModel? bowler;
  final PartnerShipModel? currentPartnerShip;
  final List<String> currentOver;
  final String whoGotOut;
  final String whoHelped;
  final String newBowler;
  final String newBatsman;
  final String supporterPlayer;
  final bool isLoad;
  final int target;
  final int overLength;
  final WicketType wicketType;
  final RunCountType runCountType;
  final bool scoreBoardOneIsOpen;
  final bool scoreBoardTwoIsOpen;
  final ScoreNavigationAction navigationAction;

  const ScoreState({
    this.stateVersion = 0,
    this.matchData,
    this.wide = false,
    this.noBall = false,
    this.byes = false,
    this.legByes = false,
    this.wicket = false,
    this.inningOne,
    this.inningTwo,
    this.currentInning,
    this.totalRun = 0,
    this.totalBall = 0,
    this.totalWicket = 0,
    this.extraRun,
    this.striker,
    this.nonStriker,
    this.bowler,
    this.currentPartnerShip,
    this.currentOver = const [],
    this.whoGotOut = '',
    this.whoHelped = '',
    this.newBowler = '',
    this.newBatsman = '',
    this.supporterPlayer = '',
    this.isLoad = false,
    this.target = 0,
    this.overLength = 0,
    this.wicketType = WicketType.bowled,
    this.runCountType = RunCountType.noramlRun,
    this.scoreBoardOneIsOpen = true,
    this.scoreBoardTwoIsOpen = true,
    this.navigationAction = ScoreNavigationAction.none,
  });

  /// Computed getter for bat team name (first inning)
  String get batTeamName => inningOne?.batTeamName ?? '';

  /// Computed getter for bowl team name (first inning)
  String get bowlTeamName => inningOne?.bowlTeamName ?? '';

  ScoreState copyWith({
    int? stateVersion,
    MatchModel? matchData,
    bool? wide,
    bool? noBall,
    bool? byes,
    bool? legByes,
    bool? wicket,
    InningModel? inningOne,
    InningModel? inningTwo,
    InningModel? currentInning,
    int? totalRun,
    int? totalBall,
    int? totalWicket,
    ExtraRunModel? extraRun,
    BattingLineUpModel? striker,
    BattingLineUpModel? nonStriker,
    BowlingLineUpModel? bowler,
    PartnerShipModel? currentPartnerShip,
    List<String>? currentOver,
    String? whoGotOut,
    String? whoHelped,
    String? newBowler,
    String? newBatsman,
    String? supporterPlayer,
    bool? isLoad,
    int? target,
    int? overLength,
    WicketType? wicketType,
    RunCountType? runCountType,
    bool? scoreBoardOneIsOpen,
    bool? scoreBoardTwoIsOpen,
    ScoreNavigationAction? navigationAction,
  }) {
    return ScoreState(
      stateVersion: stateVersion ?? this.stateVersion,
      matchData: matchData ?? this.matchData,
      wide: wide ?? this.wide,
      noBall: noBall ?? this.noBall,
      byes: byes ?? this.byes,
      legByes: legByes ?? this.legByes,
      wicket: wicket ?? this.wicket,
      inningOne: inningOne ?? this.inningOne,
      inningTwo: inningTwo ?? this.inningTwo,
      currentInning: currentInning ?? this.currentInning,
      totalRun: totalRun ?? this.totalRun,
      totalBall: totalBall ?? this.totalBall,
      totalWicket: totalWicket ?? this.totalWicket,
      extraRun: extraRun ?? this.extraRun,
      striker: striker ?? this.striker,
      nonStriker: nonStriker ?? this.nonStriker,
      bowler: bowler ?? this.bowler,
      currentPartnerShip: currentPartnerShip ?? this.currentPartnerShip,
      currentOver: currentOver ?? this.currentOver,
      whoGotOut: whoGotOut ?? this.whoGotOut,
      whoHelped: whoHelped ?? this.whoHelped,
      newBowler: newBowler ?? this.newBowler,
      newBatsman: newBatsman ?? this.newBatsman,
      supporterPlayer: supporterPlayer ?? this.supporterPlayer,
      isLoad: isLoad ?? this.isLoad,
      target: target ?? this.target,
      overLength: overLength ?? this.overLength,
      wicketType: wicketType ?? this.wicketType,
      runCountType: runCountType ?? this.runCountType,
      scoreBoardOneIsOpen: scoreBoardOneIsOpen ?? this.scoreBoardOneIsOpen,
      scoreBoardTwoIsOpen: scoreBoardTwoIsOpen ?? this.scoreBoardTwoIsOpen,
      navigationAction: navigationAction ?? this.navigationAction,
    );
  }
}
