import 'package:cric_spot/bloc/auth/auth_cubit.dart';
import 'package:cric_spot/bloc/sync/sync_cubit.dart';
import 'package:cric_spot/bloc/home/home_cubit.dart';
import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:cric_spot/bloc/team/team_cubit.dart';
import 'package:cric_spot/core/enum/box_type.dart';
import 'package:cric_spot/model/inning/inning_model.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/model/player/player_model.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:cric_spot/service/supabase_sync_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

Future<void> setupLocator(GetIt getIt) async {
  // register box
  getIt.registerSingletonAsync<Box<TeamModel>>(
      () => Hive.openBox<TeamModel>(BoxType.team.name),
      instanceName: BoxType.team.name);
  getIt.registerSingletonAsync<Box<PlayerModel>>(
      () => Hive.openBox<PlayerModel>(BoxType.player.name),
      instanceName: BoxType.player.name);
  getIt.registerSingletonAsync<Box<MatchModel>>(
      () => Hive.openBox<MatchModel>(BoxType.match.name),
      instanceName: BoxType.match.name);
  getIt.registerSingletonAsync<Box<InningModel>>(
      () => Hive.openBox<InningModel>(BoxType.inning.name),
      instanceName: BoxType.inning.name);

  // sync queue box
  final syncQueueBox = await Hive.openBox<Map>(BoxType.syncQueue.name);

  // services
  getIt.registerSingleton(SupabaseSyncService());

  // bloc/cubit register
  getIt.registerSingleton(AuthCubit());
  getIt.registerSingleton(SyncCubit(
    syncService: getIt.get<SupabaseSyncService>(),
    syncQueueBox: syncQueueBox,
  ));
  getIt.registerSingleton(HomeCubit());
  getIt.registerSingleton(TeamCubit(
      await getIt.getAsync<Box<TeamModel>>(instanceName: BoxType.team.name)));
  getIt.registerSingleton(MatchSetupBloc(
      playerBox: await getIt.getAsync<Box<PlayerModel>>(
          instanceName: BoxType.player.name),
      teamBox: await getIt.getAsync<Box<TeamModel>>(
          instanceName: BoxType.team.name),
      matchBox: await getIt.getAsync<Box<MatchModel>>(
          instanceName: BoxType.match.name),
      inningBox: await getIt.getAsync<Box<InningModel>>(
          instanceName: BoxType.inning.name)));
  getIt.registerSingleton(ScoreBloc(
      playerBox: await getIt.getAsync<Box<PlayerModel>>(
          instanceName: BoxType.player.name),
      teamBox: await getIt.getAsync<Box<TeamModel>>(
          instanceName: BoxType.team.name),
      matchBox: await getIt.getAsync<Box<MatchModel>>(
          instanceName: BoxType.match.name),
      inningBox: await getIt.getAsync<Box<InningModel>>(
          instanceName: BoxType.inning.name)));
}
