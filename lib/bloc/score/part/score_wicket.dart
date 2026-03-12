part of '../score_bloc.dart';

extension ScoreWicketExtension on ScoreBloc {
  /// Creates a new player in Hive for the incoming batsman after a wicket.
  /// The UI should call this, then use the returned PlayerModel
  /// when dispatching the CountRun event with newPlayer.
  Future<PlayerModel> createNewBatsman() async {
    PlayerModel newBatsmanData = PlayerModel(name: newBatsman);
    final batsmanId = await playerBox.add(newBatsmanData);
    newBatsmanData.id = batsmanId.toString();
    newBatsmanData.save();
    return newBatsmanData;
  }

  void _onFallOfWicket(FallOfWicket event, Emitter<ScoreState> emit) async {
    // Create the new batsman player in Hive
    PlayerModel newBatsmanData = PlayerModel(name: newBatsman);
    final batsmanId = await playerBox.add(newBatsmanData);
    newBatsmanData.id = batsmanId.toString();
    newBatsmanData.save();

    // Store pending new player so the next CountRun event can pick it up
    _pendingNewPlayer = newBatsmanData;
    emit(_emitState());
  }
}
