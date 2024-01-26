import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'batting_lineup_model.freezed.dart';
part 'batting_lineup_model.g.dart';

@unfreezed
class BattingLineUpModel extends HiveObject with _$BattingLineUpModel {
  @HiveType(typeId: 4, adapterName: "BattingLineUpModelAdapter")
  factory BattingLineUpModel({
    @HiveField(0) String? playerId,
    @HiveField(1) String? name,
    @HiveField(2) int? run,
    @HiveField(3) int? ball,
    @HiveField(4) int? four,
    @HiveField(5) int? six,
    @HiveField(6) bool? isNotOut,
    @HiveField(7) String? outBy,
    @HiveField(8) String? outType,
  }) = _BattingLineUpModel;
  BattingLineUpModel._();

  factory BattingLineUpModel.fromJson(Map<String, dynamic> json) =>
      _$BattingLineUpModelFromJson(json);

  // BattingLineUpModel(
  //     {this.playerId,
  //     this.name,
  //     this.run,
  //     this.ball,
  //     this.four,
  //     this.isNotOut,
  //     this.outBy,
  //     this.outType,
  //     this.six});

  // factory BattingLineUpModel.fromJson(Map<String, dynamic> json) {
  //   return BattingLineUpModel(
  //     playerId: json['playerId'] as String?,
  //     name: json['name'] as String?,
  //     run: json['run'] as int?,
  //     ball: json['ball'] as int?,
  //     four: json['four'] as int?,
  //     six: json['six'] as int?,
  //     isNotOut: json['isNotOut'] as bool?,
  //     outBy: json['outBy'] as String?,
  //     outType: json['outType'] as String?,
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'playerId': playerId,
  //     'name': name,
  //     'run': run,
  //     'ball': ball,
  //     'four': four,
  //     'six': six,
  //     'isNotOut': isNotOut,
  //     'outBy': outBy,
  //     'outType': outType,
  //   };
  // }
}
