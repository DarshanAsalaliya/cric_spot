import 'package:cric_spot/bloc/team/team_state.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class TeamCubit extends Cubit<TeamState> {
  final Box<TeamModel> teamBox;

  TeamCubit(this.teamBox) : super(const TeamState());

  Future<void> addTeam(TeamModel team) async {
    final id = await teamBox.add(team);
    team.id = id.toString();
    team.save();
    loadTeams();
  }

  void loadTeams() {
    emit(state.copyWith(
      teamModelList: teamBox.values.toList(),
      status: TeamStatus.loaded,
    ));
  }

  void removeTeam(int key) {
    teamBox.delete(key);
    loadTeams();
  }

  void updateTeam(TeamModel team) {
    team.save();
    loadTeams();
  }
}
