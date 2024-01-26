import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class PlayerSelectPage extends StatelessWidget {
  const PlayerSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeStore = getIt.get<HomeStore>();
    final scoreStore = getIt.get<ScoreStore>();

    TextEditingController strikerController = TextEditingController();
    TextEditingController nonStrikerController = TextEditingController();
    TextEditingController bowlerController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select opening players'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Striker",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: strikerController,
              hintText: "Player name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (val) {
                homeStore.strikerName = val;
                homeStore.strikerNameError = null;
                // homeStore.hostTeamNameChange(val);
              },
            ),
            Observer(builder: (_) {
              return homeStore.strikerNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          homeStore.strikerNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Non-Striker",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: nonStrikerController,
              hintText: "Player name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (val) {
                homeStore.nonStrikerName = val;
                homeStore.nonStrikerNameError = null;
                // homeStore.visitorTeamNameChange(val);
              },
            ),
            Observer(builder: (_) {
              return homeStore.nonStrikerNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          homeStore.nonStrikerNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Opening Bowler",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: bowlerController,
              hintText: "Player name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (val) {
                homeStore.openingBowlerName = val;
                homeStore.openingBowlerNameError = null;
                // homeStore.visitorTeamNameChange(val);
              },
            ),
            Observer(builder: (_) {
              return homeStore.openingBowlerNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          homeStore.openingBowlerNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
                onPressed: () async {
                  homeStore.validateSelectOpener();
                  if (homeStore.canSelectOpeningPlayer) {
                    if (homeStore.isMatchNew) {
                      final matchId = await homeStore.createNewMatch();
                      if (!context.mounted) return;
                      GoRouter.of(context).pop();
                      GoRouter.of(context).pushNamed(RoutesName.scoreCount.name,
                          pathParameters: {'matchId': matchId.toString()});
                    } else {
                      scoreStore.changeInning(
                          strikerName: homeStore.strikerName,
                          nonStrikerName: homeStore.nonStrikerName,
                          bowlerName: homeStore.openingBowlerName);
                      GoRouter.of(context).pop();
                    }
                  }
                },
                child: const Text("Start Match"))
          ],
        ),
      ),
    );
  }
}
