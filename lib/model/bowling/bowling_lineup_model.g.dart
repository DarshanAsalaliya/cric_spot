// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_lineup_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BowlingLineUpModelAdapter extends TypeAdapter<_$BowlingLineUpModeImpl> {
  @override
  final int typeId = 5;

  @override
  _$BowlingLineUpModeImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$BowlingLineUpModeImpl(
      playerId: fields[0] as String?,
      name: fields[1] as String?,
      run: fields[2] as int?,
      ball: fields[3] as int?,
      wicket: fields[4] as int?,
      maidan: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, _$BowlingLineUpModeImpl obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.run)
      ..writeByte(3)
      ..write(obj.ball)
      ..writeByte(4)
      ..write(obj.wicket)
      ..writeByte(5)
      ..write(obj.maidan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BowlingLineUpModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BowlingLineUpModeImpl _$$BowlingLineUpModeImplFromJson(
        Map<String, dynamic> json) =>
    _$BowlingLineUpModeImpl(
      playerId: json['playerId'] as String?,
      name: json['name'] as String?,
      run: json['run'] as int?,
      ball: json['ball'] as int?,
      wicket: json['wicket'] as int?,
      maidan: json['maidan'] as int?,
    );

Map<String, dynamic> _$$BowlingLineUpModeImplToJson(
        _$BowlingLineUpModeImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'name': instance.name,
      'run': instance.run,
      'ball': instance.ball,
      'wicket': instance.wicket,
      'maidan': instance.maidan,
    };
