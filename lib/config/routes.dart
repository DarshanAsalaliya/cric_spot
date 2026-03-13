import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/ui/auth/pages/login_page.dart';
import 'package:cric_spot/ui/auth/pages/otp_verification_page.dart';
import 'package:cric_spot/ui/auth/pages/signup_page.dart';
import 'package:cric_spot/ui/profile/pages/user_profile_page.dart';
import 'package:cric_spot/ui/live/pages/join_live_page.dart';
import 'package:cric_spot/ui/live/pages/live_score_page.dart';
import 'package:cric_spot/ui/profile/pages/player_profile_page.dart';
import 'package:cric_spot/ui/tournament/pages/create_tournament_page.dart';
import 'package:cric_spot/ui/tournament/pages/tournament_detail_page.dart';
import 'package:cric_spot/ui/tournament/pages/tournament_list_page.dart';
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
      GoRoute(
          path: RoutesName.login.path,
          name: RoutesName.login.name,
          builder: (context, state) => const LoginPage()),
      GoRoute(
          path: RoutesName.signup.path,
          name: RoutesName.signup.name,
          builder: (context, state) => const SignupPage()),
      GoRoute(
          path: RoutesName.joinLive.path,
          name: RoutesName.joinLive.name,
          builder: (context, state) => const JoinLivePage()),
      GoRoute(
          path: RoutesName.liveScore.path,
          name: RoutesName.liveScore.name,
          builder: (context, state) => LiveScorePage(
                matchId: state.pathParameters['matchId']!,
              )),
      GoRoute(
          path: RoutesName.playerProfile.path,
          name: RoutesName.playerProfile.name,
          builder: (context, state) => PlayerProfilePage(
                playerId: state.pathParameters['playerId']!,
                playerName: state.uri.queryParameters['name'],
              )),
      GoRoute(
          path: RoutesName.tournamentList.path,
          name: RoutesName.tournamentList.name,
          builder: (context, state) => const TournamentListPage()),
      GoRoute(
          path: RoutesName.createTournament.path,
          name: RoutesName.createTournament.name,
          builder: (context, state) => const CreateTournamentPage()),
      GoRoute(
          path: RoutesName.tournamentDetail.path,
          name: RoutesName.tournamentDetail.name,
          builder: (context, state) => TournamentDetailPage(
                tournamentId: state.pathParameters['tournamentId']!,
              )),
      GoRoute(
          path: RoutesName.otpVerification.path,
          name: RoutesName.otpVerification.name,
          builder: (context, state) => OtpVerificationPage(
                email: Uri.decodeComponent(state.pathParameters['email'] ?? ''),
              )),
      GoRoute(
          path: RoutesName.userProfile.path,
          name: RoutesName.userProfile.name,
          builder: (context, state) => const UserProfilePage()),
    ]);
