// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_card.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_modal.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:cric_spot/ui/score/widgets/player_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class ScoreCountPage extends StatefulWidget {
  final String matchId;
  const ScoreCountPage({super.key, required this.matchId});

  @override
  State<ScoreCountPage> createState() => _ScoreCountPageState();
}

class _ScoreCountPageState extends State<ScoreCountPage> {
  final ScoreStore scoreStore = getIt.get<ScoreStore>();
  final HomeStore homeStore = getIt.get<HomeStore>();
  GlobalKey extraCheckKey = GlobalKey();
  double extraBoxHeight = 100;
  double extraBoxWidth = 80;

  @override
  void initState() {
    super.initState();
    scoreStore.getAllData(widget.matchId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox extraBox =
          extraCheckKey.currentContext!.findRenderObject() as RenderBox;
      extraBoxHeight = extraBox.size.height;
      extraBoxWidth = extraBox.size.width;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print(scoreStore.matchData);
    return Observer(builder: (_) {
      return scoreStore.isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : WillPopScope(
              onWillPop: () async {
                scoreStore.lastSave();
                scoreStore.lastSavePartnership();
                scoreStore.saveData();
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                      '${scoreStore.matchData?.firstBatTeamName} vs ${scoreStore.matchData?.secondBatTeamName}'),
                  leading: IconButton(
                      onPressed: () {
                        scoreStore.lastSave();
                        scoreStore.lastSavePartnership();
                        scoreStore.saveData();
                        GoRouter.of(context).go(RoutesName.landing.path);
                      },
                      icon: Icon(Icons.arrow_back)),
                  actions: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(
                              RoutesName.scoreBoard.name,
                              pathParameters: {"matchId": widget.matchId});
                        },
                        icon: Icon(Icons.scoreboard)),
                    SizedBox(
                      width: 8,
                    )
                  ],
                ),
                body: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: ListView(
                    children: [
                      // 1 : main score card
                      CricCard(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                            "${scoreStore.currentInning?.batTeamName}, ${scoreStore.currentInning!.isFirstInning! ? '1st' : '2nd'} Inning")),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: scoreStore
                                                .currentInning!.isFirstInning!
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Crr"),
                                          Observer(builder: (_) {
                                            return scoreStore.currentInning!
                                                    .isFirstInning!
                                                ? SizedBox.shrink()
                                                : Text("Target");
                                          }),
                                          Observer(builder: (_) {
                                            return scoreStore.currentInning!
                                                    .isFirstInning!
                                                ? SizedBox.shrink()
                                                : Text("RR");
                                          }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Observer(builder: (_) {
                                          return Text(
                                            // "${scoreStore.currentInning?.totalRun} - ${scoreStore.currentInning?.totalWicket}",
                                            "${scoreStore.totalRun} - ${scoreStore.totalWicket}",
                                            style: context.headlineLarge
                                                ?.copyWith(
                                                    color: context
                                                        .onPrimaryContainer),
                                          );
                                        }),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          children: [
                                            Observer(builder: (_) {
                                              return Text(
                                                // "(${scoreStore.currentInning!.totalBall! ~/ 6}.${scoreStore.currentInning!.totalBall! % 6})",
                                                "(${scoreStore.totalBall ~/ 6}.${scoreStore.totalBall % 6})",
                                                style: context.headlineSmall
                                                    ?.copyWith(
                                                        color: context
                                                            .onSurfaceVariant),
                                              );
                                            }),
                                            const SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: scoreStore
                                                .currentInning!.isFirstInning!
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceAround,
                                        children: [
                                          Text((scoreStore.totalRun /
                                                  (scoreStore.totalBall / 6))
                                              .toStringAsFixed(2)),
                                          Observer(builder: (_) {
                                            return scoreStore.currentInning!
                                                    .isFirstInning!
                                                ? SizedBox.shrink()
                                                : Text(scoreStore.target
                                                    .toString());
                                          }),
                                          Observer(builder: (_) {
                                            return scoreStore.currentInning!
                                                    .isFirstInning!
                                                ? SizedBox.shrink()
                                                : Text(((scoreStore.target -
                                                            scoreStore
                                                                .totalRun) /
                                                        (((int.parse(scoreStore
                                                                        .matchData!
                                                                        .over!) *
                                                                    6) -
                                                                scoreStore
                                                                    .totalBall) /
                                                            6))
                                                    .toStringAsFixed(2));
                                          }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                scoreStore.currentInning!.isFirstInning!
                                    ? SizedBox.shrink()
                                    : Text(
                                        "${scoreStore.matchData?.secondBatTeamName} need ${scoreStore.target - scoreStore.totalRun} runs in ${(int.parse(scoreStore.matchData!.over!) * 6) - scoreStore.totalBall} balls",
                                        style: context.bodyLarge?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500),
                                      )
                              ],
                            ),
                          )),
                      // 2 : batsman score card

                      CricCard(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                batsmanScoreWidget(context: context),
                                Divider(),
                                Observer(builder: (_) {
                                  return batsmanScoreWidget(
                                      context: context,
                                      batsmanName: scoreStore.striker?.name,
                                      run: scoreStore.striker?.run,
                                      ball: scoreStore.striker?.ball,
                                      four: scoreStore.striker?.four,
                                      six: scoreStore.striker?.six);
                                }),
                                SizedBox(
                                  height: 6,
                                ),
                                Observer(builder: (_) {
                                  return batsmanScoreWidget(
                                      context: context,
                                      batsmanName: scoreStore.nonStriker?.name,
                                      run: scoreStore.nonStriker?.run,
                                      ball: scoreStore.nonStriker?.ball,
                                      four: scoreStore.nonStriker?.four,
                                      six: scoreStore.nonStriker?.six);
                                }),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
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
                                Divider(),
                                Observer(builder: (_) {
                                  return bowlerScoreWidget(
                                      context: context,
                                      ball: scoreStore.bowler?.ball,
                                      maidan: scoreStore.bowler?.maidan,
                                      run: scoreStore.bowler?.run,
                                      wicket: scoreStore.bowler?.wicket,
                                      bowlerName: scoreStore.bowler?.name);
                                }),
                              ],
                            ),
                          )),
                      // 3 : current over
                      CricCard(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("This Over: "),
                                Expanded(
                                  child: SizedBox(
                                    height: 63,
                                    child: Observer(builder: (_) {
                                      return ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          ...scoreStore.currentOver
                                              .map(((e) =>
                                                  overCircleCard(rundata: e)))
                                              .toList()
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          )),
// new widgets
                      Row(
                        children: [
                          CricCard(
                              key: extraCheckKey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                padding: EdgeInsets.only(right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    scoreStore.matchData!.isWideBall!
                                        ? checkBoxWidget(
                                            childText: "Wide",
                                            value: scoreStore.wide)
                                        : SizedBox.shrink(),
                                    scoreStore.matchData!.isNoball!
                                        ? checkBoxWidget(
                                            childText: "No Ball",
                                            value: scoreStore.noBall)
                                        : SizedBox.shrink(),
                                    checkBoxWidget(
                                        childText: "Byes",
                                        value: scoreStore.byes),
                                    checkBoxWidget(
                                        childText: "Leg Byes",
                                        value: scoreStore.legByes),
                                    checkBoxWidget(
                                        childText: "Wicket",
                                        value: scoreStore.wicket),
                                  ],
                                ),
                              )),
                          CricCard(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: SizedBox(
                                height: extraBoxHeight - 8,
                                width: MediaQuery.of(context).size.width -
                                    extraBoxWidth -
                                    24,
                                child: GridView.count(
                                    childAspectRatio: 1.40,
                                    crossAxisCount: 3,
                                    children: [
                                      countRunCard(
                                          child: "0",
                                          onTap: () {
                                            runCount(0);
                                          }),
                                      countRunCard(
                                          child: "1",
                                          onTap: () {
                                            runCount(1);
                                          }),
                                      countRunCard(
                                          child: "2",
                                          onTap: () {
                                            runCount(2);
                                          }),
                                      countRunCard(
                                          child: "3",
                                          onTap: () {
                                            runCount(3);
                                          }),
                                      countRunCard(
                                          child: "4",
                                          onTap: () {
                                            runCount(4);
                                          }),
                                      countRunCard(
                                          child: "5",
                                          onTap: () {
                                            runCount(5);
                                          }),
                                      countRunCard(
                                          child: "6",
                                          onTap: () {
                                            runCount(6);
                                          }),
                                      countRunCard(child: "...", onTap: () {}),
                                      InkWell(
                                        onTap: () {
                                          final runsDetail = scoreStore
                                              .currentOver.last
                                              .split('-');
                                          cricAlertDialog(context,
                                              child: Text("You want to undo"),
                                              title: Text("Are you sure?"),
                                              confirmationButton: TextButton(
                                                  onPressed: () {
                                                    scoreStore.undoRun(
                                                        runsDetail[1],
                                                        int.parse(
                                                            runsDetail[0]));
                                                    GoRouter.of(context).pop();
                                                  },
                                                  child: Text("Undo")));
                                        },
                                        child: CricOutlineCard(
                                            color: context.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                width: 1,
                                                color: context.outline,
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "undo",
                                              style: TextStyle(
                                                  color: context.onPrimary),
                                            ))),
                                      )
                                    ]),
                              )),
                        ],
                      ),
                      // 4 : extra
                      // CricCard(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8)),
                      //     child: Container(
                      //       padding: EdgeInsets.all(8),
                      //       child: Column(
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               scoreStore.matchData!.isWideBall!
                      //                   ? checkBoxWidget(
                      //                       childText: "Wide",
                      //                       value: scoreStore.wide)
                      //                   : SizedBox.shrink(),
                      //               scoreStore.matchData!.isNoball!
                      //                   ? checkBoxWidget(
                      //                       childText: "No Ball",
                      //                       value: scoreStore.noBall)
                      //                   : SizedBox.shrink(),
                      //               checkBoxWidget(
                      //                   childText: "Byes",
                      //                   value: scoreStore.byes),
                      //               checkBoxWidget(
                      //                   childText: "Leg Byes",
                      //                   value: scoreStore.legByes),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               checkBoxWidget(
                      //                   childText: "Wicket",
                      //                   value: scoreStore.wicket),
                      //               Row(
                      //                 children: [
                      //                   cricFilledButton(
                      //                       childText: "Retire", width: 120),
                      //                   const SizedBox(
                      //                     width: 4,
                      //                   ),
                      //                   cricFilledButton(
                      //                       childText: "Swap Batsman",
                      //                       width: 120),
                      //                 ],
                      //               )
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //     )),
                      // 5 : run count
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: CricCard(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      cricFilledButton(
                                        childText: "Partnerships",
                                        onTap: () {
                                          scoreStore.lastSavePartnership();
                                          cricBottomSheet(
                                              context,
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                width: double.infinity,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    ...scoreStore.currentInning!
                                                        .partnerShips!.reversed
                                                        .map((part) {
                                                      return playerPartnershipWidget(
                                                          context, part);
                                                    }).toList(),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      cricFilledButton(
                                        childText: "Extra",
                                        onTap: () {
                                          cricBottomSheet(
                                              context,
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        scoreStore
                                                            .extraRun!.total
                                                            .toString(),
                                                        style: context
                                                            .headlineLarge
                                                            ?.copyWith(
                                                                color: context
                                                                    .onPrimaryContainer)),
                                                    Text(
                                                        "${scoreStore.extraRun!.by} B, ${scoreStore.extraRun!.legBy} LB, ${scoreStore.extraRun!.wide} WD, ${scoreStore.extraRun!.noBall} NB, ${scoreStore.extraRun!.penlaty} P",
                                                        style: context
                                                            .headlineSmall
                                                            ?.copyWith(
                                                                color: context
                                                                    .onSurfaceVariant)),
                                                  ],
                                                ),
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }

  void wonNavigate() {
    scoreStore.wonMatch();
    GoRouter.of(context).go(RoutesName.winningPage.path);
  }

  void inningDialog(BuildContext context) {
    cricAlertDialog(context,
        title: const Text("End of the first inning."),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "${scoreStore.currentInning!.bowlTeamName} Need ${scoreStore.totalRun + 1} Runs in ${scoreStore.matchData!.over} overs."),
            Text(
                "Require runrate: ${((scoreStore.totalRun + 1) / int.parse(scoreStore.matchData!.over!)).toStringAsFixed(2)}")
          ],
        ),
        confirmationButton: TextButton(
            onPressed: () {
              homeStore.isMatchNew = false;
              GoRouter.of(context).push(RoutesName.playerSelect.path);
              GoRouter.of(context).pop();
            },
            child: const Text('Okay')));
  }

  void runCount(int run) {
    if (scoreStore.totalBall < (int.parse(scoreStore.matchData!.over!) * 6) &&
        scoreStore.totalWicket <
            (int.parse(scoreStore.matchData!.playerPerMatch ?? "11") - 1)) {
      if (scoreStore.overLength < 6) {
        scoreStore.wicket
            ? scoreStore.whoGotOut = scoreStore.striker!.playerId!
            : null;
        scoreStore.wicket
            ? GoRouter.of(context).pushNamed(RoutesName.fallOfWicket.name,
                pathParameters: {"run": "$run"})
            : scoreStore.countRun(run: run);

        if (scoreStore.totalBall ==
                (int.parse(scoreStore.matchData!.over!) * 6) ||
            scoreStore.totalWicket ==
                (int.parse(scoreStore.matchData!.playerPerMatch ?? "11") - 1) ||
            (scoreStore.totalBall <
                    (int.parse(scoreStore.matchData!.over!) * 6) &&
                scoreStore.totalWicket <
                    (int.parse(scoreStore.matchData!.playerPerMatch ?? "11") -
                        1) &&
                !scoreStore.currentInning!.isFirstInning! &&
                scoreStore.totalRun >= scoreStore.target)) {
          scoreStore.currentInning!.isFirstInning!
              ? inningDialog(context)
              : wonNavigate();
        } else {
          if (scoreStore.overLength == 6) {
            GoRouter.of(context).push(RoutesName.selectBowler.path);
          }
        }
      } else {
        GoRouter.of(context).push(RoutesName.selectBowler.path);
      }
    } else {
      scoreStore.currentInning!.isFirstInning!
          ? inningDialog(context)
          : wonNavigate();
    }
  }

  // Widget countRunCard({required String child, required Function() onTap}) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: CricOutlineCard(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(25),
  //           side: BorderSide(
  //             width: 1,
  //             color: context.outline,
  //           ),
  //         ),
  //         child: SizedBox(
  //           width: 50,
  //           height: 50,
  //           child: Center(child: Text(child)),
  //         )),
  //   );
  // }

  Widget countRunCard({required String child, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: CricOutlineCard(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 1,
              color: context.outline,
            ),
          ),
          child: Center(child: Text(child))),
    );
  }

  Widget checkBoxWidget({
    required String childText,
    required bool value,
  }) {
    return InkWell(
      onTap: () {
        switch (childText) {
          case "Wicket":
            scoreStore.changeWicket();
            break;
          case "Wide":
            scoreStore.changeWide();
            break;
          case "No Ball":
            scoreStore.changeNoball();
            break;
          case "Byes":
            scoreStore.changeByes();
            break;
          case "Leg Byes":
            scoreStore.changeLegbyes();
            break;
        }
      },
      child: Row(
        children: [
          SizedBox(
            child: Checkbox(
              value: value,
              onChanged: (val) {
                switch (childText) {
                  case "Wicket":
                    scoreStore.changeWicket();
                    break;
                  case "Wide":
                    scoreStore.changeWide();
                    break;
                  case "No Ball":
                    scoreStore.changeNoball();
                    break;
                  case "Byes":
                    scoreStore.changeByes();
                    break;
                  case "Leg Byes":
                    scoreStore.changeLegbyes();
                    break;
                }
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Text(childText)
        ],
      ),
    );
  }

  Widget cricFilledButton(
      {required String childText, double? width, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
            color: context.primary, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            childText,
            style: TextStyle(color: context.onPrimary),
          ),
        ),
      ),
    );
  }

  Widget overCircleCard({required String rundata}) {
    final run = overText(rundata);
    return Column(
      children: [
        Card(
            color: run[0] == 'OUT'
                ? Colors.red[300]
                : run[0] == '6'
                    ? context.primary
                    : run[0] == '4'
                        ? context.primaryContainer
                        : null,
            elevation: 0,
            margin: EdgeInsets.only(bottom: 0, left: 4, top: 4, right: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                width: 1,
                color: context.outline,
              ),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                  child: Text(
                run[0],
                style: TextStyle(
                    color: run[0] == 'OUT'
                        ? Colors.white
                        : run[0] == '6'
                            ? context.primaryContainer
                            : run[0] == '4'
                                ? context.primary
                                : null),
              )),
            )),
        run[1] == ''
            ? Text('')
            : Text(
                run[1],
                style: context.labelSmall,
              )
      ],
    );
  }

  List<String> overText(String run) {
    final runsDetail = run.split('-');

    switch (runsDetail[1]) {
      case "noramlRun":
        return [runsDetail[0], ''];
      case "wideBall":
        return ['0', "${runsDetail[0]} Wd"];

      case "noBall":
        return ['0', "${runsDetail[0]} Nb"];
      case "byes":
        return ['0', "${runsDetail[0]} B"];

      case "legByes":
        return ['0', "${runsDetail[0]} Lb"];

      case "noBallWithByes":
        return ['0', "${runsDetail[0]} Nb&B"];

      case "noBallWithLegByes":
        return ['0', "${runsDetail[0]} Nb&Lb"];

      case "wideBallWithWicket":
        return ['OUT', "${runsDetail[0]} Wd"];

      case "noBallWithWicket":
        return ['OUT', "${runsDetail[0]} Nb"];

      case "byesWithWicket":
        return ['OUT', "${runsDetail[0]} B"];

      case "legByesWithWicket":
        return ['OUT', "${runsDetail[0]} Lb"];

      case "noBallWithByesWithWicket":
        return ['OUT', "${runsDetail[0]} Nb&B"];

      case "noBallWithLegByesWithWicket":
        return ['OUT', "${runsDetail[0]} Nb&Lb"];

      case "normalWicket":
        return ['OUT', ""];
      default:
        return ['0', ""];
    }
  }
}
