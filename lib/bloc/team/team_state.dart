import 'package:equatable/equatable.dart';
import 'package:cric_spot/model/team/team_model.dart';

enum TeamStatus { initial, loading, loaded, error }

class TeamState extends Equatable {
  final List<TeamModel> teamModelList;
  final TeamStatus status;

  const TeamState({
    this.teamModelList = const [],
    this.status = TeamStatus.initial,
  });

  TeamState copyWith({
    List<TeamModel>? teamModelList,
    TeamStatus? status,
  }) {
    return TeamState(
      teamModelList: teamModelList ?? this.teamModelList,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [teamModelList, status];
}
