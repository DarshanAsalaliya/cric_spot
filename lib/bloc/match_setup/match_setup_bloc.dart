import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:cric_spot/core/enum/opted_type.dart';
import 'package:cric_spot/core/enum/team_type.dart';
import 'package:cric_spot/model/batting/batting_lineup_model.dart';
import 'package:cric_spot/model/bowling/bowling_lineup_model.dart';
import 'package:cric_spot/model/extra/extra_run_model.dart';
import 'package:cric_spot/model/inning/inning_model.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/model/partnership/partnership_model.dart';
import 'package:cric_spot/model/player/player_model.dart';
import 'package:cric_spot/model/team/team_model.dart';

part 'match_setup_event.dart';
part 'match_setup_state.dart';
part 'part/match_setup_validation.dart';
part 'part/match_setup_settings.dart';

class MatchSetupBloc extends Bloc<MatchSetupEvent, MatchSetupState> with MatchSetupValidationMixin, MatchSetupSettingsMixin {
  final Box<PlayerModel> playerBox;
  final Box<TeamModel> teamBox;
  final Box<MatchModel> matchBox;
  final Box<InningModel> inningBox;

  MatchSetupBloc({
    required this.playerBox,
    required this.teamBox,
    required this.matchBox,
    required this.inningBox,
  }) : super(const MatchSetupState()) {
    // Validation
    on<MatchSetupValidate>(_onValidate);
    on<MatchSetupValidateOpener>(_onValidateOpener);

    // Team names
    on<MatchSetupHostTeamNameChanged>(_onHostTeamNameChanged);
    on<MatchSetupVisitorTeamNameChanged>(_onVisitorTeamNameChanged);

    // Player names
    on<MatchSetupStrikerNameChanged>(_onStrikerNameChanged);
    on<MatchSetupNonStrikerNameChanged>(_onNonStrikerNameChanged);
    on<MatchSetupOpeningBowlerNameChanged>(_onOpeningBowlerNameChanged);

    // Over
    on<MatchSetupOverChanged>(_onOverChanged);

    // Toss & opted
    on<MatchSetupTossWonChanged>(_onTossWonChanged);
    on<MatchSetupOptedChanged>(_onOptedChanged);

    // Settings
    on<MatchSetupNoBallToggled>(_onNoBallToggled);
    on<MatchSetupWideBallToggled>(_onWideBallToggled);
    on<MatchSetupNoBallReBallToggled>(_onNoBallReBallToggled);
    on<MatchSetupWideBallReBallToggled>(_onWideBallReBallToggled);
    on<MatchSetupNoBallRunChanged>(_onNoBallRunChanged);
    on<MatchSetupWideBallRunChanged>(_onWideBallRunChanged);
    on<MatchSetupPlayerPerMatchChanged>(_onPlayerPerMatchChanged);

    // Data
    on<MatchSetupLoadTeams>(_onLoadTeams);
    on<MatchSetupCreateMatch>(_onCreateMatch);
    on<MatchSetupLoadHistory>(_onLoadHistory);
    on<MatchSetupRemoveMatch>(_onRemoveMatch);
    on<MatchSetupSetIsMatchNew>(_onSetIsMatchNew);
  }

  // --- Team name handlers ---

  void _onHostTeamNameChanged(
    MatchSetupHostTeamNameChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(
      hostTeamName: event.name,
      hostTeamNameError: () => null,
    ));
  }

  void _onVisitorTeamNameChanged(
    MatchSetupVisitorTeamNameChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(
      visitorTeamName: event.name,
      visitorTeamNameError: () => null,
    ));
  }

  // --- Player name handlers ---

  void _onStrikerNameChanged(
    MatchSetupStrikerNameChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(
      strikerName: event.name,
      strikerNameError: () => null,
    ));
  }

  void _onNonStrikerNameChanged(
    MatchSetupNonStrikerNameChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(
      nonStrikerName: event.name,
      nonStrikerNameError: () => null,
    ));
  }

  void _onOpeningBowlerNameChanged(
    MatchSetupOpeningBowlerNameChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(
      openingBowlerName: event.name,
      openingBowlerNameError: () => null,
    ));
  }

  // --- Over handler ---

  void _onOverChanged(
    MatchSetupOverChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(
      over: event.over,
      overError: () => null,
    ));
  }

  // --- Toss & opted handlers ---

  void _onTossWonChanged(
    MatchSetupTossWonChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    if (event.tossWonBy != state.tossWonBy) {
      emit(state.copyWith(tossWonBy: event.tossWonBy));
    }
  }

  void _onOptedChanged(
    MatchSetupOptedChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    if (event.opted != state.opted) {
      emit(state.copyWith(opted: event.opted));
    }
  }

  // --- Data handlers ---

  void _onLoadTeams(
    MatchSetupLoadTeams event,
    Emitter<MatchSetupState> emit,
  ) {
    final teams = teamBox.values.toList();
    emit(state.copyWith(teams: teams));
  }

  Future<void> _onCreateMatch(
    MatchSetupCreateMatch event,
    Emitter<MatchSetupState> emit,
  ) async {
    emit(state.copyWith(status: MatchSetupStatus.loading));

    try {
      final matchId = await _createNewMatch();
      emit(state.copyWith(
        status: MatchSetupStatus.created,
        matchId: () => matchId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MatchSetupStatus.error,
        errorMessage: () => e.toString(),
      ));
    }
  }

  void _onLoadHistory(
    MatchSetupLoadHistory event,
    Emitter<MatchSetupState> emit,
  ) {
    final matches = matchBox.values.toList().reversed.toList();
    emit(state.copyWith(matchList: matches));
  }

  void _onRemoveMatch(
    MatchSetupRemoveMatch event,
    Emitter<MatchSetupState> emit,
  ) {
    matchBox.delete(event.key);
    final matches = matchBox.values.toList().reversed.toList();
    emit(state.copyWith(matchList: matches));
  }

  void _onSetIsMatchNew(
    MatchSetupSetIsMatchNew event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(isMatchNew: event.isMatchNew));
  }

  // --- Helper: find or create team ---

  Future<TeamModel> _getTeam(String teamName) async {
    final teams = teamBox.values.toList();
    final TeamModel team = teams.firstWhere(
      (element) => element.name == teamName,
      orElse: () => TeamModel(name: teamName, match: 0, loss: 0, win: 0),
    );
    if (team.id == null) {
      final teamId = await teamBox.add(team);
      team.id = teamId.toString();
      team.save();
    }
    return team;
  }

  // --- Core match creation logic ---

  Future<String> _createNewMatch() async {
    // Resolve teams
    final hostTeam = await _getTeam(state.hostTeamName);
    final visitorTeam = await _getTeam(state.visitorTeamName);

    // Create and persist players
    final striker = PlayerModel(name: state.strikerName);
    final nonStriker = PlayerModel(name: state.nonStrikerName);
    final bowler = PlayerModel(name: state.openingBowlerName);

    final strikerId = await playerBox.add(striker);
    striker.id = strikerId.toString();
    striker.save();

    final nonStrikerId = await playerBox.add(nonStriker);
    nonStriker.id = nonStrikerId.toString();
    nonStriker.save();

    final bowlerId = await playerBox.add(bowler);
    bowler.id = bowlerId.toString();
    bowler.save();

    // Computed team names from current state
    final batTeamName = state.batTeamName;
    final bowlTeamName = state.bowlTeamName;

    // Create match
    final match = MatchModel(
      over: state.over,
      isWideBall: state.isWideBall,
      isWideReball: state.wideReBall,
      wideRun: int.parse(state.wideBallRun),
      isNoball: state.isNoBall,
      isNoballReball: state.noBallReBall,
      noballRun: int.parse(state.noBallRun),
      hostTeamId: hostTeam.id,
      visitorTeamId: visitorTeam.id,
      tossId: state.tossWonBy == TeamType.host ? hostTeam.id : visitorTeam.id,
      tossName: state.tossWonBy == TeamType.host ? state.hostTeamName : state.visitorTeamName,
      tossElect: state.opted.name,
      firstBatTeamName: batTeamName,
      firstBatTeamScore: '0/0',
      firstBatTeamOver: '0.0',
      secondBatTeamName: bowlTeamName,
      secondBatTeamScore: '0/0',
      secondBatTeamOver: '0.0',
      playerPerMatch: state.playerPerMatch,
    );

    final matchId = await matchBox.add(match);
    match.id = matchId.toString();
    match.save();

    // Batting lineup entries for inning one
    final strikerBatting = BattingLineUpModel(
      playerId: strikerId.toString(),
      name: state.strikerName,
      run: 0,
      ball: 0,
      four: 0,
      six: 0,
      isNotOut: true,
    );
    final nonStrikerBatting = BattingLineUpModel(
      playerId: nonStrikerId.toString(),
      name: state.nonStrikerName,
      run: 0,
      ball: 0,
      four: 0,
      six: 0,
      isNotOut: true,
    );

    // Bowling lineup entry for inning one
    final bowlerBowling = BowlingLineUpModel(
      playerId: bowlerId.toString(),
      name: state.openingBowlerName,
      run: 0,
      ball: 0,
      maidan: 0,
      wicket: 0,
    );

    // Partnership for inning one
    final openingPartnership = PartnerShipModel(
      id: strikerId.toString(),
      run: 0,
      ball: 0,
      currentStiker: BattingLineUpModel(
        playerId: strikerId.toString(),
        name: state.strikerName,
        run: 0,
        ball: 0,
        four: 0,
        six: 0,
        isNotOut: true,
      ),
      currentNotStiker: BattingLineUpModel(
        playerId: nonStrikerId.toString(),
        name: state.nonStrikerName,
        run: 0,
        ball: 0,
        four: 0,
        six: 0,
        isNotOut: true,
      ),
    );

    // First inning (batting team bats)
    final inningOne = InningModel(
      matchId: matchId.toString(),
      batTeamName: batTeamName,
      bowlTeamName: bowlTeamName,
      totalRun: 0,
      totalBall: 0,
      totalWicket: 0,
      battingLineup: [strikerBatting, nonStrikerBatting],
      bowlingLineup: [bowlerBowling],
      extraRun: ExtraRunModel(
        wide: 0,
        noBall: 0,
        legBy: 0,
        by: 0,
        penlaty: 0,
        total: 0,
      ),
      currentBowler: BowlingLineUpModel(
        playerId: bowlerId.toString(),
        name: state.openingBowlerName,
        run: 0,
        ball: 0,
        maidan: 0,
        wicket: 0,
      ),
      currentStriker: BattingLineUpModel(
        playerId: strikerId.toString(),
        name: state.strikerName,
        run: 0,
        ball: 0,
        four: 0,
        six: 0,
        isNotOut: true,
      ),
      currentNonStriker: BattingLineUpModel(
        playerId: nonStrikerId.toString(),
        name: state.nonStrikerName,
        run: 0,
        ball: 0,
        four: 0,
        six: 0,
        isNotOut: true,
      ),
      overs: [],
      currentOver: [],
      partnerShips: [openingPartnership],
      currentPartnerShip: PartnerShipModel(
        id: strikerId.toString(),
        run: 0,
        ball: 0,
        currentStiker: BattingLineUpModel(
          playerId: strikerId.toString(),
          name: state.strikerName,
          run: 0,
          ball: 0,
          four: 0,
          six: 0,
          isNotOut: true,
        ),
        currentNotStiker: BattingLineUpModel(
          playerId: nonStrikerId.toString(),
          name: state.nonStrikerName,
          run: 0,
          ball: 0,
          four: 0,
          six: 0,
          isNotOut: true,
        ),
      ),
      isFirstInning: true,
      fallOfWicket: [],
    );

    // Second inning (bowling team bats, empty lineups)
    final inningTwo = InningModel(
      matchId: matchId.toString(),
      batTeamName: bowlTeamName,
      bowlTeamName: batTeamName,
      totalRun: 0,
      totalBall: 0,
      totalWicket: 0,
      battingLineup: [],
      bowlingLineup: [],
      extraRun: ExtraRunModel(
        wide: 0,
        noBall: 0,
        legBy: 0,
        by: 0,
        penlaty: 0,
        total: 0,
      ),
      currentBowler: null,
      currentStriker: null,
      currentNonStriker: null,
      overs: [],
      currentOver: [],
      partnerShips: [],
      currentPartnerShip: null,
      isFirstInning: false,
      fallOfWicket: [],
    );

    // Persist innings
    final inningOneId = await inningBox.add(inningOne);
    inningOne.id = inningOneId.toString();
    inningOne.save();

    final inningTwoId = await inningBox.add(inningTwo);
    inningTwo.id = inningTwoId.toString();
    inningTwo.save();

    // Link innings to match
    match.inningOneId = inningOneId.toString();
    match.inningTwoId = inningTwoId.toString();
    match.save();

    return matchId.toString();
  }
}
