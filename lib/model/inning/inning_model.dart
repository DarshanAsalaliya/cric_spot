import 'package:cric_spot/model/batting/batting_lineup_model.dart';
import 'package:cric_spot/model/bowling/bowling_lineup_model.dart';
import 'package:cric_spot/model/extra/extra_run_model.dart';
import 'package:cric_spot/model/partnership/partnership_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'inning_model.freezed.dart';
part 'inning_model.g.dart';

@unfreezed
class InningModel extends HiveObject with _$InningModel {
  @HiveType(typeId: 3, adapterName: 'InningModelAdapter')
  factory InningModel({
    @HiveField(0) String? id,
    @HiveField(1) String? matchId,
    @HiveField(2) String? batTeamName,
    @HiveField(3) String? bowlTeamName,
    @HiveField(4) int? totalRun,
    @HiveField(5) int? totalWicket,
    @HiveField(6) int? totalBall,
    @HiveField(7) List<BattingLineUpModel>? battingLineup,
    @HiveField(8) List<BowlingLineUpModel>? bowlingLineup,
    @HiveField(9) ExtraRunModel? extraRun,
    @HiveField(10) BowlingLineUpModel? currentBowler,
    @HiveField(11) BattingLineUpModel? currentStriker,
    @HiveField(12) BattingLineUpModel? currentNonStriker,
    @HiveField(13) List<List<String>>? overs,
    @HiveField(14) List<String>? currentOver,
    @HiveField(15) List<PartnerShipModel>? partnerShips,
    @HiveField(16) PartnerShipModel? currentPartnerShip,
    @HiveField(17) bool? isFirstInning,
    @HiveField(18) List<Map<String, String>>? fallOfWicket,
  }) = _InningModel;
  InningModel._();

  factory InningModel.fromJson(Map<String, dynamic> json) =>
      _$InningModelFromJson(json)
        ..battingLineup = (json['battingLineup'] as List<dynamic>?)
            ?.map((e) => BattingLineUpModel.fromJson(e as Map<String, dynamic>))
            .toList()
        ..bowlingLineup = (json['bowlingLineup'] as List<dynamic>?)
            ?.map((e) => BowlingLineUpModel.fromJson(e as Map<String, dynamic>))
            .toList()
        ..extraRun = json['extraRun'] != null
            ? ExtraRunModel.fromJson(json['extraRun'] as Map<String, dynamic>)
            : null
        ..partnerShips = (json['partnerShips'] as List<dynamic>?)
            ?.map((e) => PartnerShipModel.fromJson(e as Map<String, dynamic>))
            .toList();
}
