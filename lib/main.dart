import 'package:cric_spot/app.dart';
import 'package:cric_spot/dependency_injection/dependency_injection.dart';
import 'package:cric_spot/dependency_injection/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://your-project.supabase.co'),
  //   anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'your-anon-key'),
  // );
  await Supabase.initialize(
    url: 'https://nbrphgckaxlooaqwhydr.supabase.co',
    anonKey: 'sb_publishable_c7U9I8T4mQOP0cPa7FjOvg_M25PemZ0',
  );

  await configInjector();
  await setupLocator(getIt);
  runApp(const CricSpotApp());
}
