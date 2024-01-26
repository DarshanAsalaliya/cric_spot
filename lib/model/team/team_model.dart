import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'team_model.freezed.dart';
part 'team_model.g.dart';

@unfreezed
class TeamModel extends HiveObject with _$TeamModel {
  @HiveType(typeId: 0, adapterName: 'TeamModelAdapter')
  factory TeamModel({
    @HiveField(0) String? id,
    @HiveField(1) String? name,
    @HiveField(2) int? match,
    @HiveField(3) int? win,
    @HiveField(4) int? loss,
  }) = _TeamModel;

  TeamModel._();

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);
}
