// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamModelAdapter extends TypeAdapter<_$TeamModelImpl> {
  @override
  final int typeId = 0;

  @override
  _$TeamModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$TeamModelImpl(
      id: fields[0] as String?,
      name: fields[1] as String?,
      match: fields[2] as int?,
      win: fields[3] as int?,
      loss: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, _$TeamModelImpl obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.match)
      ..writeByte(3)
      ..write(obj.win)
      ..writeByte(4)
      ..write(obj.loss);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamModelImpl _$$TeamModelImplFromJson(Map<String, dynamic> json) =>
    _$TeamModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      match: json['match'] as int?,
      win: json['win'] as int?,
      loss: json['loss'] as int?,
    );

Map<String, dynamic> _$$TeamModelImplToJson(_$TeamModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'match': instance.match,
      'win': instance.win,
      'loss': instance.loss,
    };
