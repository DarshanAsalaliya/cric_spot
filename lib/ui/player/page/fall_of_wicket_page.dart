import 'dart:developer';

import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:cric_spot/config/routes.dart';
import 'package:cric_spot/core/enum/wicket_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FallOfWicketPage extends StatelessWidget {
  final String run;
  const FallOfWicketPage({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final scoreBloc = context.read<ScoreBloc>();
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
                child: BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
                  return DropdownButton(
                    borderRadius: BorderRadius.circular(12.0),
                    onChanged: (val) {
                      scoreBloc.add(WicketTypeChanged(val!));
                      scoreBloc.add(const SupporterPlayerChanged(''));
                    },
                    value: state.wicketType,
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
            BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
              log("${state.whoGotOut} to");

              return (state.wicketType == WicketType.runoutStriker || state.wicketType == WicketType.runoutNonStriker)
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
                            child: BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
                              return DropdownButton(
                                borderRadius: BorderRadius.circular(12.0),
                                onChanged: (val) {
                                  scoreBloc.add(WhoGotOutChanged(val!));
                                },
                                value: state.whoGotOut,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: state.striker!.playerId,
                                    child: Text(state.striker!.name!),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: state.nonStriker!.playerId,
                                    child: Text(state.nonStriker!.name!),
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
            BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
              return (state.wicketType == WicketType.catchOut ||
                      state.wicketType == WicketType.runoutNonStriker ||
                      state.wicketType == WicketType.runoutStriker ||
                      state.wicketType == WicketType.stumpping)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "${state.wicketType.name} by",
                          style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CricTextFormField(
                          // controller: strikerController,
                          hintText: "Player name",
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (val) {
                            scoreBloc.add(SupporterPlayerChanged(val));
                          },
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
            scoreBloc.totalWicket == (int.parse(scoreBloc.matchData!.playerPerMatch!) - 2)
                ? const SizedBox.shrink()
                : CricTextFormField(
                    // controller: strikerController,
                    hintText: "Player name",
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      scoreBloc.add(NewBatsmanNameChanged(val));
                    },
                  ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
                return FilledButton(
                    onPressed: state.newBatsman == ''
                        ? null
                        : () async {
                            final scoreBloc = context.read<ScoreBloc>();
                            // Create new batsman first (async Hive write), then pass to CountRun
                            final newPlayer = await scoreBloc.createNewBatsman();
                            scoreBloc.add(CountRun(run: int.parse(run), newPlayer: newPlayer));
                            scoreBloc.add(const SupporterPlayerChanged(''));
                            goRouter.pop();
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
