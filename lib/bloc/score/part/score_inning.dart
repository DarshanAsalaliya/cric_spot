part of '../score_bloc.dart';

extension ScoreInningExtension on ScoreBloc {
  Future<void> _onChangeInning(ChangeInning event, Emitter<ScoreState> emit) async {
    saveData();

    // striker
    PlayerModel strikerPlayer = PlayerModel(name: event.striker);

    // non striker
    PlayerModel nonStrikerPlayer = PlayerModel(name: event.nonStriker);

    // bowler
    PlayerModel bowlerPlayer = PlayerModel(name: event.bowler);

    // save striker player
    final strikerId = await playerBox.add(strikerPlayer);
    strikerPlayer.id = strikerId.toString();
    strikerPlayer.save();

    // save non striker player
    final nonStrikerId = await playerBox.add(nonStrikerPlayer);
    nonStrikerPlayer.id = nonStrikerId.toString();
    nonStrikerPlayer.save();

    // save bowler player
    final bowlerId = await playerBox.add(bowlerPlayer);
    bowlerPlayer.id = bowlerId.toString();
    bowlerPlayer.save();

    // add batting line up to second inning
    inningTwo!.battingLineup = [
      BattingLineUpModel(playerId: strikerId.toString(), name: event.striker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
      BattingLineUpModel(playerId: nonStrikerId.toString(), name: event.nonStriker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
    ];

    // add bowling line up to second inning
    inningTwo!.bowlingLineup = [
      BowlingLineUpModel(playerId: bowlerId.toString(), name: event.bowler, run: 0, ball: 0, maidan: 0, wicket: 0),
    ];

    inningTwo!.currentStriker =
        BattingLineUpModel(playerId: strikerId.toString(), name: event.striker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);

    inningTwo!.currentNonStriker =
        BattingLineUpModel(playerId: nonStrikerId.toString(), name: event.nonStriker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);

    inningTwo!.currentBowler =
        BowlingLineUpModel(playerId: bowlerId.toString(), name: event.bowler, run: 0, ball: 0, maidan: 0, wicket: 0);

    inningTwo!.partnerShips = [
      PartnerShipModel(
          id: strikerId.toString(),
          run: 0,
          ball: 0,
          currentStiker: BattingLineUpModel(
              playerId: strikerId.toString(), name: event.striker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
          currentNotStiker: BattingLineUpModel(
              playerId: nonStrikerId.toString(), name: event.nonStriker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true))
    ];

    inningTwo!.currentPartnerShip = PartnerShipModel(
        id: strikerId.toString(),
        run: 0,
        ball: 0,
        currentStiker: BattingLineUpModel(
            playerId: strikerId.toString(), name: event.striker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true),
        currentNotStiker: BattingLineUpModel(
            playerId: nonStrikerId.toString(), name: event.nonStriker, run: 0, ball: 0, four: 0, six: 0, isNotOut: true));

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

    emit(_emitState());
  }

  void _onWonMatch(WonMatch event, Emitter<ScoreState> emit) {
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

    emit(_emitState());
  }
}
