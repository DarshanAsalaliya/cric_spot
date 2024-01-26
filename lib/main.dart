import 'package:cric_spot/app.dart';
import 'package:cric_spot/dependency_injection/dependency_injection.dart';
import 'package:cric_spot/dependency_injection/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configInjector();
  await setupLocator(getIt);
  runApp(const CricSpotApp());
}
