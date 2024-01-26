import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WinningPage extends StatelessWidget {
  const WinningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreStore = getIt.get<ScoreStore>();
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
              padding: EdgeInsets.all(50),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  color: context.primary,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width / 1.5)),
              child: Image.network(
                "https://cdn4.iconfinder.com/data/icons/awards-74/64/Trophy-competition-award-cup-winner-512.png",
                // color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            (scoreStore.matchData!.wonName == "tie" ||
                    scoreStore.matchData!.wonName == null)
                ? const SizedBox.shrink()
                : Text(
                    scoreStore.matchData!.wonName ?? "",
                    style: context.headlineLarge,
                  ),
            const SizedBox(
              height: 16,
            ),
            Text(
              scoreStore.matchData!.wonName == "tie"
                  ? "Match is Tie"
                  : "${scoreStore.matchData!.wonName ?? ""} won by ${scoreStore.matchData!.wonBy ?? ""}",
              style: context.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
