// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_card.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_modal.dart';
import 'package:cric_spot/ui/score/widgets/player_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScoreCountPage extends StatefulWidget {
  final String matchId;
  const ScoreCountPage({super.key, required this.matchId});

  @override
  State<ScoreCountPage> createState() => _ScoreCountPageState();
}

class _ScoreCountPageState extends State<ScoreCountPage> {
  GlobalKey extraCheckKey = GlobalKey();
  double extraBoxHeight = 100;
  double extraBoxWidth = 80;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScoreBloc>().add(LoadMatchData(widget.matchId));
      RenderBox extraBox = extraCheckKey.currentContext!.findRenderObject() as RenderBox;
      extraBoxHeight = extraBox.size.height;
      extraBoxWidth = extraBox.size.width;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scoreBloc = context.read<ScoreBloc>();
    print(scoreBloc.matchData);
    return BlocListener<ScoreBloc, ScoreState>(
      listenWhen: (previous, current) =>
          current.navigationAction != ScoreNavigationAction.none && previous.navigationAction != current.navigationAction,
      listener: (context, state) {
        final scoreBloc = context.read<ScoreBloc>();
        final action = state.navigationAction;
        scoreBloc.add(const ClearNavigation());
        switch (action) {
          case ScoreNavigationAction.selectBowler:
            GoRouter.of(context).push(RoutesName.selectBowler.path);
            break;
          case ScoreNavigationAction.inningEnd:
            inningDialog(context);
            break;
          case ScoreNavigationAction.matchWon:
            wonNavigate();
            break;
          case ScoreNavigationAction.none:
            break;
        }
      },
      child: BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
        return (state.isLoad || state.matchData == null)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WillPopScope(
                onWillPop: () async {
                  scoreBloc.add(const SaveBeforeExit());
                  return true;
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('${state.matchData?.firstBatTeamName} vs ${state.matchData?.secondBatTeamName}'),
                    leading: IconButton(
                        onPressed: () {
                          scoreBloc.add(const SaveBeforeExit());
                          GoRouter.of(context).go(RoutesName.landing.path);
                        },
                        icon: Icon(Icons.arrow_back)),
                    actions: [
                      if (scoreBloc.matchData?.shareCode != null)
                        IconButton(
                            onPressed: () {
                              final code = scoreBloc.matchData!.shareCode!;
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Share Code'),
                                  content: SelectableText(
                                    code,
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.share),
                            tooltip: 'Share Live Code',
                        ),
                      IconButton(
                          onPressed: () {
                            GoRouter.of(context).pushNamed(RoutesName.scoreBoard.name, pathParameters: {"matchId": widget.matchId});
                          },
                          icon: Icon(Icons.scoreboard)),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                  body: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ListView(
                      children: [
                        // 1 : main score card
                        CricCard(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              "${state.currentInning?.batTeamName}, ${(state.currentInning?.isFirstInning ?? true) ? '1st' : '2nd'} Inning")),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              state.currentInning!.isFirstInning! ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("Crr"),
                                            state.currentInning!.isFirstInning! ? SizedBox.shrink() : Text("Target"),
                                            state.currentInning!.isFirstInning! ? SizedBox.shrink() : Text("RR"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            // "${state.currentInning?.totalRun} - ${state.currentInning?.totalWicket}",
                                            "${state.totalRun} - ${state.totalWicket}",
                                            style: context.headlineLarge?.copyWith(color: context.onPrimaryContainer),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                // "(${state.currentInning!.totalBall! ~/ 6}.${state.currentInning!.totalBall! % 6})",
                                                "(${state.totalBall ~/ 6}.${state.totalBall % 6})",
                                                style: context.headlineSmall?.copyWith(color: context.onSurfaceVariant),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              state.currentInning!.isFirstInning! ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
                                          children: [
                                            Text((state.totalRun / (state.totalBall / 6)).toStringAsFixed(2)),
                                            state.currentInning!.isFirstInning! ? SizedBox.shrink() : Text(state.target.toString()),
                                            state.currentInning!.isFirstInning!
                                                ? SizedBox.shrink()
                                                : Text(((state.target - state.totalRun) /
                                                        (((int.parse(state.matchData!.over!) * 6) - state.totalBall) / 6))
                                                    .toStringAsFixed(2)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  state.currentInning!.isFirstInning!
                                      ? SizedBox.shrink()
                                      : Text(
                                          "${state.matchData?.secondBatTeamName} need ${state.target - state.totalRun} runs in ${(int.parse(state.matchData!.over!) * 6) - state.totalBall} balls",
                                          style: context.bodyLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.w500),
                                        )
                                ],
                              ),
                            )),
                        // 2 : batsman score card

                        CricCard(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  batsmanScoreWidget(context: context),
                                  Divider(),
                                  batsmanScoreWidget(
                                      context: context,
                                      batsmanName: "${state.striker?.name}*",
                                      run: state.striker?.run,
                                      ball: state.striker?.ball,
                                      four: state.striker?.four,
                                      six: state.striker?.six),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  batsmanScoreWidget(
                                      context: context,
                                      batsmanName: state.nonStriker?.name,
                                      run: state.nonStriker?.run,
                                      ball: state.nonStriker?.ball,
                                      four: state.nonStriker?.four,
                                      six: state.nonStriker?.six),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
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
                                  Divider(),
                                  bowlerScoreWidget(
                                      context: context,
                                      ball: state.bowler?.ball,
                                      maidan: state.bowler?.maidan,
                                      run: state.bowler?.run,
                                      wicket: state.bowler?.wicket,
                                      bowlerName: state.bowler?.name),
                                ],
                              ),
                            )),
                        // 3 : current over
                        CricCard(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("This Over: "),
                                  Expanded(
                                    child: SizedBox(
                                      height: 64,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [...state.currentOver.map(((e) => overCircleCard(rundata: e))).toList()],
                                      ),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      state.matchData!.isWideBall!
                                          ? checkBoxWidget(childText: "Wide", value: state.wide, scoreBloc: scoreBloc)
                                          : SizedBox.shrink(),
                                      state.matchData!.isNoball!
                                          ? checkBoxWidget(childText: "No Ball", value: state.noBall, scoreBloc: scoreBloc)
                                          : SizedBox.shrink(),
                                      checkBoxWidget(childText: "Byes", value: state.byes, scoreBloc: scoreBloc),
                                      checkBoxWidget(childText: "Leg Byes", value: state.legByes, scoreBloc: scoreBloc),
                                      checkBoxWidget(childText: "Wicket", value: state.wicket, scoreBloc: scoreBloc),
                                    ],
                                  ),
                                )),
                            CricCard(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                child: SizedBox(
                                  height: extraBoxHeight - 8,
                                  width: MediaQuery.of(context).size.width - extraBoxWidth - 24,
                                  child: GridView.count(childAspectRatio: 1.40, crossAxisCount: 3, children: [
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
                                        final runsDetail = scoreBloc.currentOver.last.split('-');
                                        cricAlertDialog(context,
                                            child: Text("You want to undo"),
                                            title: Text("Are you sure?"),
                                            confirmationButton: TextButton(
                                                onPressed: () {
                                                  scoreBloc.add(UndoRun(runType: runsDetail[1], run: int.parse(runsDetail[0])));
                                                  GoRouter.of(context).pop();
                                                },
                                                child: Text("Undo")));
                                      },
                                      child: CricOutlineCard(
                                          color: context.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              width: 1,
                                              color: context.outline,
                                            ),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "undo",
                                            style: TextStyle(color: context.onPrimary),
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
                        SizedBox(
                          // width: MediaQuery.of(context).size.width - 16,
                          child: CricCard(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: cricFilledButton(
                                        childText: "Swap",
                                        onTap: () {
                                          scoreBloc.add(const SwapBatsman());
                                          // scoreStore.lastSavePartnership();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: cricFilledButton(
                                        childText: "Partnerships",
                                        onTap: () {
                                          cricBottomSheet(
                                              context,
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                width: double.infinity,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    ...scoreBloc.currentInning!.partnerShips!.reversed.map((part) {
                                                      return playerPartnershipWidget(context, part);
                                                    }).toList(),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: cricFilledButton(
                                        width: double.infinity,
                                        childText: "Extra",
                                        onTap: () {
                                          cricBottomSheet(
                                              context,
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(state.extraRun!.total.toString(),
                                                        style: context.headlineLarge?.copyWith(color: context.onPrimaryContainer)),
                                                    Text(
                                                        "${state.extraRun!.by} B, ${state.extraRun!.legBy} LB, ${state.extraRun!.wide} WD, ${state.extraRun!.noBall} NB, ${state.extraRun!.penlaty} P",
                                                        style: context.headlineSmall?.copyWith(color: context.onSurfaceVariant)),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }

  void wonNavigate() {
    final scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(const WonMatch());
    GoRouter.of(context).go(RoutesName.winningPage.path);
  }

  void inningDialog(BuildContext context) {
    final scoreBloc = context.read<ScoreBloc>();
    final matchSetupBloc = context.read<MatchSetupBloc>();
    cricAlertDialog(context,
        title: const Text("End of the first inning."),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${scoreBloc.currentInning!.bowlTeamName} Need ${scoreBloc.totalRun + 1} Runs in ${scoreBloc.matchData!.over} overs."),
            Text("Require runrate: ${((scoreBloc.totalRun + 1) / int.parse(scoreBloc.matchData!.over!)).toStringAsFixed(2)}")
          ],
        ),
        confirmationButton: TextButton(
            onPressed: () {
              matchSetupBloc.add(const MatchSetupSetIsMatchNew(false));
              GoRouter.of(context).push(RoutesName.playerSelect.path);
              GoRouter.of(context).pop();
            },
            child: const Text('Okay')));
  }

  void runCount(int run) {
    final scoreBloc = context.read<ScoreBloc>();
    final int maxBalls = int.parse(scoreBloc.matchData!.over!) * 6;
    final int maxWickets = int.parse(scoreBloc.matchData!.playerPerMatch ?? "11") - 1;

    if (scoreBloc.totalBall < maxBalls && scoreBloc.totalWicket < maxWickets) {
      if (scoreBloc.overLength < 6) {
        if (scoreBloc.wicket) {
          scoreBloc.add(WhoGotOutChanged(scoreBloc.striker!.playerId!));
          GoRouter.of(context).pushNamed(RoutesName.fallOfWicket.name, pathParameters: {"run": "$run"});
        } else {
          scoreBloc.add(CountRun(run: run));
          // Navigation (over complete, inning end, match won) is handled
          // by BlocListener reacting to navigationAction after CountRun processes
        }
      } else {
        GoRouter.of(context).push(RoutesName.selectBowler.path);
      }
    } else {
      scoreBloc.currentInning!.isFirstInning! ? inningDialog(context) : wonNavigate();
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
    required ScoreBloc scoreBloc,
  }) {
    return InkWell(
      onTap: () {
        switch (childText) {
          case "Wicket":
            scoreBloc.add(const ToggleWicket());
            break;
          case "Wide":
            scoreBloc.add(const ToggleWide());
            break;
          case "No Ball":
            scoreBloc.add(const ToggleNoBall());
            break;
          case "Byes":
            scoreBloc.add(const ToggleByes());
            break;
          case "Leg Byes":
            scoreBloc.add(const ToggleLegByes());
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
                    scoreBloc.add(const ToggleWicket());
                    break;
                  case "Wide":
                    scoreBloc.add(const ToggleWide());
                    break;
                  case "No Ball":
                    scoreBloc.add(const ToggleNoBall());
                    break;
                  case "Byes":
                    scoreBloc.add(const ToggleByes());
                    break;
                  case "Leg Byes":
                    scoreBloc.add(const ToggleLegByes());
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

  Widget cricFilledButton({required String childText, double? width, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(color: context.primary, borderRadius: BorderRadius.circular(10)),
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
