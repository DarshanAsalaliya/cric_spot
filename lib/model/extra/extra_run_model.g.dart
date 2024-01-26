// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_run_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtraRunModelAdapter extends TypeAdapter<_$ExtraRunModelImpl> {
  @override
  final int typeId = 6;

  @override
  _$ExtraRunModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$ExtraRunModelImpl(
      wide: fields[0] as int?,
      noBall: fields[1] as int?,
      legBy: fields[2] as int?,
      by: fields[3] as int?,
      penlaty: fields[4] as int?,
      total: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, _$ExtraRunModelImpl obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.wide)
      ..writeByte(1)
      ..write(obj.noBall)
      ..writeByte(2)
      ..write(obj.legBy)
      ..writeByte(3)
      ..write(obj.by)
      ..writeByte(4)
      ..write(obj.penlaty)
      ..writeByte(5)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraRunModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtraRunModelImpl _$$ExtraRunModelImplFromJson(Map<String, dynamic> json) =>
    _$ExtraRunModelImpl(
      wide: json['wide'] as int?,
      noBall: json['noBall'] as int?,
      legBy: json['legBy'] as int?,
      by: json['by'] as int?,
      penlaty: json['penlaty'] as int?,
      total: json['total'] as int?,
    );

Map<String, dynamic> _$$ExtraRunModelImplToJson(_$ExtraRunModelImpl instance) =>
    <String, dynamic>{
      'wide': instance.wide,
      'noBall': instance.noBall,
      'legBy': instance.legBy,
      'by': instance.by,
      'penlaty': instance.penlaty,
      'total': instance.total,
    };
