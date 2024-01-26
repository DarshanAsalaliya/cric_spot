// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) {
  return _TeamModel.fromJson(json);
}

/// @nodoc
mixin _$TeamModel {
  @HiveField(0)
  String? get id => throw _privateConstructorUsedError;
  @HiveField(0)
  set id(String? value) => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get name => throw _privateConstructorUsedError;
  @HiveField(1)
  set name(String? value) => throw _privateConstructorUsedError;
  @HiveField(2)
  int? get match => throw _privateConstructorUsedError;
  @HiveField(2)
  set match(int? value) => throw _privateConstructorUsedError;
  @HiveField(3)
  int? get win => throw _privateConstructorUsedError;
  @HiveField(3)
  set win(int? value) => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get loss => throw _privateConstructorUsedError;
  @HiveField(4)
  set loss(int? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamModelCopyWith<TeamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamModelCopyWith<$Res> {
  factory $TeamModelCopyWith(TeamModel value, $Res Function(TeamModel) then) =
      _$TeamModelCopyWithImpl<$Res, TeamModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? id,
      @HiveField(1) String? name,
      @HiveField(2) int? match,
      @HiveField(3) int? win,
      @HiveField(4) int? loss});
}

/// @nodoc
class _$TeamModelCopyWithImpl<$Res, $Val extends TeamModel>
    implements $TeamModelCopyWith<$Res> {
  _$TeamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? match = freezed,
    Object? win = freezed,
    Object? loss = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      match: freezed == match
          ? _value.match
          : match // ignore: cast_nullable_to_non_nullable
              as int?,
      win: freezed == win
          ? _value.win
          : win // ignore: cast_nullable_to_non_nullable
              as int?,
      loss: freezed == loss
          ? _value.loss
          : loss // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamModelImplCopyWith<$Res>
    implements $TeamModelCopyWith<$Res> {
  factory _$$TeamModelImplCopyWith(
          _$TeamModelImpl value, $Res Function(_$TeamModelImpl) then) =
      __$$TeamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? id,
      @HiveField(1) String? name,
      @HiveField(2) int? match,
      @HiveField(3) int? win,
      @HiveField(4) int? loss});
}

/// @nodoc
class __$$TeamModelImplCopyWithImpl<$Res>
    extends _$TeamModelCopyWithImpl<$Res, _$TeamModelImpl>
    implements _$$TeamModelImplCopyWith<$Res> {
  __$$TeamModelImplCopyWithImpl(
      _$TeamModelImpl _value, $Res Function(_$TeamModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? match = freezed,
    Object? win = freezed,
    Object? loss = freezed,
  }) {
    return _then(_$TeamModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      match: freezed == match
          ? _value.match
          : match // ignore: cast_nullable_to_non_nullable
              as int?,
      win: freezed == win
          ? _value.win
          : win // ignore: cast_nullable_to_non_nullable
              as int?,
      loss: freezed == loss
          ? _value.loss
          : loss // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0, adapterName: 'TeamModelAdapter')
class _$TeamModelImpl extends _TeamModel {
  _$TeamModelImpl(
      {@HiveField(0) this.id,
      @HiveField(1) this.name,
      @HiveField(2) this.match,
      @HiveField(3) this.win,
      @HiveField(4) this.loss})
      : super._();

  factory _$TeamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamModelImplFromJson(json);

  @override
  @HiveField(0)
  String? id;
  @override
  @HiveField(1)
  String? name;
  @override
  @HiveField(2)
  int? match;
  @override
  @HiveField(3)
  int? win;
  @override
  @HiveField(4)
  int? loss;

  @override
  String toString() {
    return 'TeamModel(id: $id, name: $name, match: $match, win: $win, loss: $loss)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      __$$TeamModelImplCopyWithImpl<_$TeamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamModelImplToJson(
      this,
    );
  }
}

abstract class _TeamModel extends TeamModel {
  factory _TeamModel(
      {@HiveField(0) String? id,
      @HiveField(1) String? name,
      @HiveField(2) int? match,
      @HiveField(3) int? win,
      @HiveField(4) int? loss}) = _$TeamModelImpl;
  _TeamModel._() : super._();

  factory _TeamModel.fromJson(Map<String, dynamic> json) =
      _$TeamModelImpl.fromJson;

  @override
  @HiveField(0)
  String? get id;
  @HiveField(0)
  set id(String? value);
  @override
  @HiveField(1)
  String? get name;
  @HiveField(1)
  set name(String? value);
  @override
  @HiveField(2)
  int? get match;
  @HiveField(2)
  set match(int? value);
  @override
  @HiveField(3)
  int? get win;
  @HiveField(3)
  set win(int? value);
  @override
  @HiveField(4)
  int? get loss;
  @HiveField(4)
  set loss(int? value);
  @override
  @JsonKey(ignore: true)
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
