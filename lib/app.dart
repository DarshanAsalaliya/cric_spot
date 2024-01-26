import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/team/team_store.dart';
import 'package:flutter/material.dart';
import 'package:cric_spot/config/routes.dart';
import 'package:cric_spot/core/theme/app_theme.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CricSpotApp extends StatelessWidget {
  const CricSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => getIt.get<HomeStore>()),
          Provider(create: (_) => getIt.get<TeamStore>()),
        ],
        builder: (context, child) {
          return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
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
              theme: appTheme(
                  context,
                  lightColorScheme,
                  fontPreference,
                  lightTextTheme,
                  ThemeData.light().dividerColor,
                  SystemUiOverlayStyle.dark),
              darkTheme: appTheme(
                  context,
                  darkColorScheme,
                  fontPreference,
                  darkTextTheme,
                  ThemeData.dark().dividerColor,
                  SystemUiOverlayStyle.light),
            );
          });
        });
  }
}
