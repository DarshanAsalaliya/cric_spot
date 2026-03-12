part of '../score_bloc.dart';

extension ScoreUndoExtension on ScoreBloc {
  void _onUndoRun(UndoRun event, Emitter<ScoreState> emit) {
    final String runType = event.runType;
    final int run = event.run;

    print(runType);
    print(run);

    switch (runType) {
      case "noramlRun":

        /// decrease over length
        overLength = overLength - 1;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;

        /// subtract run and ball from bowler
        bowler!.ball = bowler!.ball! - 1;
        bowler!.run = bowler!.run! - run;

        /// subtract run and ball from batsman
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

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "wideBall":
        int reBallNum = matchData!.isWideReball! ? 0 : 1;
        int wideBallRun = matchData!.wideRun!;

        overLength = overLength - reBallNum;

        /// subtract extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.wide = extraRun!.wide! - run;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// subtract run and ball from bowler
        bowler!.run = bowler!.run! - run;
        bowler!.ball = bowler!.ball! - reBallNum;

        /// subtract run and ball from batsman
        if (((run - wideBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - wideBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - reBallNum;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - reBallNum;
        } else {
          striker!.ball = striker!.ball! - reBallNum;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
        }

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "noBall":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// subtract extra run
        extraRun!.total = extraRun!.total! - noBallRun;
        extraRun!.noBall = extraRun!.noBall! - noBallRun;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// subtract run and ball from bowler
        bowler!.ball = bowler!.ball! - reBallNum;
        bowler!.run = bowler!.run! - run;

        /// subtract run and ball from batsman
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

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "byes":

        /// decrease over length
        overLength = overLength - 1;

        /// subtract extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.by = extraRun!.by! - run;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;

        /// subtract run and ball from bowler
        bowler!.ball = bowler!.ball! - 1;

        /// subtract run and ball from batsman
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "legByes":

        /// decrease over length
        overLength = overLength - 1;

        /// subtract extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.legBy = extraRun!.legBy! - run;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - 1;

        /// subtract run and ball from bowler
        bowler!.ball = bowler!.ball! - 1;

        /// subtract run and ball from batsman
        if ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "noBallWithByes":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// subtract extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.noBall = extraRun!.noBall! - run;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// subtract run and ball from bowler
        bowler!.ball = bowler!.ball! - reBallNum;
        bowler!.run = bowler!.run! - run;

        /// subtract run and ball from batsman
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "noBallWithLegByes":
        int reBallNum = matchData!.isNoballReball! ? 0 : 1;
        int noBallRun = matchData!.noballRun!;

        overLength = overLength - reBallNum;

        /// subtract extra run
        extraRun!.total = extraRun!.total! - run;
        extraRun!.noBall = extraRun!.noBall! - run;

        /// remove from current over
        currentOver.removeAt(currentOver.length - 1);

        /// subtract total run and ball
        totalRun = totalRun - run;
        totalBall = totalBall - reBallNum;

        /// subtract run and ball from bowler
        bowler!.ball = bowler!.ball! - reBallNum;
        bowler!.run = bowler!.run! - run;

        /// subtract run and ball from batsman
        if (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0)) {
          nonStriker!.ball = nonStriker!.ball! - 1;
          currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
        } else {
          striker!.ball = striker!.ball! - 1;
          currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
        }

        /// subtract total run and ball from partnership
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
          final change = striker;
          striker = nonStriker;
          nonStriker = change;

          final partnershipChange = currentPartnerShip!.currentStiker;
          currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
          currentPartnerShip!.currentNotStiker = partnershipChange;
        }
        break;

      case "wideBallWithWicket":
        _undoWicketWide(run);
        break;

      case "noBallWithWicket":
        _undoWicketNoBall(run);
        break;

      case "byesWithWicket":
        _undoWicketByes(run);
        break;

      case "legByesWithWicket":
        _undoWicketLegByes(run);
        break;

      case "noBallWithByesWithWicket":
        _undoWicketNoBallByes(run);
        break;

      case "noBallWithLegByesWithWicket":
        _undoWicketNoBallLegByes(run);
        break;

      case "normalWicket":
        _undoWicketNormal(run);
        break;

      default:
        break;
    }

    emit(_emitState());
  }

  // --- Wicket undo helpers ---

  void _undoWicketWide(int run) {
    int reBallNum = matchData!.isWideReball! ? 0 : 1;
    int wideBallRun = matchData!.wideRun!;

    overLength = overLength - reBallNum;

    extraRun!.total = extraRun!.total! - wideBallRun;
    extraRun!.wide = extraRun!.wide! - wideBallRun;

    currentOver.removeAt(currentOver.length - 1);

    totalRun = totalRun - run;
    totalBall = totalBall - reBallNum;
    totalWicket = totalWicket - 1;

    final lastOutPlayer = currentInning!.fallOfWicket!.last;

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
        striker!.ball = striker!.ball! - reBallNum;
        striker!.outBy = null;
        striker!.outType = null;
        striker!.isNotOut = true;
        striker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
        nonStriker!.isNotOut = true;
        currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - reBallNum;
      } else {
        currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
        playerBox.delete(int.parse(striker!.playerId!));
        striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
        striker!.ball = striker!.ball! - reBallNum;
        striker!.outBy = null;
        striker!.outType = null;
        striker!.helpedPlayer = null;
        striker!.isNotOut = true;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - reBallNum;
      }
    }
    lastSave();

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

    if (overLength == 6) {
      lastSave();
      lastSavePartnership();
      saveData();
    }

    if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
        (((run - wideBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - wideBallRun) % 2 == 0))) {
      final change = striker;
      striker = nonStriker;
      nonStriker = change;

      final partnershipChange = currentPartnerShip!.currentStiker;
      currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
      currentPartnerShip!.currentNotStiker = partnershipChange;
    }
    currentInning!.fallOfWicket!.removeLast();
  }

  void _undoWicketNoBall(int run) {
    int reBallNum = matchData!.isNoballReball! ? 0 : 1;
    int noBallRun = matchData!.noballRun!;

    overLength = overLength - reBallNum;

    extraRun!.total = extraRun!.total! - noBallRun;
    extraRun!.noBall = extraRun!.noBall! - noBallRun;

    currentOver.removeAt(currentOver.length - 1);

    totalRun = totalRun - run;
    totalBall = totalBall - reBallNum;
    totalWicket = totalWicket - 1;

    final lastOutPlayer = currentInning!.fallOfWicket!.last;

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
        striker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        striker!.helpedPlayer = null;
        striker!.isNotOut = true;
        currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - (run - noBallRun);
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
      }
    }
    lastSave();

    currentPartnerShip!.run = currentPartnerShip!.run! - run;
    currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
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

    if (overLength == 6) {
      lastSave();
      lastSavePartnership();
      saveData();
    }

    if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
        (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0))) {
      final change = striker;
      striker = nonStriker;
      nonStriker = change;

      final partnershipChange = currentPartnerShip!.currentStiker;
      currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
      currentPartnerShip!.currentNotStiker = partnershipChange;
    }
    currentInning!.fallOfWicket!.removeLast();
  }

  void _undoWicketByesOrLegByes(int run, {required bool isLegByes}) {
    overLength = overLength - 1;

    extraRun!.total = extraRun!.total! - run;
    if (isLegByes) {
      extraRun!.legBy = extraRun!.legBy! - run;
    } else {
      extraRun!.by = extraRun!.by! - run;
    }

    currentOver.removeAt(currentOver.length - 1);

    totalRun = totalRun - run;
    totalBall = totalBall - 1;
    totalWicket = totalWicket - 1;

    final lastOutPlayer = currentInning!.fallOfWicket!.last;

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
        striker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
        nonStriker!.isNotOut = true;
        currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
      } else {
        currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
        playerBox.delete(int.parse(striker!.playerId!));
        striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
        striker!.ball = striker!.ball! - 1;
        striker!.outBy = null;
        striker!.outType = null;
        striker!.helpedPlayer = null;
        striker!.isNotOut = true;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
      }
    }
    lastSave();

    currentPartnerShip!.run = currentPartnerShip!.run! - run;
    currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
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

    if (overLength == 6) {
      lastSave();
      lastSavePartnership();
      saveData();
    }

    if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
        ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0))) {
      final change = striker;
      striker = nonStriker;
      nonStriker = change;

      final partnershipChange = currentPartnerShip!.currentStiker;
      currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
      currentPartnerShip!.currentNotStiker = partnershipChange;
    }
    currentInning!.fallOfWicket!.removeLast();
  }

  void _undoWicketByes(int run) {
    _undoWicketByesOrLegByes(run, isLegByes: false);
  }

  void _undoWicketLegByes(int run) {
    _undoWicketByesOrLegByes(run, isLegByes: true);
  }

  void _undoWicketNoBallByesOrLegByes(int run, {required bool isLegByes}) {
    int reBallNum = matchData!.isNoballReball! ? 0 : 1;
    int noBallRun = matchData!.noballRun!;

    overLength = overLength - reBallNum;

    extraRun!.total = extraRun!.total! - run;
    extraRun!.noBall = extraRun!.noBall! - run;

    currentOver.removeAt(currentOver.length - 1);

    totalRun = totalRun - run;
    totalBall = totalBall - reBallNum;
    totalWicket = totalWicket - 1;

    final lastOutPlayer = currentInning!.fallOfWicket!.last;

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
        striker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
        nonStriker!.isNotOut = true;
        currentPartnerShip!.currentNotStiker!.ball = currentPartnerShip!.currentNotStiker!.ball! - 1;
      } else {
        currentInning!.battingLineup!.removeWhere((element) => element.playerId == striker!.playerId);
        playerBox.delete(int.parse(striker!.playerId!));
        striker = currentInning!.battingLineup!.firstWhere((element) => element.playerId == lastOutPlayer['batsmanId']);
        striker!.ball = striker!.ball! - 1;
        striker!.outBy = null;
        striker!.outType = null;
        striker!.helpedPlayer = null;
        striker!.isNotOut = true;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
      }
    }

    lastSave();

    currentPartnerShip!.run = currentPartnerShip!.run! - run;
    currentPartnerShip!.ball = currentPartnerShip!.ball! - 1;
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

    if (overLength == 6) {
      lastSave();
      lastSavePartnership();
      saveData();
    }

    if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
        (((run - noBallRun) % 2 != 0 && overLength != 6) || (overLength == 6 && (run - noBallRun) % 2 == 0))) {
      final change = striker;
      striker = nonStriker;
      nonStriker = change;

      final partnershipChange = currentPartnerShip!.currentStiker;
      currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
      currentPartnerShip!.currentNotStiker = partnershipChange;
    }
    currentInning!.fallOfWicket!.removeLast();
  }

  void _undoWicketNoBallByes(int run) {
    _undoWicketNoBallByesOrLegByes(run, isLegByes: false);
  }

  void _undoWicketNoBallLegByes(int run) {
    _undoWicketNoBallByesOrLegByes(run, isLegByes: true);
  }

  void _undoWicketNormal(int run) {
    overLength = overLength - 1;

    currentOver.removeAt(currentOver.length - 1);

    totalRun = totalRun - run;
    totalBall = totalBall - 1;
    totalWicket = totalWicket - 1;

    final lastOutPlayer = currentInning!.fallOfWicket!.last;

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
        striker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        nonStriker!.helpedPlayer = null;
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
        striker!.helpedPlayer = null;
        striker!.isNotOut = true;
        currentPartnerShip!.currentStiker!.run = currentPartnerShip!.currentStiker!.run! - run;
        currentPartnerShip!.currentStiker!.ball = currentPartnerShip!.currentStiker!.ball! - 1;
      }
    }
    lastSave();

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

    if (overLength == 6) {
      lastSave();
      lastSavePartnership();
      saveData();
    }

    if ((lastOutPlayer['wicketType'] != 'Runout Striker' && lastOutPlayer['wicketType'] != 'Runout Non-Striker') &&
        ((run % 2 != 0 && overLength != 6) || (overLength == 6 && run % 2 == 0))) {
      final change = striker;
      striker = nonStriker;
      nonStriker = change;

      final partnershipChange = currentPartnerShip!.currentStiker;
      currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
      currentPartnerShip!.currentNotStiker = partnershipChange;
    }
    currentInning!.fallOfWicket!.removeLast();
  }
}
