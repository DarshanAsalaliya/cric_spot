import 'dart:developer';

import 'package:cric_spot/core/enum/run_count_type.dart';
import 'package:cric_spot/core/enum/wicket_type.dart';
import 'package:cric_spot/model/batting/batting_lineup_model.dart';
import 'package:cric_spot/model/bowling/bowling_lineup_model.dart';
import 'package:cric_spot/model/extra/extra_run_model.dart';
import 'package:cric_spot/model/inning/inning_model.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/model/partnership/partnership_model.dart';
import 'package:cric_spot/model/player/player_model.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'score_state.dart';
part 'score_event.dart';
part 'part/score_helpers.dart';
part 'part/score_count_run.dart';
part 'part/score_undo.dart';
part 'part/score_wicket.dart';
part 'part/score_inning.dart';
part 'part/score_bowler.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  final Box<PlayerModel> playerBox;
  final Box<TeamModel> teamBox;
  final Box<MatchModel> matchBox;
  final Box<InningModel> inningBox;

  // --- Mutable instance variables (same as MobX observables) ---
  MatchModel? matchData;
  bool wide = false;
  bool noBall = false;
  bool byes = false;
  bool legByes = false;
  bool wicket = false;
  InningModel? inningOne;
  InningModel? inningTwo;
  InningModel? currentInning;
  int totalRun = 0;
  int totalBall = 0;
  int totalWicket = 0;
  ExtraRunModel? extraRun;
  BattingLineUpModel? striker;
  BattingLineUpModel? nonStriker;
  BowlingLineUpModel? bowler;
  PartnerShipModel? currentPartnerShip;
  List<String> currentOver = [];
  String whoGotOut = '';
  String whoHelped = '';
  String newBowler = '';
  String newBatsman = '';
  String supporterPlayer = '';
  bool isLoad = false;
  int target = 0;
  int overLength = 0;
  WicketType wicketType = WicketType.bowled;
  RunCountType runCountType = RunCountType.noramlRun;
  bool scoreBoardOneIsOpen = true;
  bool scoreBoardTwoIsOpen = true;
  ScoreNavigationAction navigationAction = ScoreNavigationAction.none;
  PlayerModel? _pendingNewPlayer;

  int _stateVersion = 0;

  ScoreBloc({
    required this.playerBox,
    required this.teamBox,
    required this.matchBox,
    required this.inningBox,
  }) : super(const ScoreState()) {
    // Data loading
    on<LoadMatchData>(_onLoadMatchData);

    // Toggles
    on<ToggleWide>(_onToggleWide);
    on<ToggleNoBall>(_onToggleNoBall);
    on<ToggleByes>(_onToggleByes);
    on<ToggleLegByes>(_onToggleLegByes);
    on<ToggleWicket>(_onToggleWicket);

    // Run counting
    on<CountRun>(_onCountRun);
    on<UndoRun>(_onUndoRun);

    // Bowler
    on<SelectNewBowler>(_onSelectNewBowler);
    on<NewBowlerNameChanged>(_onNewBowlerNameChanged);

    // Batsman
    on<NewBatsmanNameChanged>(_onNewBatsmanNameChanged);

    // Wicket
    on<FallOfWicket>(_onFallOfWicket);
    on<WicketTypeChanged>(_onWicketTypeChanged);
    on<WhoGotOutChanged>(_onWhoGotOutChanged);
    on<SupporterPlayerChanged>(_onSupporterPlayerChanged);

    // Swap
    on<SwapBatsman>(_onSwapBatsman);

    // Inning
    on<ChangeInning>(_onChangeInning);
    on<WonMatch>(_onWonMatch);

    // Save
    on<SaveData>(_onSaveData);
    on<SaveBeforeExit>(_onSaveBeforeExit);

    // Scoreboard toggles
    on<ToggleScoreBoardOne>(_onToggleScoreBoardOne);
    on<ToggleScoreBoardTwo>(_onToggleScoreBoardTwo);

    // Navigation
    on<ClearNavigation>(_onClearNavigation);
  }

  /// Creates a new ScoreState snapshot from current instance variables.
  ScoreState _emitState() {
    _stateVersion++;
    return ScoreState(
      stateVersion: _stateVersion,
      matchData: matchData,
      wide: wide,
      noBall: noBall,
      byes: byes,
      legByes: legByes,
      wicket: wicket,
      inningOne: inningOne,
      inningTwo: inningTwo,
      currentInning: currentInning,
      totalRun: totalRun,
      totalBall: totalBall,
      totalWicket: totalWicket,
      extraRun: extraRun,
      striker: striker,
      nonStriker: nonStriker,
      bowler: bowler,
      currentPartnerShip: currentPartnerShip,
      currentOver: List<String>.from(currentOver),
      whoGotOut: whoGotOut,
      whoHelped: whoHelped,
      newBowler: newBowler,
      newBatsman: newBatsman,
      supporterPlayer: supporterPlayer,
      isLoad: isLoad,
      target: target,
      overLength: overLength,
      wicketType: wicketType,
      runCountType: runCountType,
      scoreBoardOneIsOpen: scoreBoardOneIsOpen,
      scoreBoardTwoIsOpen: scoreBoardTwoIsOpen,
      navigationAction: navigationAction,
    );
  }

  // --- Simple event handlers ---

  void _onLoadMatchData(LoadMatchData event, Emitter<ScoreState> emit) {
    isLoad = true;
    emit(_emitState());
    if (matchData == null || matchData!.id != event.matchId) {
      print("score_bloc.dart calling _onLoadMatchData");
      matchData = matchBox.get(int.parse(event.matchId));
      inningOne = inningBox.get(int.parse(matchData!.inningOneId!));
      inningTwo = inningBox.get(int.parse(matchData!.inningTwoId!));
      if (inningOne!.totalBall! == (int.parse(matchData!.over!) * 6) ||
          inningOne!.totalWicket == (int.parse(matchData!.playerPerMatch!) - 1)) {
        currentInning = inningTwo;
        target = inningOne!.totalRun! + 1;
      } else {
        currentInning = inningOne;
      }
      totalRun = currentInning!.totalRun!;
      totalBall = currentInning!.totalBall!;
      totalWicket = currentInning!.totalWicket!;
      extraRun = currentInning?.extraRun;
      striker = currentInning?.currentStriker;
      nonStriker = currentInning?.currentNonStriker;
      bowler = currentInning?.currentBowler;
      currentOver = currentInning?.currentOver ?? [];
      overLength = currentInning!.totalBall! % 6 == 0
          ? currentInning!.totalBall! == 0
              ? 0
              : 6
          : currentInning!.totalBall! % 6;
      currentPartnerShip = currentInning!.currentPartnerShip;
    }
    isLoad = false;
    emit(_emitState());
  }

  void _onToggleWide(ToggleWide event, Emitter<ScoreState> emit) {
    wide = !wide;
    noBall = false;
    legByes = false;
    byes = false;
    selectRunType();
    emit(_emitState());
  }

  void _onToggleNoBall(ToggleNoBall event, Emitter<ScoreState> emit) {
    noBall = !noBall;
    wide = false;
    selectRunType();
    emit(_emitState());
  }

  void _onToggleByes(ToggleByes event, Emitter<ScoreState> emit) {
    byes = !byes;
    wide = false;
    legByes = false;
    selectRunType();
    emit(_emitState());
  }

  void _onToggleLegByes(ToggleLegByes event, Emitter<ScoreState> emit) {
    legByes = !legByes;
    wide = false;
    byes = false;
    selectRunType();
    emit(_emitState());
  }

  void _onToggleWicket(ToggleWicket event, Emitter<ScoreState> emit) {
    wicket = !wicket;
    selectRunType();
    emit(_emitState());
  }

  void _onNewBowlerNameChanged(NewBowlerNameChanged event, Emitter<ScoreState> emit) {
    newBowler = event.name;
    emit(_emitState());
  }

  void _onNewBatsmanNameChanged(NewBatsmanNameChanged event, Emitter<ScoreState> emit) {
    newBatsman = event.name;
    emit(_emitState());
  }

  void _onWicketTypeChanged(WicketTypeChanged event, Emitter<ScoreState> emit) {
    wicketType = event.type;
    emit(_emitState());
  }

  void _onWhoGotOutChanged(WhoGotOutChanged event, Emitter<ScoreState> emit) {
    whoGotOut = event.playerId;
    emit(_emitState());
  }

  void _onSupporterPlayerChanged(SupporterPlayerChanged event, Emitter<ScoreState> emit) {
    supporterPlayer = event.name;
    emit(_emitState());
  }

  void _onSwapBatsman(SwapBatsman event, Emitter<ScoreState> emit) {
    swapBatsMan();
    emit(_emitState());
  }

  void _onSaveData(SaveData event, Emitter<ScoreState> emit) {
    saveData();
    emit(_emitState());
  }

  void _onSaveBeforeExit(SaveBeforeExit event, Emitter<ScoreState> emit) {
    lastSave();
    lastSavePartnership();
    saveData();
    emit(_emitState());
  }

  void _onClearNavigation(ClearNavigation event, Emitter<ScoreState> emit) {
    navigationAction = ScoreNavigationAction.none;
    emit(_emitState());
  }

  void _onToggleScoreBoardOne(ToggleScoreBoardOne event, Emitter<ScoreState> emit) {
    scoreBoardOneIsOpen = !scoreBoardOneIsOpen;
    emit(_emitState());
  }

  void _onToggleScoreBoardTwo(ToggleScoreBoardTwo event, Emitter<ScoreState> emit) {
    scoreBoardTwoIsOpen = !scoreBoardTwoIsOpen;
    emit(_emitState());
  }

  // --- Internal toggle helpers (called after count run, not emitting state) ---

  void _changeWide() {
    wide = !wide;
    noBall = false;
    legByes = false;
    byes = false;
    selectRunType();
  }

  void _changeNoball() {
    noBall = !noBall;
    wide = false;
    selectRunType();
  }

  void _changeLegbyes() {
    legByes = !legByes;
    wide = false;
    byes = false;
    selectRunType();
  }

  void _changeByes() {
    byes = !byes;
    wide = false;
    legByes = false;
    selectRunType();
  }

  void _changeWicket() {
    wicket = !wicket;
    selectRunType();
  }
}
