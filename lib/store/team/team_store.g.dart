// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeamStore on _TeamStore, Store {
  late final _$teamModelListAtom =
      Atom(name: '_TeamStore.teamModelList', context: context);

  @override
  List<TeamModel> get teamModelList {
    _$teamModelListAtom.reportRead();
    return super.teamModelList;
  }

  @override
  set teamModelList(List<TeamModel> value) {
    _$teamModelListAtom.reportWrite(value, super.teamModelList, () {
      super.teamModelList = value;
    });
  }

  late final _$addTeamAsyncAction =
      AsyncAction('_TeamStore.addTeam', context: context);

  @override
  Future<void> addTeam(TeamModel team) {
    return _$addTeamAsyncAction.run(() => super.addTeam(team));
  }

  late final _$_TeamStoreActionController =
      ActionController(name: '_TeamStore', context: context);

  @override
  List<TeamModel> teams() {
    final _$actionInfo =
        _$_TeamStoreActionController.startAction(name: '_TeamStore.teams');
    try {
      return super.teams();
    } finally {
      _$_TeamStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTeam(int key) {
    final _$actionInfo =
        _$_TeamStoreActionController.startAction(name: '_TeamStore.removeTeam');
    try {
      return super.removeTeam(key);
    } finally {
      _$_TeamStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateTeam(TeamModel team) {
    final _$actionInfo =
        _$_TeamStoreActionController.startAction(name: '_TeamStore.updateTeam');
    try {
      return super.updateTeam(team);
    } finally {
      _$_TeamStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
teamModelList: ${teamModelList}
    ''';
  }
}
