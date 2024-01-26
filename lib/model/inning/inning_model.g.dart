// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inning_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InningModelAdapter extends TypeAdapter<_$InningModelImpl> {
  @override
  final int typeId = 3;

  @override
  _$InningModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$InningModelImpl(
      id: fields[0] as String?,
      matchId: fields[1] as String?,
      batTeamName: fields[2] as String?,
      bowlTeamName: fields[3] as String?,
      totalRun: fields[4] as int?,
      totalWicket: fields[5] as int?,
      totalBall: fields[6] as int?,
      battingLineup: (fields[7] as List?)?.cast<BattingLineUpModel>(),
      bowlingLineup: (fields[8] as List?)?.cast<BowlingLineUpModel>(),
      extraRun: fields[9] as ExtraRunModel?,
      currentBowler: fields[10] as BowlingLineUpModel?,
      currentStriker: fields[11] as BattingLineUpModel?,
      currentNonStriker: fields[12] as BattingLineUpModel?,
      overs: (fields[13] as List?)
          ?.map((dynamic e) => (e as List).cast<String>())
          ?.toList(),
      currentOver: (fields[14] as List?)?.cast<String>(),
      partnerShips: (fields[15] as List?)?.cast<PartnerShipModel>(),
      currentPartnerShip: fields[16] as PartnerShipModel?,
      isFirstInning: fields[17] as bool?,
      fallOfWicket: (fields[18] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, String>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, _$InningModelImpl obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matchId)
      ..writeByte(2)
      ..write(obj.batTeamName)
      ..writeByte(3)
      ..write(obj.bowlTeamName)
      ..writeByte(4)
      ..write(obj.totalRun)
      ..writeByte(5)
      ..write(obj.totalWicket)
      ..writeByte(6)
      ..write(obj.totalBall)
      ..writeByte(7)
      ..write(obj.battingLineup)
      ..writeByte(8)
      ..write(obj.bowlingLineup)
      ..writeByte(9)
      ..write(obj.extraRun)
      ..writeByte(10)
      ..write(obj.currentBowler)
      ..writeByte(11)
      ..write(obj.currentStriker)
      ..writeByte(12)
      ..write(obj.currentNonStriker)
      ..writeByte(13)
      ..write(obj.overs)
      ..writeByte(14)
      ..write(obj.currentOver)
      ..writeByte(15)
      ..write(obj.partnerShips)
      ..writeByte(16)
      ..write(obj.currentPartnerShip)
      ..writeByte(17)
      ..write(obj.isFirstInning)
      ..writeByte(18)
      ..write(obj.fallOfWicket);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InningModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InningModelImpl _$$InningModelImplFromJson(Map<String, dynamic> json) =>
    _$InningModelImpl(
      id: json['id'] as String?,
      matchId: json['matchId'] as String?,
      batTeamName: json['batTeamName'] as String?,
      bowlTeamName: json['bowlTeamName'] as String?,
      totalRun: json['totalRun'] as int?,
      totalWicket: json['totalWicket'] as int?,
      totalBall: json['totalBall'] as int?,
      battingLineup: (json['battingLineup'] as List<dynamic>?)
          ?.map((e) => BattingLineUpModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bowlingLineup: (json['bowlingLineup'] as List<dynamic>?)
          ?.map((e) => BowlingLineUpModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraRun: json['extraRun'] == null
          ? null
          : ExtraRunModel.fromJson(json['extraRun'] as Map<String, dynamic>),
      currentBowler: json['currentBowler'] == null
          ? null
          : BowlingLineUpModel.fromJson(
              json['currentBowler'] as Map<String, dynamic>),
      currentStriker: json['currentStriker'] == null
          ? null
          : BattingLineUpModel.fromJson(
              json['currentStriker'] as Map<String, dynamic>),
      currentNonStriker: json['currentNonStriker'] == null
          ? null
          : BattingLineUpModel.fromJson(
              json['currentNonStriker'] as Map<String, dynamic>),
      overs: (json['overs'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      currentOver: (json['currentOver'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      partnerShips: (json['partnerShips'] as List<dynamic>?)
          ?.map((e) => PartnerShipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPartnerShip: json['currentPartnerShip'] == null
          ? null
          : PartnerShipModel.fromJson(
              json['currentPartnerShip'] as Map<String, dynamic>),
      isFirstInning: json['isFirstInning'] as bool?,
      fallOfWicket: (json['fallOfWicket'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$$InningModelImplToJson(_$InningModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'batTeamName': instance.batTeamName,
      'bowlTeamName': instance.bowlTeamName,
      'totalRun': instance.totalRun,
      'totalWicket': instance.totalWicket,
      'totalBall': instance.totalBall,
      'battingLineup': instance.battingLineup,
      'bowlingLineup': instance.bowlingLineup,
      'extraRun': instance.extraRun,
      'currentBowler': instance.currentBowler,
      'currentStriker': instance.currentStriker,
      'currentNonStriker': instance.currentNonStriker,
      'overs': instance.overs,
      'currentOver': instance.currentOver,
      'partnerShips': instance.partnerShips,
      'currentPartnerShip': instance.currentPartnerShip,
      'isFirstInning': instance.isFirstInning,
      'fallOfWicket': instance.fallOfWicket,
    };
