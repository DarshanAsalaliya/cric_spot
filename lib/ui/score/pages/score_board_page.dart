import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ScoreBoardPage extends StatelessWidget {
  final String matchId;
  const ScoreBoardPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final scoreStore = getIt.get<ScoreStore>();

    scoreStore.getAllData(matchId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Score card"),
      ),
      body: ListView(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                  "${scoreStore.matchData!.tossName} won the toss and opted to ${(scoreStore.matchData!.tossElect!).toUpperCase()} first"),
            ),
          ),
          InkWell(
            onTap: () {
              scoreStore.scoreBoardOneIsOpen = !scoreStore.scoreBoardOneIsOpen;
            },
            child: Container(
              color: context.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    scoreStore.matchData!.firstBatTeamName!,
                    style:
                        context.titleLarge!.copyWith(color: context.background),
                  ),
                  Row(
                    children: [
                      Text(
                        "${scoreStore.matchData!.firstBatTeamScore}",
                        style: context.titleLarge!
                            .copyWith(color: context.background),
                      ),
                      Text(
                        " (${scoreStore.matchData!.firstBatTeamOver}) ",
                        style: context.titleLarge!
                            .copyWith(color: context.background),
                      ),
                      Observer(builder: (_) {
                        return scoreStore.scoreBoardOneIsOpen
                            ? Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: context.background,
                              )
                            : Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: context.background,
                              );
                      })
                    ],
                  )
                ],
              ),
            ),
          ),
          Observer(builder: (_) {
            return !scoreStore.scoreBoardOneIsOpen
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        color: context.surfaceVariant,
                        child: Row(
                          children: [
                            const Expanded(child: Text("Batsman")),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "R",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "B",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "4s",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "6s",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
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
                      ...scoreStore.inningOne!.battingLineup!.map((batsman) {
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              batsman.run.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              batsman.ball.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              batsman.four.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              batsman.six.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
                                            child: Text(
                                              batsman.ball == 0
                                                  ? "0.00"
                                                  : ((batsman.run! * 100) /
                                                          (batsman.ball!))
                                                      .toStringAsFixed(2),
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
                                        : "${batsman.outType} by ${batsman.outBy}",
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
                                    "${scoreStore.inningOne!.extraRun!.total}  ${scoreStore.inningOne!.extraRun!.by} B, ${scoreStore.inningOne!.extraRun!.legBy} LB, ${scoreStore.inningOne!.extraRun!.wide} WD, ${scoreStore.inningOne!.extraRun!.noBall} NB, ${scoreStore.inningOne!.extraRun!.penlaty} P")
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
                                Text(scoreStore.inningOne!.totalBall == 0
                                    ? "0/0 (0.0)  0.00 "
                                    : "${scoreStore.inningOne!.totalRun}  (${scoreStore.matchData!.firstBatTeamOver})  ${scoreStore.inningOne!.totalRun! / (scoreStore.inningOne!.totalBall! / 6)}")
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        color: context.surfaceVariant,
                        child: Row(
                          children: [
                            const Expanded(child: Text("Bowlers")),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "O",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "M",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "R",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  child: const Text(
                                    "W",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
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
                      ...scoreStore.inningOne!.bowlingLineup!.map((bowler) {
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              "${(bowler.ball! ~/ 6)}.${(bowler.ball! % 6)}",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              bowler.maidan.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              bowler.run.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: Text(
                                              bowler.wicket.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
                                            child: Text(
                                              bowler.ball == 0
                                                  ? '0.0'
                                                  : (bowler.run! /
                                                          (bowler.ball! / 6))
                                                      .toStringAsFixed(1),
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
                  );
          }),

          /// second inning
          scoreStore.inningTwo!.bowlingLineup!.isNotEmpty
              ? Column(
                  children: [
                    InkWell(
                      onTap: () {
                        scoreStore.scoreBoardTwoIsOpen =
                            !scoreStore.scoreBoardTwoIsOpen;
                      },
                      child: Container(
                        color: context.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              scoreStore.matchData!.secondBatTeamName!,
                              style: context.titleLarge!
                                  .copyWith(color: context.background),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${scoreStore.matchData!.secondBatTeamScore}",
                                  style: context.titleLarge!
                                      .copyWith(color: context.background),
                                ),
                                Text(
                                  " (${scoreStore.matchData!.secondBatTeamOver}) ",
                                  style: context.titleLarge!
                                      .copyWith(color: context.background),
                                ),
                                Observer(builder: (_) {
                                  return scoreStore.scoreBoardTwoIsOpen
                                      ? Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          color: context.background,
                                        )
                                      : Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: context.background,
                                        );
                                })
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Observer(builder: (_) {
                      return !scoreStore.scoreBoardTwoIsOpen
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  color: context.surfaceVariant,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text("Batsman")),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "R",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "B",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "4s",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "6s",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
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
                                ...scoreStore.inningTwo!.battingLineup!
                                    .map((batsman) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(batsman.name!)),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        batsman.run.toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        batsman.ball.toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        batsman.four.toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        batsman.six.toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.13,
                                                      child: Text(
                                                        batsman.ball == 0
                                                            ? "0.00"
                                                            : ((batsman.run! *
                                                                        100) /
                                                                    (batsman
                                                                        .ball!))
                                                                .toStringAsFixed(
                                                                    2),
                                                        textAlign:
                                                            TextAlign.end,
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
                                                  : "${batsman.outType} by ${batsman.outBy}",
                                              style: const TextStyle(
                                                  color: Colors.grey),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Extras"),
                                      Row(
                                        children: [
                                          Text(
                                              "${scoreStore.inningTwo!.extraRun!.total}  ${scoreStore.inningTwo!.extraRun!.by} B, ${scoreStore.inningTwo!.extraRun!.legBy} LB, ${scoreStore.inningTwo!.extraRun!.wide} WD, ${scoreStore.inningTwo!.extraRun!.noBall} NB, ${scoreStore.inningTwo!.extraRun!.penlaty} P")
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total"),
                                      Row(
                                        children: [
                                          Text(scoreStore
                                                      .inningTwo!.totalBall ==
                                                  0
                                              ? "0/0 (0.0)  0.00 "
                                              : "${scoreStore.inningTwo!.totalRun}  (${scoreStore.matchData!.firstBatTeamOver})  ${(scoreStore.inningTwo!.totalRun! / (scoreStore.inningTwo!.totalBall! / 6)).toStringAsFixed(2)}")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  color: context.surfaceVariant,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text("Bowlers")),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "O",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "M",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "R",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.11,
                                            child: const Text(
                                              "W",
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
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
                                ...scoreStore.inningTwo!.bowlingLineup!
                                    .map((bowler) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(bowler.name!)),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        "${(bowler.ball! ~/ 6)}.${(bowler.ball! % 6)}",
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        bowler.maidan
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        bowler.run.toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      child: Text(
                                                        bowler.wicket
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.13,
                                                      child: Text(
                                                        bowler.ball == 0
                                                            ? '0.0'
                                                            : (bowler.run! /
                                                                    (bowler.ball! /
                                                                        6))
                                                                .toStringAsFixed(
                                                                    1),
                                                        textAlign:
                                                            TextAlign.end,
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
                            );
                    })
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
