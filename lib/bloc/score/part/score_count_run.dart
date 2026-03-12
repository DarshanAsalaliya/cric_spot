part of '../score_bloc.dart';

extension ScoreCountRunExtension on ScoreBloc {
  void _onCountRun(CountRun event, Emitter<ScoreState> emit) {
    final int run = event.run;
    // Use pending new player from FallOfWicket if not passed directly
    PlayerModel? newPlayer = event.newPlayer;
    if (newPlayer == null && _pendingNewPlayer != null) {
      newPlayer = _pendingNewPlayer;
      _pendingNewPlayer = null;
    }

    print(runCountType);
    print(run);

    switch (runCountType) {
      case RunCountType.noramlRun:

        /// increase over length
        overLength = overLength + 1;

        /// add run to current over
        currentOver.add("${run.toString()}-${RunCountType.noramlRun.name}");

        /// add total run and ball
        totalRun = totalRun + run;
        totalBall = totalBall + 1;

        /// add run and ball to bowler
        bowler!.ball = bowler!.ball! + 1;
        bowler!.run = bowler!.run! + run;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeWide();
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeNoball();
        break;

      case RunCountType.byes:

        /// increase over length
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeByes();
        break;

      case RunCountType.legByes:

        /// increase over length
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeLegbyes();
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeNoball();
        _changeByes();
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeNoball();
        _changeLegbyes();
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
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + wideBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + reBallNum;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + reBallNum;
        lastSavePartnership();

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipWideWicket;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipWideWicket = PartnerShipModel(
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
            newPartnershipWideWicket = PartnerShipModel(
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
            newPartnershipWideWicket = PartnerShipModel(
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
            newPartnershipWideWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipWideWicket;
        currentInning!.partnerShips!.add(newPartnershipWideWicket);
        currentInning!.currentPartnerShip = newPartnershipWideWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeWide();
        _changeWicket();
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
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
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

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipNoBallWicket;
        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipNoBallWicket = PartnerShipModel(
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
            newPartnershipNoBallWicket = PartnerShipModel(
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
            newPartnershipNoBallWicket = PartnerShipModel(
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
            newPartnershipNoBallWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipNoBallWicket;
        currentInning!.partnerShips!.add(newPartnershipNoBallWicket);
        currentInning!.currentPartnerShip = newPartnershipNoBallWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeNoball();
        _changeWicket();
        break;

      case RunCountType.byesWithWicket:

        /// increase over length
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
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipByesWicket;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipByesWicket = PartnerShipModel(
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
            newPartnershipByesWicket = PartnerShipModel(
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
            newPartnershipByesWicket = PartnerShipModel(
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
            newPartnershipByesWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipByesWicket;
        currentInning!.partnerShips!.add(newPartnershipByesWicket);
        currentInning!.currentPartnerShip = newPartnershipByesWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeByes();
        _changeWicket();
        break;

      case RunCountType.legByesWithWicket:

        /// increase over length
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
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipLegByesWicket;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipLegByesWicket = PartnerShipModel(
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
            newPartnershipLegByesWicket = PartnerShipModel(
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
            newPartnershipLegByesWicket = PartnerShipModel(
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
            newPartnershipLegByesWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipLegByesWicket;
        currentInning!.partnerShips!.add(newPartnershipLegByesWicket);
        currentInning!.currentPartnerShip = newPartnershipLegByesWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeLegbyes();
        _changeWicket();
        break;

      case RunCountType.noBallWithByesWithWicket:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        /// increase over length
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
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipNBByesWicket;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipNBByesWicket = PartnerShipModel(
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
            newPartnershipNBByesWicket = PartnerShipModel(
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
            newPartnershipNBByesWicket = PartnerShipModel(
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
            newPartnershipNBByesWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipNBByesWicket;
        currentInning!.partnerShips!.add(newPartnershipNBByesWicket);
        currentInning!.currentPartnerShip = newPartnershipNBByesWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeByes();
        _changeNoball();
        _changeWicket();
        break;

      case RunCountType.noBallWithLegByesWithWicket:
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        /// increase over length
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
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
          });
        }
        lastSave();

        /// add total run and ball to partnership
        currentPartnerShip!.run = currentPartnerShip!.run! + run + noBallRun;
        currentPartnerShip!.ball = currentPartnerShip!.ball! + 1;

        /// add run and ball to partnership player
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! + 1;
        lastSavePartnership();

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipNBLBWicket;

        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipNBLBWicket = PartnerShipModel(
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
            newPartnershipNBLBWicket = PartnerShipModel(
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
            newPartnershipNBLBWicket = PartnerShipModel(
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
            newPartnershipNBLBWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipNBLBWicket;
        currentInning!.partnerShips!.add(newPartnershipNBLBWicket);
        currentInning!.currentPartnerShip = newPartnershipNBLBWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeLegbyes();
        _changeNoball();
        _changeWicket();
        break;

      case RunCountType.normalWicket:

        /// increase over length
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
          nonStriker!.outBy = bowler!.name;
          nonStriker!.outType = wicketType.name;
          nonStriker!.isNotOut = false;
          nonStriker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": nonStriker!.playerId!,
            "batsmanName": nonStriker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
            "isStriker": "false"
          });
        } else {
          striker!.outBy = bowler!.name;
          striker!.outType = wicketType.name;
          striker!.isNotOut = false;
          striker!.helpedPlayer = supporterPlayer == '' ? null : supporterPlayer;

          currentInning!.fallOfWicket!.add({
            "batsmanId": striker!.playerId!,
            "batsmanName": striker!.name!,
            "runWicket": "$totalRun - $totalWicket",
            "over": "${totalBall / 6}.${totalBall % 6}",
            "wicketType": wicketType.name,
            "supportPlayer": supporterPlayer,
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

        /// add striker and non striker data to current inning
        final PartnerShipModel newPartnershipNormalWicket;
        if ((wicketType == WicketType.runoutNonStriker || wicketType == WicketType.runoutStriker) && whoGotOut == nonStriker!.playerId) {
          whoGotOut = striker!.playerId!;
          if (wicketType == WicketType.runoutNonStriker) {
            nonStriker = BattingLineUpModel(playerId: newPlayer!.id, name: newPlayer.name, run: 0, ball: 0, four: 0, six: 0, isNotOut: true);
            currentInning!.battingLineup!.add(nonStriker!);
            newPartnershipNormalWicket = PartnerShipModel(
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
            newPartnershipNormalWicket = PartnerShipModel(
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
            newPartnershipNormalWicket = PartnerShipModel(
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
            newPartnershipNormalWicket = PartnerShipModel(
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
        currentPartnerShip = newPartnershipNormalWicket;
        currentInning!.partnerShips!.add(newPartnershipNormalWicket);
        currentInning!.currentPartnerShip = newPartnershipNormalWicket;

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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        _changeWicket();
        break;
    }

    // Determine post-run navigation action
    final int maxBalls = int.parse(matchData!.over!) * 6;
    final int maxWickets = int.parse(matchData!.playerPerMatch ?? "11") - 1;

    if (totalBall >= maxBalls || totalWicket >= maxWickets || (!currentInning!.isFirstInning! && totalRun >= target)) {
      if (currentInning!.isFirstInning!) {
        navigationAction = ScoreNavigationAction.inningEnd;
      } else {
        navigationAction = ScoreNavigationAction.matchWon;
      }
    } else if (overLength == 6) {
      navigationAction = ScoreNavigationAction.selectBowler;
    } else {
      navigationAction = ScoreNavigationAction.none;
    }

    emit(_emitState());
  }
}
