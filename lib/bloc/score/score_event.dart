part of 'score_bloc.dart';

sealed class ScoreEvent {
  const ScoreEvent();
}

// --- Data Loading ---

class LoadMatchData extends ScoreEvent {
  final String matchId;
  const LoadMatchData(this.matchId);
}

// --- Toggle Events ---

class ToggleWide extends ScoreEvent {
  const ToggleWide();
}

class ToggleNoBall extends ScoreEvent {
  const ToggleNoBall();
}

class ToggleByes extends ScoreEvent {
  const ToggleByes();
}

class ToggleLegByes extends ScoreEvent {
  const ToggleLegByes();
}

class ToggleWicket extends ScoreEvent {
  const ToggleWicket();
}

// --- Run Counting ---

class CountRun extends ScoreEvent {
  final int run;
  final PlayerModel? newPlayer;
  const CountRun({required this.run, this.newPlayer});
}

class UndoRun extends ScoreEvent {
  final String runType;
  final int run;
  const UndoRun({required this.runType, required this.run});
}

// --- Bowler ---

class SelectNewBowler extends ScoreEvent {
  const SelectNewBowler();
}

class NewBowlerNameChanged extends ScoreEvent {
  final String name;
  const NewBowlerNameChanged(this.name);
}

// --- Batsman ---

class NewBatsmanNameChanged extends ScoreEvent {
  final String name;
  const NewBatsmanNameChanged(this.name);
}

// --- Wicket ---

class FallOfWicket extends ScoreEvent {
  const FallOfWicket();
}

class WicketTypeChanged extends ScoreEvent {
  final WicketType type;
  const WicketTypeChanged(this.type);
}

class WhoGotOutChanged extends ScoreEvent {
  final String playerId;
  const WhoGotOutChanged(this.playerId);
}

class SupporterPlayerChanged extends ScoreEvent {
  final String name;
  const SupporterPlayerChanged(this.name);
}

// --- Swap ---

class SwapBatsman extends ScoreEvent {
  const SwapBatsman();
}

// --- Inning ---

class ChangeInning extends ScoreEvent {
  final String? striker;
  final String? nonStriker;
  final String? bowler;
  const ChangeInning({this.striker, this.nonStriker, this.bowler});
}

class WonMatch extends ScoreEvent {
  const WonMatch();
}

// --- Save ---

class SaveData extends ScoreEvent {
  const SaveData();
}

class SaveBeforeExit extends ScoreEvent {
  const SaveBeforeExit();
}

// --- Scoreboard Toggle ---

class ToggleScoreBoardOne extends ScoreEvent {
  const ToggleScoreBoardOne();
}

class ToggleScoreBoardTwo extends ScoreEvent {
  const ToggleScoreBoardTwo();
}

// --- Navigation ---

class ClearNavigation extends ScoreEvent {
  const ClearNavigation();
}
