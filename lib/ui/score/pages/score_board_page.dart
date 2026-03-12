import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreBoardPage extends StatelessWidget {
  final String matchId;
  const ScoreBoardPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(LoadMatchData(matchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Score card"),
      ),
      body: BlocBuilder<ScoreBloc, ScoreState>(
        builder: (context, state) {
          if (state.matchData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text("${state.matchData!.tossName} won the toss and opted to ${(state.matchData!.tossElect!).toUpperCase()} first"),
                ),
              ),
              InkWell(
                onTap: () {
                  scoreBloc.add(const ToggleScoreBoardOne());
                },
                child: Container(
                  color: context.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.matchData!.firstBatTeamName!,
                        style: context.titleLarge!.copyWith(color: context.background),
                      ),
                      Row(
                        children: [
                          Text(
                            "${state.matchData!.firstBatTeamScore}",
                            style: context.titleLarge!.copyWith(color: context.background),
                          ),
                          Text(
                            " (${state.matchData!.firstBatTeamOver}) ",
                            style: context.titleLarge!.copyWith(color: context.background),
                          ),
                          state.scoreBoardOneIsOpen
                              ? Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: context.background,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: context.background,
                                )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              !state.scoreBoardOneIsOpen
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          color: context.surfaceVariant,
                          child: Row(
                            children: [
                              const Expanded(child: Text("Batsman")),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "R",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "B",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "4s",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "6s",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: const Text(
                                      "SR",
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        ...state.inningOne!.battingLineup!.map((batsman) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(batsman.name!)),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                batsman.run.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                batsman.ball.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                batsman.four.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                batsman.six.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.13,
                                              child: Text(
                                                batsman.ball == 0 ? "0.00" : ((batsman.run! * 100) / (batsman.ball!)).toStringAsFixed(2),
                                                textAlign: TextAlign.end,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      batsman.isNotOut!
                                          ? "Not Out"
                                          : batsman.helpedPlayer == null
                                              ? "${batsman.outType} b ${batsman.outBy} "
                                              : "${batsman.outType} by ${batsman.helpedPlayer} b ${batsman.outBy}",
                                      style: const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 0,
                              )
                            ],
                          );
                        }).toList(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Extras"),
                              Row(
                                children: [
                                  Text(
                                      "${state.inningOne!.extraRun!.total}  ${state.inningOne!.extraRun!.by} B, ${state.inningOne!.extraRun!.legBy} LB, ${state.inningOne!.extraRun!.wide} WD, ${state.inningOne!.extraRun!.noBall} NB, ${state.inningOne!.extraRun!.penlaty} P")
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total"),
                              Row(
                                children: [
                                  Text(state.inningOne!.totalBall == 0
                                      ? "0/0 (0.0)  0.00 "
                                      : "${state.inningOne!.totalRun}  (${state.matchData!.firstBatTeamOver})  ${state.inningOne!.totalRun! / (state.inningOne!.totalBall! / 6)}")
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          color: context.surfaceVariant,
                          child: Row(
                            children: [
                              const Expanded(child: Text("Bowlers")),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "O",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "M",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "R",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.11,
                                    child: const Text(
                                      "W",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: const Text(
                                      "ER",
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        ...state.inningOne!.bowlingLineup!.map((bowler) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(bowler.name!)),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                "${(bowler.ball! ~/ 6)}.${(bowler.ball! % 6)}",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                bowler.maidan.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                bowler.run.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: Text(
                                                bowler.wicket.toString(),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.13,
                                              child: Text(
                                                bowler.ball == 0 ? '0.0' : (bowler.run! / (bowler.ball! / 6)).toStringAsFixed(1),
                                                textAlign: TextAlign.end,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 0,
                              )
                            ],
                          );
                        }).toList(),
                      ],
                    ),

              /// second inning
              state.inningTwo!.bowlingLineup!.isNotEmpty
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () {
                            scoreBloc.add(const ToggleScoreBoardTwo());
                          },
                          child: Container(
                            color: context.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.matchData!.secondBatTeamName!,
                                  style: context.titleLarge!.copyWith(color: context.background),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${state.matchData!.secondBatTeamScore}",
                                      style: context.titleLarge!.copyWith(color: context.background),
                                    ),
                                    Text(
                                      " (${state.matchData!.secondBatTeamOver}) ",
                                      style: context.titleLarge!.copyWith(color: context.background),
                                    ),
                                    state.scoreBoardTwoIsOpen
                                        ? Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            color: context.background,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: context.background,
                                          )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        !state.scoreBoardTwoIsOpen
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                    color: context.surfaceVariant,
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Batsman")),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "R",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "B",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "4s",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "6s",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.13,
                                              child: const Text(
                                                "SR",
                                                textAlign: TextAlign.end,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  ...state.inningTwo!.battingLineup!.map((batsman) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(child: Text(batsman.name!)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          batsman.run.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          batsman.ball.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          batsman.four.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          batsman.six.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.13,
                                                        child: Text(
                                                          batsman.ball == 0 ? "0.00" : ((batsman.run! * 100) / (batsman.ball!)).toStringAsFixed(2),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                batsman.isNotOut!
                                                    ? "Not Out"
                                                    : batsman.helpedPlayer == null
                                                        ? "${batsman.outType} b ${batsman.outBy} "
                                                        : "${batsman.outType} by ${batsman.helpedPlayer} b ${batsman.outBy}",
                                                style: const TextStyle(color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 0,
                                        )
                                      ],
                                    );
                                  }).toList(),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Extras"),
                                        Row(
                                          children: [
                                            Text(
                                                "${state.inningTwo!.extraRun!.total}  ${state.inningTwo!.extraRun!.by} B, ${state.inningTwo!.extraRun!.legBy} LB, ${state.inningTwo!.extraRun!.wide} WD, ${state.inningTwo!.extraRun!.noBall} NB, ${state.inningTwo!.extraRun!.penlaty} P")
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Total"),
                                        Row(
                                          children: [
                                            Text(state.inningTwo!.totalBall == 0
                                                ? "0/0 (0.0)  0.00 "
                                                : "${state.inningTwo!.totalRun}  (${state.matchData!.firstBatTeamOver})  ${(state.inningTwo!.totalRun! / (state.inningTwo!.totalBall! / 6)).toStringAsFixed(2)}")
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                    color: context.surfaceVariant,
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Bowlers")),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "O",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "M",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "R",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.11,
                                              child: const Text(
                                                "W",
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.13,
                                              child: const Text(
                                                "ER",
                                                textAlign: TextAlign.end,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  ...state.inningTwo!.bowlingLineup!.map((bowler) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(child: Text(bowler.name!)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          "${(bowler.ball! ~/ 6)}.${(bowler.ball! % 6)}",
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          bowler.maidan.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          bowler.run.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.11,
                                                        child: Text(
                                                          bowler.wicket.toString(),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.13,
                                                        child: Text(
                                                          bowler.ball == 0 ? '0.0' : (bowler.run! / (bowler.ball! / 6)).toStringAsFixed(1),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 0,
                                        )
                                      ],
                                    );
                                  }).toList(),
                                ],
                              )
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }
}
