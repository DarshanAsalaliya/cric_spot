// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inning_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

InningModel _$InningModelFromJson(Map<String, dynamic> json) {
  return _InningModel.fromJson(json);
}

/// @nodoc
mixin _$InningModel {
  @HiveField(0)
  String? get id => throw _privateConstructorUsedError;
  @HiveField(0)
  set id(String? value) => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get matchId => throw _privateConstructorUsedError;
  @HiveField(1)
  set matchId(String? value) => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get batTeamName => throw _privateConstructorUsedError;
  @HiveField(2)
  set batTeamName(String? value) => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get bowlTeamName => throw _privateConstructorUsedError;
  @HiveField(3)
  set bowlTeamName(String? value) => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get totalRun => throw _privateConstructorUsedError;
  @HiveField(4)
  set totalRun(int? value) => throw _privateConstructorUsedError;
  @HiveField(5)
  int? get totalWicket => throw _privateConstructorUsedError;
  @HiveField(5)
  set totalWicket(int? value) => throw _privateConstructorUsedError;
  @HiveField(6)
  int? get totalBall => throw _privateConstructorUsedError;
  @HiveField(6)
  set totalBall(int? value) => throw _privateConstructorUsedError;
  @HiveField(7)
  List<BattingLineUpModel>? get battingLineup =>
      throw _privateConstructorUsedError;
  @HiveField(7)
  set battingLineup(List<BattingLineUpModel>? value) =>
      throw _privateConstructorUsedError;
  @HiveField(8)
  List<BowlingLineUpModel>? get bowlingLineup =>
      throw _privateConstructorUsedError;
  @HiveField(8)
  set bowlingLineup(List<BowlingLineUpModel>? value) =>
      throw _privateConstructorUsedError;
  @HiveField(9)
  ExtraRunModel? get extraRun => throw _privateConstructorUsedError;
  @HiveField(9)
  set extraRun(ExtraRunModel? value) => throw _privateConstructorUsedError;
  @HiveField(10)
  BowlingLineUpModel? get currentBowler => throw _privateConstructorUsedError;
  @HiveField(10)
  set currentBowler(BowlingLineUpModel? value) =>
      throw _privateConstructorUsedError;
  @HiveField(11)
  BattingLineUpModel? get currentStriker => throw _privateConstructorUsedError;
  @HiveField(11)
  set currentStriker(BattingLineUpModel? value) =>
      throw _privateConstructorUsedError;
  @HiveField(12)
  BattingLineUpModel? get currentNonStriker =>
      throw _privateConstructorUsedError;
  @HiveField(12)
  set currentNonStriker(BattingLineUpModel? value) =>
      throw _privateConstructorUsedError;
  @HiveField(13)
  List<List<String>>? get overs => throw _privateConstructorUsedError;
  @HiveField(13)
  set overs(List<List<String>>? value) => throw _privateConstructorUsedError;
  @HiveField(14)
  List<String>? get currentOver => throw _privateConstructorUsedError;
  @HiveField(14)
  set currentOver(List<String>? value) => throw _privateConstructorUsedError;
  @HiveField(15)
  List<PartnerShipModel>? get partnerShips =>
      throw _privateConstructorUsedError;
  @HiveField(15)
  set partnerShips(List<PartnerShipModel>? value) =>
      throw _privateConstructorUsedError;
  @HiveField(16)
  PartnerShipModel? get currentPartnerShip =>
      throw _privateConstructorUsedError;
  @HiveField(16)
  set currentPartnerShip(PartnerShipModel? value) =>
      throw _privateConstructorUsedError;
  @HiveField(17)
  bool? get isFirstInning => throw _privateConstructorUsedError;
  @HiveField(17)
  set isFirstInning(bool? value) => throw _privateConstructorUsedError;
  @HiveField(18)
  List<Map<String, String>>? get fallOfWicket =>
      throw _privateConstructorUsedError;
  @HiveField(18)
  set fallOfWicket(List<Map<String, String>>? value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InningModelCopyWith<InningModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InningModelCopyWith<$Res> {
  factory $InningModelCopyWith(
          InningModel value, $Res Function(InningModel) then) =
      _$InningModelCopyWithImpl<$Res, InningModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? id,
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
      @HiveField(18) List<Map<String, String>>? fallOfWicket});

  $ExtraRunModelCopyWith<$Res>? get extraRun;
  $BowlingLineUpModelCopyWith<$Res>? get currentBowler;
  $BattingLineUpModelCopyWith<$Res>? get currentStriker;
  $BattingLineUpModelCopyWith<$Res>? get currentNonStriker;
  $PartnerShipModelCopyWith<$Res>? get currentPartnerShip;
}

/// @nodoc
class _$InningModelCopyWithImpl<$Res, $Val extends InningModel>
    implements $InningModelCopyWith<$Res> {
  _$InningModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? matchId = freezed,
    Object? batTeamName = freezed,
    Object? bowlTeamName = freezed,
    Object? totalRun = freezed,
    Object? totalWicket = freezed,
    Object? totalBall = freezed,
    Object? battingLineup = freezed,
    Object? bowlingLineup = freezed,
    Object? extraRun = freezed,
    Object? currentBowler = freezed,
    Object? currentStriker = freezed,
    Object? currentNonStriker = freezed,
    Object? overs = freezed,
    Object? currentOver = freezed,
    Object? partnerShips = freezed,
    Object? currentPartnerShip = freezed,
    Object? isFirstInning = freezed,
    Object? fallOfWicket = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      matchId: freezed == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String?,
      batTeamName: freezed == batTeamName
          ? _value.batTeamName
          : batTeamName // ignore: cast_nullable_to_non_nullable
              as String?,
      bowlTeamName: freezed == bowlTeamName
          ? _value.bowlTeamName
          : bowlTeamName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalRun: freezed == totalRun
          ? _value.totalRun
          : totalRun // ignore: cast_nullable_to_non_nullable
              as int?,
      totalWicket: freezed == totalWicket
          ? _value.totalWicket
          : totalWicket // ignore: cast_nullable_to_non_nullable
              as int?,
      totalBall: freezed == totalBall
          ? _value.totalBall
          : totalBall // ignore: cast_nullable_to_non_nullable
              as int?,
      battingLineup: freezed == battingLineup
          ? _value.battingLineup
          : battingLineup // ignore: cast_nullable_to_non_nullable
              as List<BattingLineUpModel>?,
      bowlingLineup: freezed == bowlingLineup
          ? _value.bowlingLineup
          : bowlingLineup // ignore: cast_nullable_to_non_nullable
              as List<BowlingLineUpModel>?,
      extraRun: freezed == extraRun
          ? _value.extraRun
          : extraRun // ignore: cast_nullable_to_non_nullable
              as ExtraRunModel?,
      currentBowler: freezed == currentBowler
          ? _value.currentBowler
          : currentBowler // ignore: cast_nullable_to_non_nullable
              as BowlingLineUpModel?,
      currentStriker: freezed == currentStriker
          ? _value.currentStriker
          : currentStriker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
      currentNonStriker: freezed == currentNonStriker
          ? _value.currentNonStriker
          : currentNonStriker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
      overs: freezed == overs
          ? _value.overs
          : overs // ignore: cast_nullable_to_non_nullable
              as List<List<String>>?,
      currentOver: freezed == currentOver
          ? _value.currentOver
          : currentOver // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      partnerShips: freezed == partnerShips
          ? _value.partnerShips
          : partnerShips // ignore: cast_nullable_to_non_nullable
              as List<PartnerShipModel>?,
      currentPartnerShip: freezed == currentPartnerShip
          ? _value.currentPartnerShip
          : currentPartnerShip // ignore: cast_nullable_to_non_nullable
              as PartnerShipModel?,
      isFirstInning: freezed == isFirstInning
          ? _value.isFirstInning
          : isFirstInning // ignore: cast_nullable_to_non_nullable
              as bool?,
      fallOfWicket: freezed == fallOfWicket
          ? _value.fallOfWicket
          : fallOfWicket // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExtraRunModelCopyWith<$Res>? get extraRun {
    if (_value.extraRun == null) {
      return null;
    }

    return $ExtraRunModelCopyWith<$Res>(_value.extraRun!, (value) {
      return _then(_value.copyWith(extraRun: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BowlingLineUpModelCopyWith<$Res>? get currentBowler {
    if (_value.currentBowler == null) {
      return null;
    }

    return $BowlingLineUpModelCopyWith<$Res>(_value.currentBowler!, (value) {
      return _then(_value.copyWith(currentBowler: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BattingLineUpModelCopyWith<$Res>? get currentStriker {
    if (_value.currentStriker == null) {
      return null;
    }

    return $BattingLineUpModelCopyWith<$Res>(_value.currentStriker!, (value) {
      return _then(_value.copyWith(currentStriker: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BattingLineUpModelCopyWith<$Res>? get currentNonStriker {
    if (_value.currentNonStriker == null) {
      return null;
    }

    return $BattingLineUpModelCopyWith<$Res>(_value.currentNonStriker!,
        (value) {
      return _then(_value.copyWith(currentNonStriker: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PartnerShipModelCopyWith<$Res>? get currentPartnerShip {
    if (_value.currentPartnerShip == null) {
      return null;
    }

    return $PartnerShipModelCopyWith<$Res>(_value.currentPartnerShip!, (value) {
      return _then(_value.copyWith(currentPartnerShip: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InningModelImplCopyWith<$Res>
    implements $InningModelCopyWith<$Res> {
  factory _$$InningModelImplCopyWith(
          _$InningModelImpl value, $Res Function(_$InningModelImpl) then) =
      __$$InningModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? id,
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
      @HiveField(18) List<Map<String, String>>? fallOfWicket});

  @override
  $ExtraRunModelCopyWith<$Res>? get extraRun;
  @override
  $BowlingLineUpModelCopyWith<$Res>? get currentBowler;
  @override
  $BattingLineUpModelCopyWith<$Res>? get currentStriker;
  @override
  $BattingLineUpModelCopyWith<$Res>? get currentNonStriker;
  @override
  $PartnerShipModelCopyWith<$Res>? get currentPartnerShip;
}

/// @nodoc
class __$$InningModelImplCopyWithImpl<$Res>
    extends _$InningModelCopyWithImpl<$Res, _$InningModelImpl>
    implements _$$InningModelImplCopyWith<$Res> {
  __$$InningModelImplCopyWithImpl(
      _$InningModelImpl _value, $Res Function(_$InningModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? matchId = freezed,
    Object? batTeamName = freezed,
    Object? bowlTeamName = freezed,
    Object? totalRun = freezed,
    Object? totalWicket = freezed,
    Object? totalBall = freezed,
    Object? battingLineup = freezed,
    Object? bowlingLineup = freezed,
    Object? extraRun = freezed,
    Object? currentBowler = freezed,
    Object? currentStriker = freezed,
    Object? currentNonStriker = freezed,
    Object? overs = freezed,
    Object? currentOver = freezed,
    Object? partnerShips = freezed,
    Object? currentPartnerShip = freezed,
    Object? isFirstInning = freezed,
    Object? fallOfWicket = freezed,
  }) {
    return _then(_$InningModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      matchId: freezed == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String?,
      batTeamName: freezed == batTeamName
          ? _value.batTeamName
          : batTeamName // ignore: cast_nullable_to_non_nullable
              as String?,
      bowlTeamName: freezed == bowlTeamName
          ? _value.bowlTeamName
          : bowlTeamName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalRun: freezed == totalRun
          ? _value.totalRun
          : totalRun // ignore: cast_nullable_to_non_nullable
              as int?,
      totalWicket: freezed == totalWicket
          ? _value.totalWicket
          : totalWicket // ignore: cast_nullable_to_non_nullable
              as int?,
      totalBall: freezed == totalBall
          ? _value.totalBall
          : totalBall // ignore: cast_nullable_to_non_nullable
              as int?,
      battingLineup: freezed == battingLineup
          ? _value.battingLineup
          : battingLineup // ignore: cast_nullable_to_non_nullable
              as List<BattingLineUpModel>?,
      bowlingLineup: freezed == bowlingLineup
          ? _value.bowlingLineup
          : bowlingLineup // ignore: cast_nullable_to_non_nullable
              as List<BowlingLineUpModel>?,
      extraRun: freezed == extraRun
          ? _value.extraRun
          : extraRun // ignore: cast_nullable_to_non_nullable
              as ExtraRunModel?,
      currentBowler: freezed == currentBowler
          ? _value.currentBowler
          : currentBowler // ignore: cast_nullable_to_non_nullable
              as BowlingLineUpModel?,
      currentStriker: freezed == currentStriker
          ? _value.currentStriker
          : currentStriker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
      currentNonStriker: freezed == currentNonStriker
          ? _value.currentNonStriker
          : currentNonStriker // ignore: cast_nullable_to_non_nullable
              as BattingLineUpModel?,
      overs: freezed == overs
          ? _value.overs
          : overs // ignore: cast_nullable_to_non_nullable
              as List<List<String>>?,
      currentOver: freezed == currentOver
          ? _value.currentOver
          : currentOver // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      partnerShips: freezed == partnerShips
          ? _value.partnerShips
          : partnerShips // ignore: cast_nullable_to_non_nullable
              as List<PartnerShipModel>?,
      currentPartnerShip: freezed == currentPartnerShip
          ? _value.currentPartnerShip
          : currentPartnerShip // ignore: cast_nullable_to_non_nullable
              as PartnerShipModel?,
      isFirstInning: freezed == isFirstInning
          ? _value.isFirstInning
          : isFirstInning // ignore: cast_nullable_to_non_nullable
              as bool?,
      fallOfWicket: freezed == fallOfWicket
          ? _value.fallOfWicket
          : fallOfWicket // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 3, adapterName: 'InningModelAdapter')
class _$InningModelImpl extends _InningModel {
  _$InningModelImpl(
      {@HiveField(0) this.id,
      @HiveField(1) this.matchId,
      @HiveField(2) this.batTeamName,
      @HiveField(3) this.bowlTeamName,
      @HiveField(4) this.totalRun,
      @HiveField(5) this.totalWicket,
      @HiveField(6) this.totalBall,
      @HiveField(7) this.battingLineup,
      @HiveField(8) this.bowlingLineup,
      @HiveField(9) this.extraRun,
      @HiveField(10) this.currentBowler,
      @HiveField(11) this.currentStriker,
      @HiveField(12) this.currentNonStriker,
      @HiveField(13) this.overs,
      @HiveField(14) this.currentOver,
      @HiveField(15) this.partnerShips,
      @HiveField(16) this.currentPartnerShip,
      @HiveField(17) this.isFirstInning,
      @HiveField(18) this.fallOfWicket})
      : super._();

  factory _$InningModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InningModelImplFromJson(json);

  @override
  @HiveField(0)
  String? id;
  @override
  @HiveField(1)
  String? matchId;
  @override
  @HiveField(2)
  String? batTeamName;
  @override
  @HiveField(3)
  String? bowlTeamName;
  @override
  @HiveField(4)
  int? totalRun;
  @override
  @HiveField(5)
  int? totalWicket;
  @override
  @HiveField(6)
  int? totalBall;
  @override
  @HiveField(7)
  List<BattingLineUpModel>? battingLineup;
  @override
  @HiveField(8)
  List<BowlingLineUpModel>? bowlingLineup;
  @override
  @HiveField(9)
  ExtraRunModel? extraRun;
  @override
  @HiveField(10)
  BowlingLineUpModel? currentBowler;
  @override
  @HiveField(11)
  BattingLineUpModel? currentStriker;
  @override
  @HiveField(12)
  BattingLineUpModel? currentNonStriker;
  @override
  @HiveField(13)
  List<List<String>>? overs;
  @override
  @HiveField(14)
  List<String>? currentOver;
  @override
  @HiveField(15)
  List<PartnerShipModel>? partnerShips;
  @override
  @HiveField(16)
  PartnerShipModel? currentPartnerShip;
  @override
  @HiveField(17)
  bool? isFirstInning;
  @override
  @HiveField(18)
  List<Map<String, String>>? fallOfWicket;

  @override
  String toString() {
    return 'InningModel(id: $id, matchId: $matchId, batTeamName: $batTeamName, bowlTeamName: $bowlTeamName, totalRun: $totalRun, totalWicket: $totalWicket, totalBall: $totalBall, battingLineup: $battingLineup, bowlingLineup: $bowlingLineup, extraRun: $extraRun, currentBowler: $currentBowler, currentStriker: $currentStriker, currentNonStriker: $currentNonStriker, overs: $overs, currentOver: $currentOver, partnerShips: $partnerShips, currentPartnerShip: $currentPartnerShip, isFirstInning: $isFirstInning, fallOfWicket: $fallOfWicket)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InningModelImplCopyWith<_$InningModelImpl> get copyWith =>
      __$$InningModelImplCopyWithImpl<_$InningModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InningModelImplToJson(
      this,
    );
  }
}

abstract class _InningModel extends InningModel {
  factory _InningModel(
          {@HiveField(0) String? id,
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
          @HiveField(18) List<Map<String, String>>? fallOfWicket}) =
      _$InningModelImpl;
  _InningModel._() : super._();

  factory _InningModel.fromJson(Map<String, dynamic> json) =
      _$InningModelImpl.fromJson;

  @override
  @HiveField(0)
  String? get id;
  @HiveField(0)
  set id(String? value);
  @override
  @HiveField(1)
  String? get matchId;
  @HiveField(1)
  set matchId(String? value);
  @override
  @HiveField(2)
  String? get batTeamName;
  @HiveField(2)
  set batTeamName(String? value);
  @override
  @HiveField(3)
  String? get bowlTeamName;
  @HiveField(3)
  set bowlTeamName(String? value);
  @override
  @HiveField(4)
  int? get totalRun;
  @HiveField(4)
  set totalRun(int? value);
  @override
  @HiveField(5)
  int? get totalWicket;
  @HiveField(5)
  set totalWicket(int? value);
  @override
  @HiveField(6)
  int? get totalBall;
  @HiveField(6)
  set totalBall(int? value);
  @override
  @HiveField(7)
  List<BattingLineUpModel>? get battingLineup;
  @HiveField(7)
  set battingLineup(List<BattingLineUpModel>? value);
  @override
  @HiveField(8)
  List<BowlingLineUpModel>? get bowlingLineup;
  @HiveField(8)
  set bowlingLineup(List<BowlingLineUpModel>? value);
  @override
  @HiveField(9)
  ExtraRunModel? get extraRun;
  @HiveField(9)
  set extraRun(ExtraRunModel? value);
  @override
  @HiveField(10)
  BowlingLineUpModel? get currentBowler;
  @HiveField(10)
  set currentBowler(BowlingLineUpModel? value);
  @override
  @HiveField(11)
  BattingLineUpModel? get currentStriker;
  @HiveField(11)
  set currentStriker(BattingLineUpModel? value);
  @override
  @HiveField(12)
  BattingLineUpModel? get currentNonStriker;
  @HiveField(12)
  set currentNonStriker(BattingLineUpModel? value);
  @override
  @HiveField(13)
  List<List<String>>? get overs;
  @HiveField(13)
  set overs(List<List<String>>? value);
  @override
  @HiveField(14)
  List<String>? get currentOver;
  @HiveField(14)
  set currentOver(List<String>? value);
  @override
  @HiveField(15)
  List<PartnerShipModel>? get partnerShips;
  @HiveField(15)
  set partnerShips(List<PartnerShipModel>? value);
  @override
  @HiveField(16)
  PartnerShipModel? get currentPartnerShip;
  @HiveField(16)
  set currentPartnerShip(PartnerShipModel? value);
  @override
  @HiveField(17)
  bool? get isFirstInning;
  @HiveField(17)
  set isFirstInning(bool? value);
  @override
  @HiveField(18)
  List<Map<String, String>>? get fallOfWicket;
  @HiveField(18)
  set fallOfWicket(List<Map<String, String>>? value);
  @override
  @JsonKey(ignore: true)
  _$$InningModelImplCopyWith<_$InningModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
