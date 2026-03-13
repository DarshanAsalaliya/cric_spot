import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@unfreezed
class PlayerModel extends HiveObject with _$PlayerModel {
  @HiveType(typeId: 1, adapterName: 'PlayerModelAdapter')
  factory PlayerModel({
    @HiveField(0) String? id,
    @HiveField(1) String? name,
    @HiveField(2) String? remoteId,
    @HiveField(3) @Default(false) bool? isSynced,
  }) = _PlayerModel;
  PlayerModel._();

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
