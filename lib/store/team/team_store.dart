import 'package:cric_spot/model/team/team_model.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

part 'team_store.g.dart';

class TeamStore = _TeamStore with _$TeamStore;

abstract class _TeamStore with Store {
  Box<TeamModel> teamBox;
  _TeamStore(this.teamBox);

  @observable
  List<TeamModel> teamModelList = [];

  @action
  Future<void> addTeam(TeamModel team) async {
    final id = await teamBox.add(team);
    team.id = id.toString();
    team.save();
    teams();
  }

  @action
  List<TeamModel> teams() {
    teamModelList = teamBox.values.toList();
    return teamBox.values.toList();
  }

  @action
  void removeTeam(int key) {
    teamBox.delete(key);
    teams();
  }

  @action
  void updateTeam(TeamModel team) {
    team.save();
    teams();
  }
}
