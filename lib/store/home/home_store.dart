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
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  Box<PlayerModel> playerBox;
  Box<TeamModel> teamBox;
  Box<MatchModel> matchBox;
  Box<InningModel> inningBox;

  _HomeStore(this.playerBox, this.teamBox, this.matchBox, this.inningBox);

  @observable
  List<MatchModel> matchList = [];

  @observable
  List<TeamModel> teams = [];

  @observable
  int selectedIndex = 0;

  @observable
  bool isNoBall = true;

  @observable
  bool isWideBall = true;

  @observable
  bool noBallReBall = true;

  @observable
  bool wideReBall = true;

  @observable
  String noBallRun = '1';

  @observable
  String wideBallRun = '1';

  @observable
  String playerPerMatch = '11';

  @observable
  TeamType tossWonBy = TeamType.host;

  @observable
  OptedType opted = OptedType.bat;

  @observable
  String hostTeamName = '';

  @observable
  String? hostTeamNameError;

  @observable
  String visitorTeamName = '';

  @observable
  String? visitorTeamNameError;

  @observable
  String strikerName = '';

  @observable
  String? strikerNameError;

  @observable
  String nonStrikerName = '';

  @observable
  String? nonStrikerNameError;

  @observable
  String openingBowlerName = '';

  @observable
  String? openingBowlerNameError;

  @observable
  String over = '';

  @observable
  String? overError;

  @observable
  bool isMatchNew = true;

  @computed
  String get batTeamName => tossWonBy.name == 'host' && opted.name == 'bat' ||
          tossWonBy.name == 'visitor' && opted.name == 'bowl'
      ? hostTeamName
      : tossWonBy.name == 'host' && opted.name == 'bowl' ||
              tossWonBy.name == 'visitor' && opted.name == 'bat'
          ? visitorTeamName
          : hostTeamName;

  @computed
  String get bowlTeamName =>
      batTeamName == hostTeamName ? visitorTeamName : hostTeamName;

  @computed
  bool get canStartMatch =>
      hostTeamName != '' &&
      visitorTeamName != '' &&
      over != '' &&
      hostTeamName != visitorTeamName;

  @computed
  bool get canSelectOpeningPlayer =>
      strikerName != '' && nonStrikerName != '' && openingBowlerName != '';

  @action
  void validate() {
    if (hostTeamName == '') {
      hostTeamNameError = "This field is require";
    }
    if (visitorTeamName == '') {
      visitorTeamNameError = "This field is required";
    }
    if (over == '') {
      print(over);
      overError = "This field is required";
    }
    if (hostTeamName == visitorTeamName) {
      visitorTeamNameError = "Both team should be diffrent";
    }
  }

  @action
  void validateSelectOpener() {
    if (strikerName == '') {
      strikerNameError = "This field is require";
    }
    if (nonStrikerName == '') {
      nonStrikerNameError = "This field is required";
    }
    if (openingBowlerName == '') {
      openingBowlerNameError = "This field is required";
    }
  }

  @action
  void getAllData() {
    teams = teamBox.values.toList();
  }

  // index for bottom navigationbar
  @action
  void currentIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
    }
  }

  // toss won radio button
  @action
  void tossWon(value) {
    if (value != tossWonBy) {
      tossWonBy = value;
    }
  }

  // opted radio button
  @action
  void optedBy(value) {
    if (value != opted) {
      opted = value;
    }
  }

  // no ball reball switch
  @action
  void noBallReBallSwitch(bool value) {
    if (noBallReBall != value) {
      noBallReBall = value;
    }
  }

  // wide ball reball switch
  @action
  void wideBallReBallSwitch(value) {
    if (wideReBall != value) {
      wideReBall = value;
    }
  }

  // host team name change
  @action
  void hostTeamNameChange(String name) {
    hostTeamName = name;
    hostTeamNameError = null;
  }

  // host team name change
  @action
  void visitorTeamNameChange(String name) {
    visitorTeamName = name;
    visitorTeamNameError = null;
  }

  @action
  Future<TeamModel> getTeam(String teamName) async {
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

  // create new match
  @action
  Future<String> createNewMatch() async {
    //host team
    TeamModel hostTeam = await getTeam(hostTeamName);

    // visitor team
    TeamModel visitorTeam = await getTeam(visitorTeamName);

    // striker
    PlayerModel striker = PlayerModel(name: strikerName);

    // non stiker
    PlayerModel nonStriker = PlayerModel(name: nonStrikerName);

    //bowler
    PlayerModel bowler = PlayerModel(name: openingBowlerName);

    // save stiker player
    final strikerId = await playerBox.add(striker);
    striker.id = strikerId.toString();
    striker.save();

    // save non stiker player
    final nonStrikerId = await playerBox.add(nonStriker);
    nonStriker.id = nonStrikerId.toString();
    nonStriker.save();

    // save bowler player
    final bowlerId = await playerBox.add(bowler);
    bowler.id = bowlerId.toString();
    bowler.save();

    // match data
    MatchModel match = MatchModel(
        over: over,
        isWideBall: isWideBall,
        isWideReball: wideReBall,
        wideRun: int.parse(wideBallRun),
        isNoball: isNoBall,
        isNoballReball: noBallReBall,
        noballRun: int.parse(noBallRun),
        hostTeamId: hostTeam.id,
        visitorTeamId: visitorTeam.id,
        tossId: tossWonBy.name == 'host' ? hostTeam.id : visitorTeam.id,
        tossName: tossWonBy.name == 'host' ? hostTeamName : visitorTeamName,
        tossElect: opted.name,
        firstBatTeamName: batTeamName,
        firstBatTeamScore: "0/0",
        firstBatTeamOver: "0.0",
        secondBatTeamName: bowlTeamName,
        secondBatTeamScore: "0/0",
        secondBatTeamOver: "0.0",
        playerPerMatch: playerPerMatch);

    final matchId = await matchBox.add(match);
    match.id = matchId.toString();
    match.save();

    InningModel inningOne = InningModel(
        matchId: matchId.toString(),
        batTeamName: batTeamName,
        bowlTeamName: bowlTeamName,
        totalRun: 0,
        totalBall: 0,
        totalWicket: 0,
        battingLineup: [
          BattingLineUpModel(
              playerId: strikerId.toString(),
              name: strikerName,
              run: 0,
              ball: 0,
              four: 0,
              six: 0,
              isNotOut: true),
          BattingLineUpModel(
              playerId: nonStrikerId.toString(),
              name: nonStrikerName,
              run: 0,
              ball: 0,
              four: 0,
              six: 0,
              isNotOut: true),
        ],
        bowlingLineup: [
          BowlingLineUpModel(
              playerId: bowlerId.toString(),
              name: openingBowlerName,
              run: 0,
              ball: 0,
              maidan: 0,
              wicket: 0)
        ],
        extraRun: ExtraRunModel(
            wide: 0, noBall: 0, legBy: 0, by: 0, penlaty: 0, total: 0),
        currentBowler: BowlingLineUpModel(
            playerId: bowlerId.toString(),
            name: openingBowlerName,
            run: 0,
            ball: 0,
            maidan: 0,
            wicket: 0),
        currentStriker: BattingLineUpModel(
            playerId: strikerId.toString(),
            name: strikerName,
            run: 0,
            ball: 0,
            four: 0,
            six: 0,
            isNotOut: true),
        currentNonStriker: BattingLineUpModel(
            playerId: nonStrikerId.toString(),
            name: nonStrikerName,
            run: 0,
            ball: 0,
            four: 0,
            six: 0,
            isNotOut: true),
        overs: [],
        currentOver: [],
        partnerShips: [
          PartnerShipModel(
              id: strikerId.toString(),
              run: 0,
              ball: 0,
              currentStiker: BattingLineUpModel(
                  playerId: strikerId.toString(),
                  name: strikerName,
                  run: 0,
                  ball: 0,
                  four: 0,
                  six: 0,
                  isNotOut: true),
              currentNotStiker: BattingLineUpModel(
                  playerId: nonStrikerId.toString(),
                  name: nonStrikerName,
                  run: 0,
                  ball: 0,
                  four: 0,
                  six: 0,
                  isNotOut: true))
        ],
        currentPartnerShip: PartnerShipModel(
            id: strikerId.toString(),
            run: 0,
            ball: 0,
            currentStiker: BattingLineUpModel(
                playerId: strikerId.toString(),
                name: strikerName,
                run: 0,
                ball: 0,
                four: 0,
                six: 0,
                isNotOut: true),
            currentNotStiker: BattingLineUpModel(
                playerId: nonStrikerId.toString(),
                name: nonStrikerName,
                run: 0,
                ball: 0,
                four: 0,
                six: 0,
                isNotOut: true)),
        isFirstInning: true,
        fallOfWicket: []);

    InningModel inningtwo = InningModel(
        matchId: matchId.toString(),
        batTeamName: bowlTeamName,
        bowlTeamName: batTeamName,
        totalRun: 0,
        totalBall: 0,
        totalWicket: 0,
        battingLineup: [],
        bowlingLineup: [],
        extraRun: ExtraRunModel(
            wide: 0, noBall: 0, legBy: 0, by: 0, penlaty: 0, total: 0),
        currentBowler: null,
        currentStriker: null,
        currentNonStriker: null,
        overs: [],
        currentOver: [],
        partnerShips: [],
        currentPartnerShip: null,
        isFirstInning: false,
        fallOfWicket: []);

    final inningOneId = await inningBox.add(inningOne);
    inningOne.id = inningOneId.toString();
    inningOne.save();

    final inningTwoId = await inningBox.add(inningtwo);
    inningtwo.id = inningTwoId.toString();
    inningtwo.save();

    match.inningOneId = inningOneId.toString();
    match.inningTwoId = inningTwoId.toString();
    match.save();

    return matchId.toString();
  }

  @action
  List<MatchModel> getMatchHistory() {
    matchList = matchBox.values.toList().reversed.toList();
    return matchList;
  }

  @action
  void removeMatch(int key) {
    matchBox.delete(key);
    getMatchHistory();
  }
}
