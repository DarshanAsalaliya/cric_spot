part of 'match_setup_bloc.dart';

sealed class MatchSetupEvent {
  const MatchSetupEvent();
}

// --- Validation Events ---

class MatchSetupValidate extends MatchSetupEvent {
  const MatchSetupValidate();
}

class MatchSetupValidateOpener extends MatchSetupEvent {
  const MatchSetupValidateOpener();
}

// --- Team Name Events ---

class MatchSetupHostTeamNameChanged extends MatchSetupEvent {
  final String name;
  const MatchSetupHostTeamNameChanged(this.name);
}

class MatchSetupVisitorTeamNameChanged extends MatchSetupEvent {
  final String name;
  const MatchSetupVisitorTeamNameChanged(this.name);
}

// --- Player Name Events ---

class MatchSetupStrikerNameChanged extends MatchSetupEvent {
  final String name;
  const MatchSetupStrikerNameChanged(this.name);
}

class MatchSetupNonStrikerNameChanged extends MatchSetupEvent {
  final String name;
  const MatchSetupNonStrikerNameChanged(this.name);
}

class MatchSetupOpeningBowlerNameChanged extends MatchSetupEvent {
  final String name;
  const MatchSetupOpeningBowlerNameChanged(this.name);
}

// --- Over Event ---

class MatchSetupOverChanged extends MatchSetupEvent {
  final String over;
  const MatchSetupOverChanged(this.over);
}

// --- Toss & Opted Events ---

class MatchSetupTossWonChanged extends MatchSetupEvent {
  final TeamType tossWonBy;
  const MatchSetupTossWonChanged(this.tossWonBy);
}

class MatchSetupOptedChanged extends MatchSetupEvent {
  final OptedType opted;
  const MatchSetupOptedChanged(this.opted);
}

// --- Settings Events ---

class MatchSetupNoBallToggled extends MatchSetupEvent {
  final bool isNoBall;
  const MatchSetupNoBallToggled(this.isNoBall);
}

class MatchSetupWideBallToggled extends MatchSetupEvent {
  final bool isWideBall;
  const MatchSetupWideBallToggled(this.isWideBall);
}

class MatchSetupNoBallReBallToggled extends MatchSetupEvent {
  final bool noBallReBall;
  const MatchSetupNoBallReBallToggled(this.noBallReBall);
}

class MatchSetupWideBallReBallToggled extends MatchSetupEvent {
  final bool wideReBall;
  const MatchSetupWideBallReBallToggled(this.wideReBall);
}

class MatchSetupNoBallRunChanged extends MatchSetupEvent {
  final String noBallRun;
  const MatchSetupNoBallRunChanged(this.noBallRun);
}

class MatchSetupWideBallRunChanged extends MatchSetupEvent {
  final String wideBallRun;
  const MatchSetupWideBallRunChanged(this.wideBallRun);
}

class MatchSetupPlayerPerMatchChanged extends MatchSetupEvent {
  final String playerPerMatch;
  const MatchSetupPlayerPerMatchChanged(this.playerPerMatch);
}

// --- Data Events ---

class MatchSetupLoadTeams extends MatchSetupEvent {
  const MatchSetupLoadTeams();
}

class MatchSetupCreateMatch extends MatchSetupEvent {
  const MatchSetupCreateMatch();
}

class MatchSetupLoadHistory extends MatchSetupEvent {
  const MatchSetupLoadHistory();
}

class MatchSetupRemoveMatch extends MatchSetupEvent {
  final int key;
  const MatchSetupRemoveMatch(this.key);
}

// --- Match New Flag ---

class MatchSetupSetIsMatchNew extends MatchSetupEvent {
  final bool isMatchNew;
  const MatchSetupSetIsMatchNew(this.isMatchNew);
}

// --- Tournament Context ---

class MatchSetupSetTournamentId extends MatchSetupEvent {
  final String? tournamentId;
  const MatchSetupSetTournamentId(this.tournamentId);
}
