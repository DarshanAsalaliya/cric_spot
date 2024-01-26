import 'package:cric_spot/dependency_injection/module/hive_module.dart';

Future<void> configInjector() async {
  await HiveAdapter().initHive();
}
