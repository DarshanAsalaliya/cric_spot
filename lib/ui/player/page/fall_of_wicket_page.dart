import 'dart:developer';

import 'package:cric_spot/core/enum/wicket_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class FallOfWicketPage extends StatelessWidget {
  final String run;
  const FallOfWicketPage({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final scoreStore = getIt.get<ScoreStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fall of wicket"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "How Wicket Fall?",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.onSecondaryContainer),
                color: context.surfaceVariant,
              ),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: Observer(builder: (_) {
                  return DropdownButton(
                    borderRadius: BorderRadius.circular(12.0),
                    onChanged: (val) {
                      scoreStore.wicketType = val!;
                    },
                    value: scoreStore.wicketType,
                    items: WicketType.values.map((e) {
                      return DropdownMenuItem<WicketType>(
                        value: e,
                        child: Text(e.name),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
            Observer(builder: (_) {
              log("${scoreStore.whoGotOut} to");

              return (scoreStore.wicketType == WicketType.runoutStriker || scoreStore.wicketType == WicketType.runoutNonStriker)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Who got out?",
                          style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: context.onSecondaryContainer),
                            color: context.surfaceVariant,
                          ),
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: Observer(builder: (_) {
                              return DropdownButton(
                                borderRadius: BorderRadius.circular(12.0),
                                onChanged: (val) {
                                  scoreStore.whoGotOut = val!;
                                },
                                value: scoreStore.whoGotOut,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: scoreStore.striker!.playerId,
                                    child: Text(scoreStore.striker!.name!),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: scoreStore.nonStriker!.playerId,
                                    child: Text(scoreStore.nonStriker!.name!),
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            }),
            const SizedBox(
              height: 16,
            ),
            Text(
              "New Batsman",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 8,
            ),
            scoreStore.totalWicket == (int.parse(scoreStore.matchData!.playerPerMatch!) - 2)
                ? const SizedBox.shrink()
                : CricTextFormField(
                    // controller: strikerController,
                    hintText: "Player name",
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      scoreStore.newBatsman = val;
                    },
                  ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: Observer(builder: (_) {
                return FilledButton(
                    onPressed: scoreStore.newBatsman == ''
                        ? null
                        : () async {
                            final newPlayer = await scoreStore.fallOfWicket();

                            scoreStore.countRun(run: int.parse(run), newPlayer: newPlayer);
                            if (!context.mounted) return;
                            GoRouter.of(context).pop();
                          },
                    child: const Text("Done"));
              }),
            )
          ],
        ),
      ),
    );
  }
}
