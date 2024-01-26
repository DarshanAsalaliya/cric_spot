import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'extra_run_model.freezed.dart';
part 'extra_run_model.g.dart';

@unfreezed
class ExtraRunModel extends HiveObject with _$ExtraRunModel {
  @HiveType(typeId: 6, adapterName: 'ExtraRunModelAdapter')
  factory ExtraRunModel({
    @HiveField(0) int? wide,
    @HiveField(1) int? noBall,
    @HiveField(2) int? legBy,
    @HiveField(3) int? by,
    @HiveField(4) int? penlaty,
    @HiveField(5) int? total,
  }) = _ExtraRunModel;

  ExtraRunModel._();

  factory ExtraRunModel.fromJson(Map<String, dynamic> json) =>
      _$ExtraRunModelFromJson(json);

  // Map<String, dynamic> toJson() {
  //   return {
  //     'wide': wide,
  //     'noBall': noBall,
  //     'legBy': legBy,
  //     'by': by,
  //     'penlaty': penlaty,
  //     'total': total,
  //   };
  // }
}
