import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@unfreezed
class MatchModel extends HiveObject with _$MatchModel {
  @HiveType(typeId: 2, adapterName: 'MatchModelAdapter')
  factory MatchModel({
    @HiveField(0) String? id,
    @HiveField(1) String? over,
    @HiveField(2) bool? isWideBall,
    @HiveField(3) bool? isWideReball,
    @HiveField(4) int? wideRun,
    @HiveField(5) bool? isNoball,
    @HiveField(6) bool? isNoballReball,
    @HiveField(7) int? noballRun,
    @HiveField(8) String? hostTeamId,
    @HiveField(9) String? visitorTeamId,
    @HiveField(10) String? tossId,
    @HiveField(11) String? tossName,
    @HiveField(12) String? tossElect,
    @HiveField(13) String? wonId,
    @HiveField(14) String? wonName,
    @HiveField(15) String? wonBy,
    @HiveField(16) String? firstBatTeamName,
    @HiveField(17) String? firstBatTeamScore,
    @HiveField(18) String? firstBatTeamOver,
    @HiveField(19) String? secondBatTeamName,
    @HiveField(20) String? secondBatTeamScore,
    @HiveField(21) String? secondBatTeamOver,
    @HiveField(22) String? inningOneId,
    @HiveField(23) String? inningTwoId,
    @HiveField(24) String? playerPerMatch,
  }) = _MatchModel;
  MatchModel._();

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}
