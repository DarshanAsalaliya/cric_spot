// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bowling_lineup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BowlingLineUpModel _$BowlingLineUpModelFromJson(Map<String, dynamic> json) {
  return _BowlingLineUpMode.fromJson(json);
}

/// @nodoc
mixin _$BowlingLineUpModel {
  @HiveField(0)
  String? get playerId => throw _privateConstructorUsedError;
  @HiveField(0)
  set playerId(String? value) => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get name => throw _privateConstructorUsedError;
  @HiveField(1)
  set name(String? value) => throw _privateConstructorUsedError;
  @HiveField(2)
  int? get run => throw _privateConstructorUsedError;
  @HiveField(2)
  set run(int? value) => throw _privateConstructorUsedError;
  @HiveField(3)
  int? get ball => throw _privateConstructorUsedError;
  @HiveField(3)
  set ball(int? value) => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get wicket => throw _privateConstructorUsedError;
  @HiveField(4)
  set wicket(int? value) => throw _privateConstructorUsedError;
  @HiveField(5)
  int? get maidan => throw _privateConstructorUsedError;
  @HiveField(5)
  set maidan(int? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BowlingLineUpModelCopyWith<BowlingLineUpModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BowlingLineUpModelCopyWith<$Res> {
  factory $BowlingLineUpModelCopyWith(
          BowlingLineUpModel value, $Res Function(BowlingLineUpModel) then) =
      _$BowlingLineUpModelCopyWithImpl<$Res, BowlingLineUpModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? playerId,
      @HiveField(1) String? name,
      @HiveField(2) int? run,
      @HiveField(3) int? ball,
      @HiveField(4) int? wicket,
      @HiveField(5) int? maidan});
}

/// @nodoc
class _$BowlingLineUpModelCopyWithImpl<$Res, $Val extends BowlingLineUpModel>
    implements $BowlingLineUpModelCopyWith<$Res> {
  _$BowlingLineUpModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = freezed,
    Object? name = freezed,
    Object? run = freezed,
    Object? ball = freezed,
    Object? wicket = freezed,
    Object? maidan = freezed,
  }) {
    return _then(_value.copyWith(
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      run: freezed == run
          ? _value.run
          : run // ignore: cast_nullable_to_non_nullable
              as int?,
      ball: freezed == ball
          ? _value.ball
          : ball // ignore: cast_nullable_to_non_nullable
              as int?,
      wicket: freezed == wicket
          ? _value.wicket
          : wicket // ignore: cast_nullable_to_non_nullable
              as int?,
      maidan: freezed == maidan
          ? _value.maidan
          : maidan // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BowlingLineUpModeImplCopyWith<$Res>
    implements $BowlingLineUpModelCopyWith<$Res> {
  factory _$$BowlingLineUpModeImplCopyWith(_$BowlingLineUpModeImpl value,
          $Res Function(_$BowlingLineUpModeImpl) then) =
      __$$BowlingLineUpModeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? playerId,
      @HiveField(1) String? name,
      @HiveField(2) int? run,
      @HiveField(3) int? ball,
      @HiveField(4) int? wicket,
      @HiveField(5) int? maidan});
}

/// @nodoc
class __$$BowlingLineUpModeImplCopyWithImpl<$Res>
    extends _$BowlingLineUpModelCopyWithImpl<$Res, _$BowlingLineUpModeImpl>
    implements _$$BowlingLineUpModeImplCopyWith<$Res> {
  __$$BowlingLineUpModeImplCopyWithImpl(_$BowlingLineUpModeImpl _value,
      $Res Function(_$BowlingLineUpModeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = freezed,
    Object? name = freezed,
    Object? run = freezed,
    Object? ball = freezed,
    Object? wicket = freezed,
    Object? maidan = freezed,
  }) {
    return _then(_$BowlingLineUpModeImpl(
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      run: freezed == run
          ? _value.run
          : run // ignore: cast_nullable_to_non_nullable
              as int?,
      ball: freezed == ball
          ? _value.ball
          : ball // ignore: cast_nullable_to_non_nullable
              as int?,
      wicket: freezed == wicket
          ? _value.wicket
          : wicket // ignore: cast_nullable_to_non_nullable
              as int?,
      maidan: freezed == maidan
          ? _value.maidan
          : maidan // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 5, adapterName: 'BowlingLineUpModelAdapter')
class _$BowlingLineUpModeImpl extends _BowlingLineUpMode {
  _$BowlingLineUpModeImpl(
      {@HiveField(0) this.playerId,
      @HiveField(1) this.name,
      @HiveField(2) this.run,
      @HiveField(3) this.ball,
      @HiveField(4) this.wicket,
      @HiveField(5) this.maidan})
      : super._();

  factory _$BowlingLineUpModeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BowlingLineUpModeImplFromJson(json);

  @override
  @HiveField(0)
  String? playerId;
  @override
  @HiveField(1)
  String? name;
  @override
  @HiveField(2)
  int? run;
  @override
  @HiveField(3)
  int? ball;
  @override
  @HiveField(4)
  int? wicket;
  @override
  @HiveField(5)
  int? maidan;

  @override
  String toString() {
    return 'BowlingLineUpModel(playerId: $playerId, name: $name, run: $run, ball: $ball, wicket: $wicket, maidan: $maidan)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BowlingLineUpModeImplCopyWith<_$BowlingLineUpModeImpl> get copyWith =>
      __$$BowlingLineUpModeImplCopyWithImpl<_$BowlingLineUpModeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BowlingLineUpModeImplToJson(
      this,
    );
  }
}

abstract class _BowlingLineUpMode extends BowlingLineUpModel {
  factory _BowlingLineUpMode(
      {@HiveField(0) String? playerId,
      @HiveField(1) String? name,
      @HiveField(2) int? run,
      @HiveField(3) int? ball,
      @HiveField(4) int? wicket,
      @HiveField(5) int? maidan}) = _$BowlingLineUpModeImpl;
  _BowlingLineUpMode._() : super._();

  factory _BowlingLineUpMode.fromJson(Map<String, dynamic> json) =
      _$BowlingLineUpModeImpl.fromJson;

  @override
  @HiveField(0)
  String? get playerId;
  @HiveField(0)
  set playerId(String? value);
  @override
  @HiveField(1)
  String? get name;
  @HiveField(1)
  set name(String? value);
  @override
  @HiveField(2)
  int? get run;
  @HiveField(2)
  set run(int? value);
  @override
  @HiveField(3)
  int? get ball;
  @HiveField(3)
  set ball(int? value);
  @override
  @HiveField(4)
  int? get wicket;
  @HiveField(4)
  set wicket(int? value);
  @override
  @HiveField(5)
  int? get maidan;
  @HiveField(5)
  set maidan(int? value);
  @override
  @JsonKey(ignore: true)
  _$$BowlingLineUpModeImplCopyWith<_$BowlingLineUpModeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
