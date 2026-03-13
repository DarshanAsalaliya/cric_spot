part of '../score_bloc.dart';

extension ScoreHelpersExtension on ScoreBloc {
  void lastSave() {
    final List<BattingLineUpModel> updateBattingLineUpList = currentInning!.battingLineup!.map((e) {
      if (e.playerId == striker!.playerId!) return striker!;
      if (e.playerId == nonStriker!.playerId) return nonStriker!;
      return e;
    }).toList();
    final List<BowlingLineUpModel> updateBowlingLineUpList = currentInning!.bowlingLineup!.map((e) {
      if (e.playerId == bowler!.playerId!) return bowler!;
      return e;
    }).toList();
    currentInning!.battingLineup = updateBattingLineUpList;
    currentInning!.bowlingLineup = updateBowlingLineUpList;
  }

  void lastSavePartnership() {
    final List<PartnerShipModel> updatedPartnerships = currentInning!.partnerShips!.map((e) {
      if (e.id == currentPartnerShip!.id) return currentPartnerShip!;
      return e;
    }).toList();
    currentInning!.partnerShips = updatedPartnerships;
  }

  void swapBatsMan() {
    final change = striker;
    striker = nonStriker;
    nonStriker = change;

    final partnershipChange = currentPartnerShip!.currentStiker;
    currentPartnerShip!.currentStiker = currentPartnerShip!.currentNotStiker;
    currentPartnerShip!.currentNotStiker = partnershipChange;
  }

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

    // Sync to Supabase (fire-and-forget, no-op if not authenticated)
    try {
      final syncService = GetIt.instance.get<SupabaseSyncService>();
      syncService.syncMatchState(matchData!, inningOne, inningTwo).catchError((e) {
        // If sync fails (e.g. offline), queue the operation
        try {
          final syncCubit = GetIt.instance.get<SyncCubit>();
          if (!syncCubit.state.isConnected) {
            syncCubit.enqueue({
              'type': 'upsert_match',
              'data': {
                'id': matchData!.remoteId,
                'first_bat_team_score': matchData!.firstBatTeamScore,
                'first_bat_team_over': matchData!.firstBatTeamOver,
                'second_bat_team_score': matchData!.secondBatTeamScore,
                'second_bat_team_over': matchData!.secondBatTeamOver,
                'status': matchData!.wonId != null ? 'completed' : 'live',
                'updated_at': DateTime.now().toIso8601String(),
              },
            });
          }
        } catch (_) {}
      });
    } catch (_) {}
  }
}
