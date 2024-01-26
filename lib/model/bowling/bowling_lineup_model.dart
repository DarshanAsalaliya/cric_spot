import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'bowling_lineup_model.freezed.dart';
part 'bowling_lineup_model.g.dart';

@unfreezed
class BowlingLineUpModel extends HiveObject with _$BowlingLineUpModel {
  @HiveType(typeId: 5, adapterName: 'BowlingLineUpModelAdapter')
  factory BowlingLineUpModel({
    @HiveField(0) String? playerId,
    @HiveField(1) String? name,
    @HiveField(2) int? run,
    @HiveField(3) int? ball,
    @HiveField(4) int? wicket,
    @HiveField(5) int? maidan,
  }) = _BowlingLineUpMode;

  BowlingLineUpModel._();

  factory BowlingLineUpModel.fromJson(Map<String, dynamic> json) =>
      _$BowlingLineUpModelFromJson(json);

  // Map<String, dynamic> toJson() {
  //   return {
  //     'playerId': playerId,
  //     'name': name,
  //     'run': run,
  //     'ball': ball,
  //     'wicket': wicket,
  //     'maidan': maidan,
  //   };
  // }
}
