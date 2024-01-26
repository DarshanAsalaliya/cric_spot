// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  Computed<String>? _$batTeamNameComputed;

  @override
  String get batTeamName =>
      (_$batTeamNameComputed ??= Computed<String>(() => super.batTeamName,
              name: '_HomeStore.batTeamName'))
          .value;
  Computed<String>? _$bowlTeamNameComputed;

  @override
  String get bowlTeamName =>
      (_$bowlTeamNameComputed ??= Computed<String>(() => super.bowlTeamName,
              name: '_HomeStore.bowlTeamName'))
          .value;
  Computed<bool>? _$canStartMatchComputed;

  @override
  bool get canStartMatch =>
      (_$canStartMatchComputed ??= Computed<bool>(() => super.canStartMatch,
              name: '_HomeStore.canStartMatch'))
          .value;
  Computed<bool>? _$canSelectOpeningPlayerComputed;

  @override
  bool get canSelectOpeningPlayer => (_$canSelectOpeningPlayerComputed ??=
          Computed<bool>(() => super.canSelectOpeningPlayer,
              name: '_HomeStore.canSelectOpeningPlayer'))
      .value;

  late final _$matchListAtom =
      Atom(name: '_HomeStore.matchList', context: context);

  @override
  List<MatchModel> get matchList {
    _$matchListAtom.reportRead();
    return super.matchList;
  }

  @override
  set matchList(List<MatchModel> value) {
    _$matchListAtom.reportWrite(value, super.matchList, () {
      super.matchList = value;
    });
  }

  late final _$teamsAtom = Atom(name: '_HomeStore.teams', context: context);

  @override
  List<TeamModel> get teams {
    _$teamsAtom.reportRead();
    return super.teams;
  }

  @override
  set teams(List<TeamModel> value) {
    _$teamsAtom.reportWrite(value, super.teams, () {
      super.teams = value;
    });
  }

  late final _$selectedIndexAtom =
      Atom(name: '_HomeStore.selectedIndex', context: context);

  @override
  int get selectedIndex {
    _$selectedIndexAtom.reportRead();
    return super.selectedIndex;
  }

  @override
  set selectedIndex(int value) {
    _$selectedIndexAtom.reportWrite(value, super.selectedIndex, () {
      super.selectedIndex = value;
    });
  }

  late final _$isNoBallAtom =
      Atom(name: '_HomeStore.isNoBall', context: context);

  @override
  bool get isNoBall {
    _$isNoBallAtom.reportRead();
    return super.isNoBall;
  }

  @override
  set isNoBall(bool value) {
    _$isNoBallAtom.reportWrite(value, super.isNoBall, () {
      super.isNoBall = value;
    });
  }

  late final _$isWideBallAtom =
      Atom(name: '_HomeStore.isWideBall', context: context);

  @override
  bool get isWideBall {
    _$isWideBallAtom.reportRead();
    return super.isWideBall;
  }

  @override
  set isWideBall(bool value) {
    _$isWideBallAtom.reportWrite(value, super.isWideBall, () {
      super.isWideBall = value;
    });
  }

  late final _$noBallReBallAtom =
      Atom(name: '_HomeStore.noBallReBall', context: context);

  @override
  bool get noBallReBall {
    _$noBallReBallAtom.reportRead();
    return super.noBallReBall;
  }

  @override
  set noBallReBall(bool value) {
    _$noBallReBallAtom.reportWrite(value, super.noBallReBall, () {
      super.noBallReBall = value;
    });
  }

  late final _$wideReBallAtom =
      Atom(name: '_HomeStore.wideReBall', context: context);

  @override
  bool get wideReBall {
    _$wideReBallAtom.reportRead();
    return super.wideReBall;
  }

  @override
  set wideReBall(bool value) {
    _$wideReBallAtom.reportWrite(value, super.wideReBall, () {
      super.wideReBall = value;
    });
  }

  late final _$noBallRunAtom =
      Atom(name: '_HomeStore.noBallRun', context: context);

  @override
  String get noBallRun {
    _$noBallRunAtom.reportRead();
    return super.noBallRun;
  }

  @override
  set noBallRun(String value) {
    _$noBallRunAtom.reportWrite(value, super.noBallRun, () {
      super.noBallRun = value;
    });
  }

  late final _$wideBallRunAtom =
      Atom(name: '_HomeStore.wideBallRun', context: context);

  @override
  String get wideBallRun {
    _$wideBallRunAtom.reportRead();
    return super.wideBallRun;
  }

  @override
  set wideBallRun(String value) {
    _$wideBallRunAtom.reportWrite(value, super.wideBallRun, () {
      super.wideBallRun = value;
    });
  }

  late final _$playerPerMatchAtom =
      Atom(name: '_HomeStore.playerPerMatch', context: context);

  @override
  String get playerPerMatch {
    _$playerPerMatchAtom.reportRead();
    return super.playerPerMatch;
  }

  @override
  set playerPerMatch(String value) {
    _$playerPerMatchAtom.reportWrite(value, super.playerPerMatch, () {
      super.playerPerMatch = value;
    });
  }

  late final _$tossWonByAtom =
      Atom(name: '_HomeStore.tossWonBy', context: context);

  @override
  TeamType get tossWonBy {
    _$tossWonByAtom.reportRead();
    return super.tossWonBy;
  }

  @override
  set tossWonBy(TeamType value) {
    _$tossWonByAtom.reportWrite(value, super.tossWonBy, () {
      super.tossWonBy = value;
    });
  }

  late final _$optedAtom = Atom(name: '_HomeStore.opted', context: context);

  @override
  OptedType get opted {
    _$optedAtom.reportRead();
    return super.opted;
  }

  @override
  set opted(OptedType value) {
    _$optedAtom.reportWrite(value, super.opted, () {
      super.opted = value;
    });
  }

  late final _$hostTeamNameAtom =
      Atom(name: '_HomeStore.hostTeamName', context: context);

  @override
  String get hostTeamName {
    _$hostTeamNameAtom.reportRead();
    return super.hostTeamName;
  }

  @override
  set hostTeamName(String value) {
    _$hostTeamNameAtom.reportWrite(value, super.hostTeamName, () {
      super.hostTeamName = value;
    });
  }

  late final _$hostTeamNameErrorAtom =
      Atom(name: '_HomeStore.hostTeamNameError', context: context);

  @override
  String? get hostTeamNameError {
    _$hostTeamNameErrorAtom.reportRead();
    return super.hostTeamNameError;
  }

  @override
  set hostTeamNameError(String? value) {
    _$hostTeamNameErrorAtom.reportWrite(value, super.hostTeamNameError, () {
      super.hostTeamNameError = value;
    });
  }

  late final _$visitorTeamNameAtom =
      Atom(name: '_HomeStore.visitorTeamName', context: context);

  @override
  String get visitorTeamName {
    _$visitorTeamNameAtom.reportRead();
    return super.visitorTeamName;
  }

  @override
  set visitorTeamName(String value) {
    _$visitorTeamNameAtom.reportWrite(value, super.visitorTeamName, () {
      super.visitorTeamName = value;
    });
  }

  late final _$visitorTeamNameErrorAtom =
      Atom(name: '_HomeStore.visitorTeamNameError', context: context);

  @override
  String? get visitorTeamNameError {
    _$visitorTeamNameErrorAtom.reportRead();
    return super.visitorTeamNameError;
  }

  @override
  set visitorTeamNameError(String? value) {
    _$visitorTeamNameErrorAtom.reportWrite(value, super.visitorTeamNameError,
        () {
      super.visitorTeamNameError = value;
    });
  }

  late final _$strikerNameAtom =
      Atom(name: '_HomeStore.strikerName', context: context);

  @override
  String get strikerName {
    _$strikerNameAtom.reportRead();
    return super.strikerName;
  }

  @override
  set strikerName(String value) {
    _$strikerNameAtom.reportWrite(value, super.strikerName, () {
      super.strikerName = value;
    });
  }

  late final _$strikerNameErrorAtom =
      Atom(name: '_HomeStore.strikerNameError', context: context);

  @override
  String? get strikerNameError {
    _$strikerNameErrorAtom.reportRead();
    return super.strikerNameError;
  }

  @override
  set strikerNameError(String? value) {
    _$strikerNameErrorAtom.reportWrite(value, super.strikerNameError, () {
      super.strikerNameError = value;
    });
  }

  late final _$nonStrikerNameAtom =
      Atom(name: '_HomeStore.nonStrikerName', context: context);

  @override
  String get nonStrikerName {
    _$nonStrikerNameAtom.reportRead();
    return super.nonStrikerName;
  }

  @override
  set nonStrikerName(String value) {
    _$nonStrikerNameAtom.reportWrite(value, super.nonStrikerName, () {
      super.nonStrikerName = value;
    });
  }

  late final _$nonStrikerNameErrorAtom =
      Atom(name: '_HomeStore.nonStrikerNameError', context: context);

  @override
  String? get nonStrikerNameError {
    _$nonStrikerNameErrorAtom.reportRead();
    return super.nonStrikerNameError;
  }

  @override
  set nonStrikerNameError(String? value) {
    _$nonStrikerNameErrorAtom.reportWrite(value, super.nonStrikerNameError, () {
      super.nonStrikerNameError = value;
    });
  }

  late final _$openingBowlerNameAtom =
      Atom(name: '_HomeStore.openingBowlerName', context: context);

  @override
  String get openingBowlerName {
    _$openingBowlerNameAtom.reportRead();
    return super.openingBowlerName;
  }

  @override
  set openingBowlerName(String value) {
    _$openingBowlerNameAtom.reportWrite(value, super.openingBowlerName, () {
      super.openingBowlerName = value;
    });
  }

  late final _$openingBowlerNameErrorAtom =
      Atom(name: '_HomeStore.openingBowlerNameError', context: context);

  @override
  String? get openingBowlerNameError {
    _$openingBowlerNameErrorAtom.reportRead();
    return super.openingBowlerNameError;
  }

  @override
  set openingBowlerNameError(String? value) {
    _$openingBowlerNameErrorAtom
        .reportWrite(value, super.openingBowlerNameError, () {
      super.openingBowlerNameError = value;
    });
  }

  late final _$overAtom = Atom(name: '_HomeStore.over', context: context);

  @override
  String get over {
    _$overAtom.reportRead();
    return super.over;
  }

  @override
  set over(String value) {
    _$overAtom.reportWrite(value, super.over, () {
      super.over = value;
    });
  }

  late final _$overErrorAtom =
      Atom(name: '_HomeStore.overError', context: context);

  @override
  String? get overError {
    _$overErrorAtom.reportRead();
    return super.overError;
  }

  @override
  set overError(String? value) {
    _$overErrorAtom.reportWrite(value, super.overError, () {
      super.overError = value;
    });
  }

  late final _$isMatchNewAtom =
      Atom(name: '_HomeStore.isMatchNew', context: context);

  @override
  bool get isMatchNew {
    _$isMatchNewAtom.reportRead();
    return super.isMatchNew;
  }

  @override
  set isMatchNew(bool value) {
    _$isMatchNewAtom.reportWrite(value, super.isMatchNew, () {
      super.isMatchNew = value;
    });
  }

  late final _$getTeamAsyncAction =
      AsyncAction('_HomeStore.getTeam', context: context);

  @override
  Future<TeamModel> getTeam(String teamName) {
    return _$getTeamAsyncAction.run(() => super.getTeam(teamName));
  }

  late final _$createNewMatchAsyncAction =
      AsyncAction('_HomeStore.createNewMatch', context: context);

  @override
  Future<String> createNewMatch() {
    return _$createNewMatchAsyncAction.run(() => super.createNewMatch());
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  void validate() {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.validate');
    try {
      return super.validate();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateSelectOpener() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.validateSelectOpener');
    try {
      return super.validateSelectOpener();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getAllData() {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.getAllData');
    try {
      return super.getAllData();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void currentIndex(int index) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.currentIndex');
    try {
      return super.currentIndex(index);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void tossWon(dynamic value) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.tossWon');
    try {
      return super.tossWon(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void optedBy(dynamic value) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.optedBy');
    try {
      return super.optedBy(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void noBallReBallSwitch(bool value) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.noBallReBallSwitch');
    try {
      return super.noBallReBallSwitch(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void wideBallReBallSwitch(dynamic value) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.wideBallReBallSwitch');
    try {
      return super.wideBallReBallSwitch(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hostTeamNameChange(String name) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.hostTeamNameChange');
    try {
      return super.hostTeamNameChange(name);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void visitorTeamNameChange(String name) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.visitorTeamNameChange');
    try {
      return super.visitorTeamNameChange(name);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<MatchModel> getMatchHistory() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.getMatchHistory');
    try {
      return super.getMatchHistory();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMatch(int key) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.removeMatch');
    try {
      return super.removeMatch(key);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
matchList: ${matchList},
teams: ${teams},
selectedIndex: ${selectedIndex},
isNoBall: ${isNoBall},
isWideBall: ${isWideBall},
noBallReBall: ${noBallReBall},
wideReBall: ${wideReBall},
noBallRun: ${noBallRun},
wideBallRun: ${wideBallRun},
playerPerMatch: ${playerPerMatch},
tossWonBy: ${tossWonBy},
opted: ${opted},
hostTeamName: ${hostTeamName},
hostTeamNameError: ${hostTeamNameError},
visitorTeamName: ${visitorTeamName},
visitorTeamNameError: ${visitorTeamNameError},
strikerName: ${strikerName},
strikerNameError: ${strikerNameError},
nonStrikerName: ${nonStrikerName},
nonStrikerNameError: ${nonStrikerNameError},
openingBowlerName: ${openingBowlerName},
openingBowlerNameError: ${openingBowlerNameError},
over: ${over},
overError: ${overError},
isMatchNew: ${isMatchNew},
batTeamName: ${batTeamName},
bowlTeamName: ${bowlTeamName},
canStartMatch: ${canStartMatch},
canSelectOpeningPlayer: ${canSelectOpeningPlayer}
    ''';
  }
}
