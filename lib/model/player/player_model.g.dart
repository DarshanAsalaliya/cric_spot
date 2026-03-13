// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerModelAdapter extends TypeAdapter<_$PlayerModelImpl> {
  @override
  final int typeId = 1;

  @override
  _$PlayerModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PlayerModelImpl(
      id: fields[0] as String?,
      name: fields[1] as String?,
      remoteId: fields[2] as String?,
      isSynced: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, _$PlayerModelImpl obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.remoteId)
      ..writeByte(3)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerModelImpl _$$PlayerModelImplFromJson(Map<String, dynamic> json) =>
    _$PlayerModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      remoteId: json['remoteId'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$$PlayerModelImplToJson(_$PlayerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'remoteId': instance.remoteId,
      'isSynced': instance.isSynced,
    };
