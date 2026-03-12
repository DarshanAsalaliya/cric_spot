import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WinningPage extends StatelessWidget {
  const WinningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreBloc = context.read<ScoreBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go(RoutesName.landing.path);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Congratulations",
              style: context.displaySmall,
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(50),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(color: context.primary, borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 1.5)),
              child: Image.asset(
                "assets/won_trophy.png",
                // color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            (scoreBloc.matchData!.wonName == "tie" || scoreBloc.matchData!.wonName == null)
                ? const SizedBox.shrink()
                : Text(
                    scoreBloc.matchData!.wonName ?? "",
                    style: context.headlineLarge,
                  ),
            const SizedBox(
              height: 16,
            ),
            Text(
              scoreBloc.matchData!.wonName == "tie"
                  ? "Match is Tie"
                  : "${scoreBloc.matchData!.wonName ?? ""} won by ${scoreBloc.matchData!.wonBy ?? ""}",
              style: context.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
