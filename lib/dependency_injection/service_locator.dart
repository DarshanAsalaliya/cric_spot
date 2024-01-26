import 'package:cric_spot/core/enum/box_type.dart';
import 'package:cric_spot/model/inning/inning_model.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/model/player/player_model.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:cric_spot/store/team/team_store.dart';
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

  // store register
  getIt.registerSingleton(TeamStore(
      await getIt.getAsync<Box<TeamModel>>(instanceName: BoxType.team.name)));
  getIt.registerSingleton(HomeStore(
      await getIt.getAsync<Box<PlayerModel>>(instanceName: BoxType.player.name),
      await getIt.getAsync<Box<TeamModel>>(instanceName: BoxType.team.name),
      await getIt.getAsync<Box<MatchModel>>(instanceName: BoxType.match.name),
      await getIt.getAsync<Box<InningModel>>(
          instanceName: BoxType.inning.name)));
  getIt.registerSingleton(ScoreStore(
      await getIt.getAsync<Box<PlayerModel>>(instanceName: BoxType.player.name),
      await getIt.getAsync<Box<TeamModel>>(instanceName: BoxType.team.name),
      await getIt.getAsync<Box<MatchModel>>(instanceName: BoxType.match.name),
      await getIt.getAsync<Box<InningModel>>(
          instanceName: BoxType.inning.name)));
}
