import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/ui/home/pages/home/home_page.dart';
import 'package:cric_spot/ui/player/page/fall_of_wicket_page.dart';
import 'package:cric_spot/ui/player/page/player_select_page.dart';
import 'package:cric_spot/ui/player/page/select_bowler_page.dart';
import 'package:cric_spot/ui/score/pages/score_board_page.dart';
import 'package:cric_spot/ui/score/pages/score_count_page.dart';
import 'package:cric_spot/ui/score/pages/winning_page.dart';
import 'package:cric_spot/ui/settings/pages/adwance-setting/adwance_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
    initialLocation: RoutesName.landing.path,
    observers: <NavigatorObserver>[
      HeroController()
    ],
    routes: [
      GoRoute(
          path: RoutesName.landing.path,
          name: RoutesName.landing.name,
          builder: (context, state) => const HomePage()),
      GoRoute(
          path: RoutesName.adwanceSetting.path,
          name: RoutesName.adwanceSetting.name,
          builder: (context, state) => const AdwanceSettingPage()),
      GoRoute(
          path: RoutesName.scoreCount.path,
          name: RoutesName.scoreCount.name,
          builder: (context, state) => ScoreCountPage(
                matchId: state.pathParameters['matchId']!,
              )),
      GoRoute(
          path: RoutesName.scoreBoard.path,
          name: RoutesName.scoreBoard.name,
          builder: (context, state) =>
              ScoreBoardPage(matchId: state.pathParameters['matchId']!)),
      GoRoute(
          path: RoutesName.playerSelect.path,
          name: RoutesName.playerSelect.name,
          builder: (context, state) => const PlayerSelectPage()),
      GoRoute(
          path: RoutesName.selectBowler.path,
          name: RoutesName.selectBowler.name,
          builder: (context, state) => const SelectBowlerPage()),
      GoRoute(
          path: RoutesName.fallOfWicket.path,
          name: RoutesName.fallOfWicket.name,
          builder: (context, state) => FallOfWicketPage(
                run: state.pathParameters['run']!,
              )),
      GoRoute(
          path: RoutesName.winningPage.path,
          name: RoutesName.winningPage.name,
          builder: (context, state) => const WinningPage()),
    ]);
