part of '../score_bloc.dart';

extension ScoreBowlerExtension on ScoreBloc {
  Future<void> _onSelectNewBowler(SelectNewBowler event, Emitter<ScoreState> emit) async {
    // Find existing bowler or create placeholder
    BowlingLineUpModel newBowlerModel = currentInning!.bowlingLineup!.firstWhere(
      (element) => element.name == newBowler,
      orElse: () => BowlingLineUpModel(run: 0, ball: 0, wicket: 0, maidan: 0),
    );

    if (newBowlerModel.playerId == null) {
      PlayerModel newBowlerData = PlayerModel(name: newBowler);
      final bowlerId = await playerBox.add(newBowlerData);
      newBowlerData.id = bowlerId.toString();
      newBowlerData.save();

      currentInning!.bowlingLineup!.add(
        BowlingLineUpModel(playerId: bowlerId.toString(), name: newBowler, run: 0, ball: 0, wicket: 0, maidan: 0),
      );
      currentInning!.currentBowler =
        BowlingLineUpModel(playerId: bowlerId.toString(), name: newBowler, run: 0, ball: 0, wicket: 0, maidan: 0);
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

    emit(_emitState());
  }
}
