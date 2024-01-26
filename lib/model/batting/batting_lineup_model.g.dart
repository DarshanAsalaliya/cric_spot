// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batting_lineup_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BattingLineUpModelAdapter extends TypeAdapter<_$BattingLineUpModelImpl> {
  @override
  final int typeId = 4;

  @override
  _$BattingLineUpModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$BattingLineUpModelImpl(
      playerId: fields[0] as String?,
      name: fields[1] as String?,
      run: fields[2] as int?,
      ball: fields[3] as int?,
      four: fields[4] as int?,
      six: fields[5] as int?,
      isNotOut: fields[6] as bool?,
      outBy: fields[7] as String?,
      outType: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$BattingLineUpModelImpl obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.run)
      ..writeByte(3)
      ..write(obj.ball)
      ..writeByte(4)
      ..write(obj.four)
      ..writeByte(5)
      ..write(obj.six)
      ..writeByte(6)
      ..write(obj.isNotOut)
      ..writeByte(7)
      ..write(obj.outBy)
      ..writeByte(8)
      ..write(obj.outType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BattingLineUpModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BattingLineUpModelImpl _$$BattingLineUpModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BattingLineUpModelImpl(
      playerId: json['playerId'] as String?,
      name: json['name'] as String?,
      run: json['run'] as int?,
      ball: json['ball'] as int?,
      four: json['four'] as int?,
      six: json['six'] as int?,
      isNotOut: json['isNotOut'] as bool?,
      outBy: json['outBy'] as String?,
      outType: json['outType'] as String?,
    );

Map<String, dynamic> _$$BattingLineUpModelImplToJson(
        _$BattingLineUpModelImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'name': instance.name,
      'run': instance.run,
      'ball': instance.ball,
      'four': instance.four,
      'six': instance.six,
      'isNotOut': instance.isNotOut,
      'outBy': instance.outBy,
      'outType': instance.outType,
    };
