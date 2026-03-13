import 'package:cric_spot/bloc/auth/auth_cubit.dart';
import 'package:cric_spot/bloc/sync/sync_cubit.dart';
import 'package:cric_spot/bloc/home/home_cubit.dart';
import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:cric_spot/bloc/team/team_cubit.dart';
import 'package:cric_spot/main.dart';
import 'package:flutter/material.dart';
import 'package:cric_spot/config/routes.dart';
import 'package:cric_spot/core/theme/app_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CricSpotApp extends StatelessWidget {
  const CricSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt.get<AuthCubit>()),
          BlocProvider.value(value: getIt.get<SyncCubit>()),
          BlocProvider.value(value: getIt.get<HomeCubit>()),
          BlocProvider.value(value: getIt.get<TeamCubit>()),
          BlocProvider.value(value: getIt.get<MatchSetupBloc>()),
          BlocProvider.value(value: getIt.get<ScoreBloc>()),
        ],
        child: DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          // const bool isDynamic = false;
          // final ThemeMode themeMode = ThemeMode.values[0];
          const int color = 0xFF795548;
          const Color primaryColor = Color(color);

          const String fontPreference = 'Outfit';
          final TextTheme darkTextTheme = GoogleFonts.getTextTheme(
            fontPreference,
            ThemeData.dark().textTheme,
          );
          final TextTheme lightTextTheme = GoogleFonts.getTextTheme(
            fontPreference,
            ThemeData.light().textTheme,
          );

          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;
          if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: primaryColor,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: Brightness.dark,
            );
          }

          return MaterialApp.router(
            title: 'Flutter Demo',
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
            theme: appTheme(context, lightColorScheme, fontPreference, lightTextTheme, ThemeData.light().dividerColor,
                ThemeData.light().dialogTheme, SystemUiOverlayStyle.dark),
            darkTheme: appTheme(context, darkColorScheme, fontPreference, darkTextTheme, ThemeData.dark().dividerColor,
                ThemeData.dark().dialogTheme, SystemUiOverlayStyle.light),
          );
        }));
  }
}
