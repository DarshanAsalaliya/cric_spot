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
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

part 'score_store.g.dart';

class ScoreStore = _ScoreStore with _$ScoreStore;

abstract class _ScoreStore with Store {
  Box<PlayerModel> playerBox;
  Box<TeamModel> teamBox;
  Box<MatchModel> matchBox;
  Box<InningModel> inningBox;

  _ScoreStore(this.playerBox, this.teamBox, this.matchBox, this.inningBox);

  @observable
  MatchModel? matchData;

  @observable
  bool wide = false;

  @observable
  bool noBall = false;

  @observable
  bool byes = false;

  @observable
  bool legByes = false;

  @observable
  bool wicket = false;

  @observable
  InningModel? inningOne;

  @observable
  InningModel? inningTwo;

  @observable
  InningModel? currentInning;

  /// inning data wich use for count
  @observable
  int totalRun = 0;

  @observable
  int totalBall = 0;

  @observable
  int totalWicket = 0;

  @observable
  ExtraRunModel? extraRun;

  @observable
  BattingLineUpModel? striker;

  @observable
  BattingLineUpModel? nonStriker;

  @observable
  BowlingLineUpModel? bowler;

  @observable
  PartnerShipModel? currentPartnerShip;

  @observable
  List<String> currentOver = [];

  @observable
  String whoGotOut = '';

  @observable
  String whoHelped = '';

  /// end of run count variable

  @observable
  bool isLoad = false;

  @observable
  int target = 0;

  @observable
  int overLength = 0;

  @observable
  String newBowler = '';

  @observable
  String newBatsman = '';

  @observable
  WicketType wicketType = WicketType.bowled;

  @observable
  RunCountType runCountType = RunCountType.noramlRun;

  @observable
  bool scoreBoardOneIsOpen = true;

  @observable
  bool scoreBoardTwoIsOpen = true;

  @action
  void changeWide() {
    wide = !wide;
    noBall = false;
    legByes = false;
    byes = false;
    selectRunType();
  }

  @action
  void changeNoball() {
    noBall = !noBall;
    wide = false;
    selectRunType();
  }

  @action
  void changeLegbyes() {
    legByes = !legByes;
    wide = false;
    byes = false;
    selectRunType();
  }

  @action
  void changeByes() {
    byes = !byes;
    wide = false;
    legByes = false;
    selectRunType();
  }

  @action
  void changeWicket() {
    wicket = !wicket;
    selectRunType();
  }

  @action
  void getAllData(String matchId) {
    isLoad = true;
    if (matchData == null || matchData!.id != matchId) {
      print("score_store.dart calling getAllData");
      matchData = matchBox.get(int.parse(matchId));
      inningOne = inningBox.get(int.parse(matchData!.inningOneId!));
      inningTwo = inningBox.get(int.parse(matchData!.inningTwoId!));
      if (inningOne!.totalBall! == (int.parse(matchData!.over!) * 6) || inningOne!.totalWicket == (int.parse(matchData!.playerPerMatch!) - 1)) {
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
  }

  @action
  Future<void> selectNewBowler() async {
    // save bowler player

    BowlingLineUpModel newBowlerModel = currentInning!.bowlingLineup!.firstWhere(
      (element) => element.name == newBowler,
      orElse: () => BowlingLineUpModel(run: 0, ball: 0, wicket: 0, maidan: 0),
    );

    if (newBowlerModel.playerId == null) {
      PlayerModel newBowlerData = PlayerModel(name: newBowler);
      final bowlerId = await playerBox.add(newBowlerData);
      newBowlerData.id = bowlerId.toString();
      newBowlerData.save();

      currentInning!.bowlingLineup!.add(BowlingLineUpModel(playerId: bowlerId.toString(), name: newBowler, run: 0, ball: 0, wicket: 0, maidan: 0));
      currentInning!.currentBowler = BowlingLineUpModel(playerId: bowlerId.toString(), name: newBowler, run: 0, ball: 0, wicket: 0, maidan: 0);
    } else {
      currentInning!.currentBowler = newBowlerModel;
    }

    currentInning!.overs!.add(currentOver);
    currentInning!.currentOver = [];
    currentInning = currentInning;
    if (currentInning!.isFirstInning!) {
      inningOne = currentInning;
    } else {
      inningTwo = currentInning;
    }
    bowler = currentInning!.currentBowler;
    currentOver = [];
    overLength = 0;
    newBowler = '';
  }

  @action
  Future<PlayerModel> fallOfWicket() async {
    PlayerModel newBatsmanData = PlayerModel(name: newBatsman);
    final batsmanId = await playerBox.add(newBatsmanData);
    newBatsmanData.id = batsmanId.toString();
    newBatsmanData.save();
    return newBatsmanData;
  }

  @action
  void saveData() {
    if (currentInning!.isFirstInning!) {
      matchData!.firstBatTeamScore = "$totalRun/$totalWicket";
      matchData!.firstBatTeamOver = "${totalBall ~/ 6}.${totalBall % 6}";
    } else {
      matchData!.secondBatTeamScore = "$totalRun/$totalWicket";
      matchData!.secondBatTeamOver = "${totalBall ~/ 6}.${totalBall % 6}";
    }
    matchData!.save();
    currentInning!.save();
  }

  @action
  Future<void> changeInning({String? strikerName, String? nonStrikerName, String? bowlerName}) async {
    saveData();
    // striker
    PlayerModel strikerPlayer = PlayerModel(name: strikerName);

    // non stiker
    PlayerModel nonStrikerPlayer = PlayerModel(name: nonStrikerName);

    //bowler
    PlayerModel bowlerPlayer = PlayerModel(name: bowlerName);

    // save stiker player
    final strikerId = await playerBox.add(strikerPlayer);
    strikerPlayer.id = strikerId.toString();
    strikerPlayer.save();

    // save non stiker player
    final nonStrikerId = await playerBox.add(nonStrikerPlayer);
    nonStrikerPlayer.id = nonStrikerId.toString();
    nonStrikerPlayer.save();

    // save bowler player
    final bowlerId = await playerBox.add(bowlerPlayer);
    bowlerPlayer.id = bowlerId.toString();
    bowlerPlayer.save();

    // add batting line up to second inning
    inningTwo!.battingLineup = [
      BattingLineUpModel(playerId: strikerId.toString(), name: strikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
      BattingLineUpModel(playerId: nonStrikerId.toString(), name: nonStrikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
    ];

    // add bowling line up to second inning
    inningTwo!.bowlingLineup = [BowlingLineUpModel(playerId: bowlerId.toString(), name: bowlerName, run: 0, ball: 0, maidan: 0, wicket: 0)];

    inningTwo!.currentStriker =
        BattingLineUpModel(playerId: strikerId.toString(), name: strikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);

    inningTwo!.currentNonStriker =
        BattingLineUpModel(playerId: nonStrikerId.toString(), name: nonStrikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);

    inningTwo!.currentBowler = BowlingLineUpModel(playerId: bowlerId.toString(), name: bowlerName, run: 0, ball: 0, maidan: 0, wicket: 0);

    inningTwo!.partnerShips = [
      PartnerShipModel(
          id: strikerId.toString(),
          run: 0,
          ball: 0,
          currentStiker: BattingLineUpModel(playerId: strikerId.toString(), name: strikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
          currentNotStiker:
              BattingLineUpModel(playerId: nonStrikerId.toString(), name: nonStrikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true))
    ];

    inningTwo!.currentPartnerShip = PartnerShipModel(
        id: strikerId.toString(),
        run: 0,
        ball: 0,
        currentStiker: BattingLineUpModel(playerId: strikerId.toString(), name: strikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
        currentNotStiker:
            BattingLineUpModel(playerId: nonStrikerId.toString(), name: nonStrikerName, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
    target = totalRun + 1;
    currentInning = inningTwo;
    totalRun = currentInning!.totalRun!;
    totalBall = currentInning!.totalBall!;
    totalWicket = currentInning!.totalWicket!;
    extraRun = currentInning?.extraRun;
    striker = currentInning?.currentStriker!;
    nonStriker = currentInning?.currentNonStriker;
    bowler = currentInning?.currentBowler;
    currentOver = currentInning?.currentOver ?? [];
    overLength = currentInning!.totalBall! % 6 == 0
        ? currentInning!.totalBall! == 0
            ? 0
            : 6
        : currentInning!.totalBall! % 6;

    currentPartnerShip = currentInning!.currentPartnerShip;
    print(currentInning);
    print(target);
    print(totalRun);
  }

  @action
  void wonMatch() {
    lastSave();
    lastSavePartnership();
    saveData();

    final TeamModel hostTeam = teamBox.get(int.parse(matchData!.hostTeamId!))!;
    final TeamModel visitorTeam = teamBox.get(int.parse(matchData!.visitorTeamId!))!;
    hostTeam.match = hostTeam.match! + 1;
    visitorTeam.match = visitorTeam.match! + 1;

    if (currentInning!.totalRun! > inningOne!.totalRun!) {
      matchData!.wonId = currentInning!.id;
      matchData!.wonName = currentInning!.batTeamName;
      matchData!.wonBy = "${int.parse(matchData!.playerPerMatch!) - 1 - totalWicket} Wickets";
      if (currentInning!.batTeamName == hostTeam.name) {
        hostTeam.win = hostTeam.win! + 1;
        visitorTeam.loss = visitorTeam.loss! + 1;
      } else {
        hostTeam.loss = hostTeam.loss! + 1;
        visitorTeam.win = visitorTeam.win! + 1;
      }
    } else if (currentInning!.totalRun! == inningOne!.totalRun!) {
      matchData!.wonId = "tie";
      matchData!.wonName = "tie";
      matchData!.wonBy = "tie";
    } else {
      matchData!.wonId = inningOne!.id;
      matchData!.wonName = inningOne!.batTeamName;
      matchData!.wonBy = "${inningOne!.totalRun! - totalRun} Runs";

      if (inningOne!.batTeamName == hostTeam.name) {
        hostTeam.win = hostTeam.win! + 1;
        visitorTeam.loss = visitorTeam.loss! + 1;
      } else {
        hostTeam.loss = hostTeam.loss! + 1;
        visitorTeam.win = visitorTeam.win! + 1;
      }
    }
    matchData!.save();
  }

  @action
  void selectRunType() {
    if (wicket && wide) {
      runCountType = RunCountType.wideBallWithWicket;
    } else if (noBall && wicket && legByes) {
      runCountType = RunCountType.noBallWithLegByesWithWicket;
    } else if (noBall && wicket && byes) {
      runCountType = RunCountType.noBallWithByesWithWicket;
    } else if (noBall && wicket) {
      runCountType = RunCountType.noBallWithWicket;
    } else if (legByes && wicket) {
      runCountType = RunCountType.legByesWithWicket;
    } else if (byes && wicket) {
      runCountType = RunCountType.byesWithWicket;
    } else if (byes && noBall) {
      runCountType = RunCountType.noBallWithByes;
    } else if (legByes && noBall) {
      runCountType = RunCountType.noBallWithLegByes;
    } else if (wide) {
      runCountType = RunCountType.wideBall;
    } else if (noBall) {
      runCountType = RunCountType.noBall;
    } else if (byes) {
      runCountType = RunCountType.byes;
    } else if (legByes) {
      runCountType = RunCountType.legByes;
    } else if (wicket) {
      runCountType = RunCountType.normalWicket;
    } else {
      runCountType = RunCountType.noramlRun;
    }
  }

  @action
  void countRun({required int run, PlayerModel? newPlayer}) {
    /// switch case for extra run
    print(runCountType);
    print(run);
    switch (runCountType) {
      case RunCountType.noramlRun:

        /// increse over length
        overLength = overLength + 1;

        /// add run to current over
        currentOver.add("${run.toString()}-${RunCountType.noramlRun.name}");

        /// add total run and ball
        totalRun = totalRun + run;
        totalBall = totalBall + 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + 1;
        bowler!.run = bowler!.run! + run;
        bowler = bowler;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;
        striker!.run = striker!.run! + run;
        if (run == 4) {
          striker!.four = striker!.four! + 1;
        }
        if (run == 6) {
          striker!.six = striker!.six! + 1;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player

        currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! + run;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;
        print(currentPartnerShip);

        // save data
        if (overLength == 6) {
          int runOfOver = 0;
          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }

          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case RunCountType.wideBall:
        int reBallNum = matchData!.isWideReball! ? 0 : 1;
        int wideBallRun = matchData!.wideRun!;

        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + wideBallRun;
        extraRun!.wide = extraRun!.wide! + wideBallRun;

        /// add run to current over
        currentOver.add("${run + wideBallRun}-${RunCountType.wideBall.name}");

        /// add total run and ball
        totalRun = totalRun + run + wideBallRun;
        totalBall = totalBall + reBallNum;

        /// add run and ball to bowler
        bowler!.run = bowler!.run! + run + wideBallRun;
        bowler!.ball = bowler!.ball! + reBallNum;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + reBallNum;

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + wideBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + reBallNum;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + reBallNum;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeWide();
        break;
      case RunCountType.noBall:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + noBallRun;
        extraRun!.noBall = extraRun!.noBall! + noBallRun;

        /// add run to current over
        currentOver.add("${run + noBallRun}-${RunCountType.noBall.name}");

        /// add total run and ball
        totalRun = totalRun + run + noBallRun;
        totalBall = totalBall + reBallNum;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + reBallNum;
        bowler!.run = bowler!.run! + run + noBallRun;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;
        striker!.run = striker!.run! + run;
        if (run == 4) {
          striker!.four = striker!.four! + 1;
        }
        if (run == 6) {
          striker!.six = striker!.six! + 1;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! + run;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data

        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeNoball();
        break;
      case RunCountType.byes:

        /// increse over length
        overLength = overLength + 1;

        /// add extra run
        extraRun!.total = extraRun!.total! + run;
        extraRun!.by = extraRun!.by! + run;

        /// add run to current over
        currentOver.add("$run-${RunCountType.byes.name}");

        /// add total run and ball
        totalRun = totalRun + run;
        totalBall = totalBall + 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + 1;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeByes();
        break;
      case RunCountType.legByes:

        /// increse over length
        overLength = overLength + 1;

        /// add extra run
        extraRun!.total = extraRun!.total! + run;
        extraRun!.legBy = extraRun!.legBy! + run;

        /// add run to current over
        currentOver.add("$run-${RunCountType.legByes.name}");

        /// add total run and ball
        totalRun = totalRun + run;
        totalBall = totalBall + 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + 1;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeLegbyes();
        break;
      case RunCountType.noBallWithByes:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + run + noBallRun;
        extraRun!.noBall = extraRun!.noBall! + run + noBallRun;

        /// add run to current over
        currentOver.add("${run + noBallRun}-${RunCountType.noBallWithByes.name}");

        /// add total run and ball
        totalRun = totalRun + run + noBallRun;
        totalBall = totalBall + reBallNum;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + reBallNum;
        bowler!.run = bowler!.run! + run + noBallRun;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeNoball();
        changeByes();
        break;
      case RunCountType.noBallWithLegByes:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + run + noBallRun;
        extraRun!.noBall = extraRun!.noBall! + run + noBallRun;

        /// add run to current over
        currentOver.add("${run + noBallRun}-${RunCountType.noBallWithLegByes.name}");

        /// add total run and ball
        totalRun = totalRun + run + noBallRun;
        totalBall = totalBall + reBallNum;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + reBallNum;
        bowler!.run = bowler!.run! + run + noBallRun;

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeNoball();
        changeLegbyes();
        break;
      case RunCountType.wideBallWithWicket:
        int reBallNum = matchData!.isWideReball! ? 0 : 1;
        int wideBallRun = matchData!.wideRun!;

        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + wideBallRun;
        extraRun!.wide = extraRun!.wide! + wideBallRun;

        /// add run to current over
        currentOver.add("${run + wideBallRun}-${RunCountType.wideBallWithWicket.name}");

        /// add total run and ball
        totalRun = totalRun + run + wideBallRun;
        totalBall = totalBall + reBallNum;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + wideBallRun;
        } else {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + wideBallRun;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + reBallNum;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + wideBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + reBallNum;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + reBallNum;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeWide();
        changeWicket();

        break;
      case RunCountType.noBallWithWicket:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + noBallRun;
        extraRun!.noBall = extraRun!.noBall! + noBallRun;

        /// add run to current over
        currentOver.add("${run + noBallRun}-${RunCountType.noBallWithWicket.name}");

        /// add total run and ball
        totalRun = totalRun + run + noBallRun;
        totalBall = totalBall + reBallNum;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + noBallRun;
        } else {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + noBallRun;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;
        striker!.run = striker!.run! + run;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! + run;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;
        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeNoball();
        changeWicket();
        break;
      case RunCountType.byesWithWicket:

        /// increse over length
        overLength = overLength + 1;

        /// add extra run
        extraRun!.total = extraRun!.total! + run;
        extraRun!.by = extraRun!.by! + run;

        /// add run to current over
        currentOver.add("$run-${RunCountType.byesWithWicket.name}");

        /// add total run and ball
        totalRun = totalRun + run;
        totalBall = totalBall + 1;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + 1;
        } else {
          bowler!.ball = bowler!.ball! + 1;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeByes();
        changeWicket();
        break;
      case RunCountType.legByesWithWicket:

        /// increse over length
        overLength = overLength + 1;

        /// add extra run
        extraRun!.total = extraRun!.total! + run;
        extraRun!.by = extraRun!.by! + run;

        /// add run to current over
        currentOver.add("$run-${RunCountType.legByesWithWicket.name}");

        /// add total run and ball
        totalRun = totalRun + run;
        totalBall = totalBall + 1;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + 1;
        } else {
          bowler!.ball = bowler!.ball! + 1;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeLegbyes();
        changeWicket();
        break;
      case RunCountType.noBallWithByesWithWicket:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        /// increse over length
        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + run + noBallRun;
        extraRun!.noBall = extraRun!.noBall! + noBallRun + run;

        /// add run to current over
        currentOver.add("${run + noBallRun}-${RunCountType.noBallWithByesWithWicket.name}");

        /// add total run and ball
        totalRun = totalRun + run + noBallRun;
        totalBall = totalBall + reBallNum;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + noBallRun;
        } else {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + noBallRun;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;
        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeByes();
        changeNoball();
        changeWicket();
        break;
      case RunCountType.noBallWithLegByesWithWicket:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        /// increse over length
        overLength = overLength + reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! + run + noBallRun;
        extraRun!.noBall = extraRun!.noBall! + noBallRun + run;

        /// add run to current over
        currentOver.add("${run + noBallRun}-${RunCountType.noBallWithLegByesWithWicket.name}");

        /// add total run and ball
        totalRun = totalRun + run + noBallRun;
        totalBall = totalBall + reBallNum;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + noBallRun;
        } else {
          bowler!.ball = bowler!.ball! + reBallNum;
          bowler!.run = bowler!.run! + run + noBallRun;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;
        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeLegbyes();
        changeNoball();
        changeWicket();
        break;
      case RunCountType.normalWicket:

        /// increse over length
        overLength = overLength + 1;

        /// add run to current over
        currentOver.add("$run-${RunCountType.normalWicket.name}");

        /// add total run and ball to current inning
        totalRun = totalRun + run;
        totalBall = totalBall + 1;
        totalWicket = totalWicket + 1;

        /// add run and ball to bowler
        if (wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) {
          bowler!.ball = bowler!.ball! + 1;
          bowler!.run = bowler!.run! + run;
        } else {
          bowler!.ball = bowler!.ball! + 1;
          bowler!.run = bowler!.run! + run;
          bowler!.wicket = bowler!.wicket! + 1;
        }

        /// add run and ball to batsman
        striker!.ball = striker!.ball! + 1;
        striker!.run = striker!.run! + run;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          // if (( wicketType == WicketType.runoutNonStriker && whoGotOut== nonStriker!.playerId ) || (( wicketType == WicketType.runoutStriker && whoGotOut== nonStriker!.playerId ))) {
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "isStriker": "false"
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "isStriker": "true"
          });
        }
        log(currentInning!.fallOfWicket.toString());

        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! + run;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add stiker and not stiker data to current inning
        final PartnerShipModel newPartnership;
        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            nonStriker = striker;

            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        } else {
          whoGotOut = nonStriker!.playerId!;

          if (wicketType == WicketType.runoutNonStriker) {
            striker = nonStriker;
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: striker!.playerId.toString(), name: striker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          } else {
            striker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(striker!);

            newPartnership = PartnerShipModel(
                id: newPlayer.id!.toString(),
                run: 0,
                ball: 0,
                currentStiker:
                    BattingLineUpModel(playerId: newPlayer.id.toString(), name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
                currentNotStiker: BattingLineUpModel(
                    playerId: nonStriker!.playerId.toString(), name: nonStriker!.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));
          }
        }

        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentPartnerShip = newPartnership;
        currentInning!.partnerShips!.add(newPartnership);
        currentInning!.currentPartnerShip = newPartnership;

        // save data
        if (overLength == 6) {
          int runOfOver = 0;

          for (var element in currentOver) {
            final runOfBall = element.split("-")[0];
            runOfOver += int.parse(runOfBall);
          }
          if (runOfOver == 0) {
            bowler!.maidan = bowler!.maidan! + 1;
          }
          lastSave();
          lastSavePartnership();
          saveData();
        }

        // strike rotation
        if ((run % 2 != 0 && overLength != 6 && (wicketType != WicketType.runoutNonStriker && wicketType != WicketType.runoutStriker)) ||
            ((overLength == 6 && run % 2 == 0 && wicketType != WicketType.runoutStriker && wicketType != WicketType.runoutNonStriker) ||
                ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && (overLength == 6)))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        changeWicket();
        break;
    }
  }

  @action
  void undoRun(String runType, int run) {
    print(runType);
    print(run);
    switch (runType) {
      case "noramlRun":

        /// increse over length
        overLength = overLength - 1;

        /// add run to current over
        // currentOver.add("${run.toString()}-${RunCountType.noramlRun.name}");
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! - 1;
        bowler!.run = bowler!.run! - run;
        bowler = bowler;

        /// add run and ball to batsman
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          nonStriker!.run = nonStriker!.run! - run;

          currentPartnerShip!.currentNotStiker!.run = currentPartnerShip!.currentNotStiker!.run! - run;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;

          if (run == 4) {
            nonStriker!.four = nonStriker!.four! - 1;
          }
          if (run == 6) {
            nonStriker!.six = nonStriker!.six! - 1;
          }
        } else {
          striker!.ball = striker!.ball! - 1;
          striker!.run = striker!.run! - run;

          currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - run;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;

          if (run == 4) {
            striker!.four = striker!.four! - 1;
          }
          if (run == 6) {
            striker!.six = striker!.six! - 1;
          }
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "wideBall":
        int reBallNum = matchData!.isWideReball! ? 0 : 1;
        int wideBallRun = matchData!.wideRun!;

        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.wide = extraRun!.wide! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// add run and ball to bowler
        bowler!.run = bowler!.run! - run;
        bowler!.ball = bowler!.ball! - reBallNum;

        /// add run and ball to batsman
        if (((run - wideBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - wideBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - reBallNum;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - reBallNum;
        } else {
          striker!.ball = striker!.ball! - reBallNum;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - reBallNum;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if (((run - wideBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - wideBallRun) % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "noBall":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - noBallRun;
        extraRun!.noBall = extraRun!.noBall! - noBallRun;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! - reBallNum;
        bowler!.run = bowler!.run! - run;

        /// add run and ball to batsman
        /// add run and ball to batsman
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          nonStriker!.run = nonStriker!.run! - (run - noBallRun);

          currentPartnerShip!.currentNotStiker!.run = currentPartnerShip!.currentNotStiker!.run! - run;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;

          if ((run - noBallRun) == 4) {
            nonStriker!.four = nonStriker!.four! - 1;
          }
          if ((run - noBallRun) == 6) {
            nonStriker!.six = nonStriker!.six! - 1;
          }
        } else {
          striker!.ball = striker!.ball! - 1;
          striker!.run = striker!.run! - (run - noBallRun);

          currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - (run - noBallRun);
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;

          if ((run - noBallRun) == 4) {
            striker!.four = striker!.four! - 1;
          }
          if ((run - noBallRun) == 6) {
            striker!.six = striker!.six! - 1;
          }
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data

        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "byes":

        /// increse over length
        overLength = overLength - 1;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.by = extraRun!.by! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! - 1;

        /// add run and ball to batsman
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "legByes":

        /// increse over length
        overLength = overLength - 1;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.legBy = extraRun!.legBy! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! - 1;

        /// add run and ball to batsman
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "noBallWithByes":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.noBall = extraRun!.noBall! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! - reBallNum;
        bowler!.run = bowler!.run! - run;

        /// add run and ball to batsman
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "noBallWithLegByes":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.noBall = extraRun!.noBall! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! - reBallNum;
        bowler!.run = bowler!.run! - run;

        /// add run and ball to batsman
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        /// update current inning
        currentInning!.extraRun = extraRun;
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.currentOver = currentOver;
        currentInning!.currentBowler = bowler;
        currentInning!.currentStriker = striker;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;
      case "wideBallWithWicket":
        int reBallNum = matchData!.isWideReball! ? 0 : 1;
        int wideBallRun = matchData!.wideRun!;

        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - wideBallRun;
        extraRun!.wide = extraRun!.wide! - wideBallRun;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
        } else {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        /// new code
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - reBallNum;
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - reBallNum;
              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - reBallNum;
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }

            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          }
        } else {
          if (((run - wideBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - wideBallRun) % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - reBallNum;

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - reBallNum;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - reBallNum;
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          }
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - reBallNum;
        lastSavePartnership();

        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            (((run - wideBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - wideBallRun) % 2 == 0))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      case "noBallWithWicket":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - noBallRun;
        extraRun!.noBall = extraRun!.noBall! - noBallRun;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
        } else {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }

            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.run = striker!.run! - (run - noBallRun);
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - (run - noBallRun);
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - 1;
              nonStriker!.run = nonStriker!.run! - (run - noBallRun);

              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - 1;
              striker!.run = striker!.run! - (run - noBallRun);

              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }

            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - (run - noBallRun);
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          }
        } else {
          if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - 1;
            nonStriker!.run = nonStriker!.run! - (run - noBallRun);

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;

            currentPartnerShip!.currentNotStiker!.run = currentPartnerShip!.currentNotStiker!.run! - (run - noBallRun);
            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.run = striker!.run! - (run - noBallRun);

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - (run - noBallRun);
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        lastSavePartnership();

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      case "byesWithWicket":

        /// increse over length
        overLength = overLength - 1;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.by = extraRun!.by! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.ball = bowler!.ball! - 1;
        } else {
          bowler!.ball = bowler!.ball! - 1;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - 1;
              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - 1;
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }

            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        } else {
          if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - 1;

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;

            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
        lastSavePartnership();

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      case "legByesWithWicket":

        /// increse over length
        overLength = overLength - 1;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.legBy = extraRun!.legBy! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.ball = bowler!.ball! - 1;
        } else {
          bowler!.ball = bowler!.ball! - 1;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - 1;
              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - 1;
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }

            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        } else {
          if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - 1;

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;

            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
        lastSavePartnership();

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      case "noBallWithByesWithWicket":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        /// increse over length
        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.noBall = extraRun!.noBall! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
        } else {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - 1;
              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - 1;
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          }
        } else {
          if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - 1;

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;

            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        }

        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;

        lastSavePartnership();

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      case "noBallWithLegByesWithWicket":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        /// increse over length
        overLength = overLength - reBallNum;

        /// add extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.noBall = extraRun!.noBall! - run;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
        } else {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - reBallNum;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - 1;
              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - 1;
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }

            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
          }
        } else {
          if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - 1;

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;

            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        }

        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
        lastSavePartnership();

        /// update current inning
        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.extraRun = extraRun;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0))) {
          /// change striker and non striker
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      case "normalWicket":

        /// increse over length
        overLength = overLength - 1;

        /// add run to current over
        currentOver.removeAt(currentOver.length - 1);

        /// add total run and ball to current inning
        totalRun = totalRun - run;
        totalBall = totalBall - 1;
        totalWicket = totalWicket - 1;

        final lastOutPlayer = currentInning!.fallOfWicket!.last;

        /// add run and ball to bowler
        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - 1;
        } else {
          bowler!.run = bowler!.run! - run;
          bowler!.ball = bowler!.ball! - 1;
          bowler!.wicket = bowler!.wicket! - 1;
        }

        currentInning!.partnerShips!.removeWhere((element) => element.id == currentPartnerShip!.id);
        currentPartnerShip = currentInning!.partnerShips!.last;

        if (lastOutPlayer['wicketType'] == 'Runout Striker' || lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
          if (lastOutPlayer['isStriker'] == "true") {
            log(striker.toString());
            if (lastOutPlayer['wicketType'] == 'Runout Non-Striker') {
              nonStriker = striker;
            }
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.run = striker!.run! - run;

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - run;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          } else {
            if (lastOutPlayer['wicketType'] == 'Runout Striker') {
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
              playerBox.delete(int.parse(striker!.playerId!));
              nonStriker!.ball = nonStriker!.ball! - 1;
              nonStriker!.run = nonStriker!.run! - run;
              striker = nonStriker;
            } else {
              striker!.ball = striker!.ball! - 1;
              striker!.run = striker!.run! - run;
              currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
              playerBox.delete(int.parse(nonStriker!.playerId!));
            }
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;
            currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - run;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        } else {
          if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == nonStriker!.playerId);
            playerBox.delete(int.parse(nonStriker!.playerId!));
            nonStriker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            nonStriker!.ball = nonStriker!.ball! - 1;
            nonStriker!.run = nonStriker!.run! - run;

            nonStriker!.outBy = null;
            nonStriker!.outType = null;
            nonStriker!.isNotOut = true;

            currentPartnerShip!.currentNotStiker!.run = currentPartnerShip!.currentNotStiker!.run! - run;
            currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
          } else {
            currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
            playerBox.delete(int.parse(striker!.playerId!));
            striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
            striker!.ball = striker!.ball! - 1;
            striker!.run = striker!.run! - run;

            striker!.outBy = null;
            striker!.outType = null;
            striker!.isNotOut = true;

            currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - run;
            currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
          }
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! - run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
        lastSavePartnership();

        currentInning!.totalRun = totalRun;
        currentInning!.totalBall = totalBall;
        currentInning!.totalWicket = totalWicket;
        currentInning!.currentStriker = striker;
        currentInning!.currentNonStriker = nonStriker;
        currentInning!.currentBowler = bowler;
        currentInning!.currentOver = currentOver;
        currentInning!.currentPartnerShip = currentPartnerShip;

        // save data
        if (overLength == 6) {
          lastSave();
          lastSavePartnership();
          saveData();
        }

        /// strike rotation
        if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
            ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0))) {
          /// change striker and non striker

          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          /// change partner striker and non striker in partner ship
          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        currentInning!.fallOfWicket!.removeLast();

        break;
      default:
        break;
    }
  }

  void lastSavePartnership() {
    final List<PartnerShipModel> updatedPartnerships = currentInning!.partnerShips!.map((e) {
      if (e.id == currentPartnerShip!.id) {
        return currentPartnerShip!;
      }
      return e;
    }).toList();
    currentInning!.partnerShips = updatedPartnerships;
  }

  void lastSave() {
    final List<BattingLineUpModel> updateBattingLineUpList = currentInning!.battingLineup!.map((e) {
      if (e.playerId == striker!.playerId!) {
        return striker!;
      }
      if (e.playerId == nonStriker!.playerId) {
        return nonStriker!;
      }
      return e;
    }).toList();

    final List<BowlingLineUpModel> updateBowlingLineUpList = currentInning!.bowlingLineup!.map((e) {
      if (e.playerId == bowler!.playerId!) {
        return bowler!;
      }
      return e;
    }).toList();

    currentInning!.battingLineup = updateBattingLineUpList;
    currentInning!.bowlingLineup = updateBowlingLineUpList;
  }

  // @action
  // void countOne() {
  //   currentOver.add(1);
  //   // currentOver = currentOver;
  //   totalRun = totalRun + 1;
  //   totalBall = totalBall + 1;
  //   // currentInning!.totalRun = totalRun;
  //   currentInning!.totalRun = currentInning!.totalRun! + 1;
  //   currentInning!.totalBall = currentInning!.totalBall! + 1;

  //   bowler!.ball = bowler!.ball! + 1;
  //   bowler!.run = bowler!.run! + 1;
  //   bowler = bowler;

  //   striker!.ball = striker!.ball! + 1;
  //   striker!.run = striker!.run! + 1;

  //   // ss
  //   final List<BattingLineUpModel> updateBattingLineUpList =
  //       currentInning!.battingLineup!.map((e) {
  //     if (e.playerId == striker!.playerId!) {
  //       return striker!;
  //     }
  //     if (e.playerId == nonStriker!.playerId) {
  //       return nonStriker!;
  //     }
  //     return e;
  //   }).toList();

  //   final List<BowlingLineUpModel> updateBowlingLineUpList =
  //       currentInning!.bowlingLineup!.map((e) {
  //     if (e.playerId == bowler!.playerId!) {
  //       return bowler!;
  //     }
  //     return e;
  //   }).toList();

  //   currentInning!.battingLineup = updateBattingLineUpList;
  //   currentInning!.bowlingLineup = updateBowlingLineUpList;

  //   currentInning!.currentPartnerShip!.run =
  //       currentInning!.currentPartnerShip!.run! + 1;

  //   currentInning!.currentPartnerShip!.ball =
  //       currentInning!.currentPartnerShip!.ball! + 1;

  //   currentInning!.currentPartnerShip!.currentStiker!.run =
  //       currentInning!.currentPartnerShip!.currentStiker!.run! + 1;
  //   currentInning!.currentPartnerShip!.currentStiker!.ball =
  //       currentInning!.currentPartnerShip!.currentStiker!.ball! + 1;
  //   currentInning!.currentPartnerShip!.currentNotStiker!.run =
  //       currentInning!.currentPartnerShip!.currentNotStiker!.run! + 1;
  //   currentInning!.currentPartnerShip!.currentNotStiker!.ball =
  //       currentInning!.currentPartnerShip!.currentNotStiker!.ball! + 1;

  //   // update current inning
  //   currentInning = currentInning;

  //   // change striker
  //   final change = striker;
  //   striker = nonStriker;
  //   nonStriker = change;

  //   final partnershipChange = currentInning!.currentPartnerShip!.currentStiker;
  //   currentInning!.currentPartnerShip!.currentStiker =
  //       currentInning!.currentPartnerShip!.currentNotStiker;
  //   currentInning!.currentPartnerShip!.currentNotStiker = partnershipChange;
  // }
}
