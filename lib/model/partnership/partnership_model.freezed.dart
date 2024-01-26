// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partnership_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PartnerShipModel _$PartnerShipModelFromJson(Map<String, dynamic> json) {
  return _PartnerShipModel.fromJson(json);
}

/// @nodoc
mixin _$PartnerShipModel {
  @HiveField(0)
  String? get id => throw _privateConstructorUsedError;
  @HiveField(0)
  set id(String? value) => throw _privateConstructorUsedError;
  @HiveField(1)
  int? get run => throw _privateConstructorUsedError;
  @HiveField(1)
  set run(int? value) => throw _privateConstructorUsedError;
  @HiveField(2)
  int? get ball => throw _privateConstructorUsedError;
  @HiveField(2)
  set ball(int? value) => throw _privateConstructorUsedError;
  @HiveField(3)
  int? get extra => throw _privateConstructorUsedError;
  @HiveField(3)
  set extra(int? value) => throw _privateConstructorUsedError;
  @HiveField(4)
  BattingLineUpModel? get currentStiker => throw _privateConstructorUsedError;
  @HiveField(4)
  set currentStiker(BattingLineUpModel? value) =>
      throw _privateConstructorUsedError;
  @HiveField(5)
  BattingLineUpModel? get currentNotStiker =>
      throw _privateConstructorUsedError;
  @HiveField(5)
  set currentNotStiker(BattingLineUpModel? value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PartnerShipModelCopyWith<PartnerShipModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnerShipModelCopyWith<$Res> {
  factory $PartnerShipModelCopyWith(
          PartnerShipModel value, $Res Function(PartnerShipModel) then) =
      _$PartnerShipModelCopyWithImpl<$Res, PartnerShipModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? id,
      @HiveField(1) int? run,
      @HiveField(2) int? ball,
      @HiveField(3) int? extra,
      @HiveField(4) BattingLineUpModel? currentStiker,
      @HiveField(5) BattingLineUpModel? currentNotStiker});

  $BattingLineUpModelCopyWith<$Res>? get currentStiker;
  $BattingLineUpModelCopyWith<$Res>? get currentNotStiker;
}

/// @nodoc
class _$PartnerShipModelCopyWithImpl<$Res, $Val extends PartnerShipModel>
    implements $PartnerShipModelCopyWith<$Res> {
  _$PartnerShipModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? run = freezed,
    Object? ball = freezed,
    Object? extra = freezed,
    Object? currentStiker = freezed,
    Object? currentNotStiker = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      run: freezed == run
          ? _value.run
          : run // ignore: cast_nullable_to_non_nullable
              as int?,
      ball: freezed == ball
          ? _value.ball
          : ball // ignore: cast_nullable_to_non_nullable
              as int?,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStiker: freezed == currentStiker
          ? _value.currentStiker
          : currentStiker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
      currentNotStiker: freezed == currentNotStiker
          ? _value.currentNotStiker
          : currentNotStiker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BattingLineUpModelCopyWith<$Res>? get currentStiker {
    if (_value.currentStiker == null) {
      return null;
    }

    return $BattingLineUpModelCopyWith<$Res>(_value.currentStiker!, (value) {
      return _then(_value.copyWith(currentStiker: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BattingLineUpModelCopyWith<$Res>? get currentNotStiker {
    if (_value.currentNotStiker == null) {
      return null;
    }

    return $BattingLineUpModelCopyWith<$Res>(_value.currentNotStiker!, (value) {
      return _then(_value.copyWith(currentNotStiker: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartnerShipModelImplCopyWith<$Res>
    implements $PartnerShipModelCopyWith<$Res> {
  factory _$$PartnerShipModelImplCopyWith(_$PartnerShipModelImpl value,
          $Res Function(_$PartnerShipModelImpl) then) =
      __$$PartnerShipModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? id,
      @HiveField(1) int? run,
      @HiveField(2) int? ball,
      @HiveField(3) int? extra,
      @HiveField(4) BattingLineUpModel? currentStiker,
      @HiveField(5) BattingLineUpModel? currentNotStiker});

  @override
  $BattingLineUpModelCopyWith<$Res>? get currentStiker;
  @override
  $BattingLineUpModelCopyWith<$Res>? get currentNotStiker;
}

/// @nodoc
class __$$PartnerShipModelImplCopyWithImpl<$Res>
    extends _$PartnerShipModelCopyWithImpl<$Res, _$PartnerShipModelImpl>
    implements _$$PartnerShipModelImplCopyWith<$Res> {
  __$$PartnerShipModelImplCopyWithImpl(_$PartnerShipModelImpl _value,
      $Res Function(_$PartnerShipModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? run = freezed,
    Object? ball = freezed,
    Object? extra = freezed,
    Object? currentStiker = freezed,
    Object? currentNotStiker = freezed,
  }) {
    return _then(_$PartnerShipModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      run: freezed == run
          ? _value.run
          : run // ignore: cast_nullable_to_non_nullable
              as int?,
      ball: freezed == ball
          ? _value.ball
          : ball // ignore: cast_nullable_to_non_nullable
              as int?,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStiker: freezed == currentStiker
          ? _value.currentStiker
          : currentStiker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
      currentNotStiker: freezed == currentNotStiker
          ? _value.currentNotStiker
          : currentNotStiker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 7, adapterName: 'PartnerShipModelAdapter')
class _$PartnerShipModelImpl extends _PartnerShipModel {
  _$PartnerShipModelImpl(
      {@HiveField(0) this.id,
      @HiveField(1) this.run,
      @HiveField(2) this.ball,
      @HiveField(3) this.extra,
      @HiveField(4) this.currentStiker,
      @HiveField(5) this.currentNotStiker})
      : super._();

  factory _$PartnerShipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartnerShipModelImplFromJson(json);

  @override
  @HiveField(0)
  String? id;
  @override
  @HiveField(1)
  int? run;
  @override
  @HiveField(2)
  int? ball;
  @override
  @HiveField(3)
  int? extra;
  @override
  @HiveField(4)
  BattingLineUpModel? currentStiker;
  @override
  @HiveField(5)
  BattingLineUpModel? currentNotStiker;

  @override
  String toString() {
    return 'PartnerShipModel(id: $id, run: $run, ball: $ball, extra: $extra, currentStiker: $currentStiker, currentNotStiker: $currentNotStiker)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnerShipModelImplCopyWith<_$PartnerShipModelImpl> get copyWith =>
      __$$PartnerShipModelImplCopyWithImpl<_$PartnerShipModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartnerShipModelImplToJson(
      this,
    );
  }
}

abstract class _PartnerShipModel extends PartnerShipModel {
  factory _PartnerShipModel(
          {@HiveField(0) String? id,
          @HiveField(1) int? run,
          @HiveField(2) int? ball,
          @HiveField(3) int? extra,
          @HiveField(4) BattingLineUpModel? currentStiker,
          @HiveField(5) BattingLineUpModel? currentNotStiker}) =
      _$PartnerShipModelImpl;
  _PartnerShipModel._() : super._();

  factory _PartnerShipModel.fromJson(Map<String, dynamic> json) =
      _$PartnerShipModelImpl.fromJson;

  @override
  @HiveField(0)
  String? get id;
  @HiveField(0)
  set id(String? value);
  @override
  @HiveField(1)
  int? get run;
  @HiveField(1)
  set run(int? value);
  @override
  @HiveField(2)
  int? get ball;
  @HiveField(2)
  set ball(int? value);
  @override
  @HiveField(3)
  int? get extra;
  @HiveField(3)
  set extra(int? value);
  @override
  @HiveField(4)
  BattingLineUpModel? get currentStiker;
  @HiveField(4)
  set currentStiker(BattingLineUpModel? value);
  @override
  @HiveField(5)
  BattingLineUpModel? get currentNotStiker;
  @HiveField(5)
  set currentNotStiker(BattingLineUpModel? value);
  @override
  @JsonKey(ignore: true)
  _$$PartnerShipModelImplCopyWith<_$PartnerShipModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
