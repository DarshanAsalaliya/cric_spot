import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeStore = getIt.get<HomeStore>();
    homeStore.getMatchHistory();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Observer(builder: (_) {
          return ListView.builder(
              itemCount: homeStore.matchList.length,
              itemBuilder: (context, index) {
                return matchHistoryCard(
                    context, homeStore.matchList[index], homeStore);
              });
        }),
      ),
    );
  }

  Widget matchHistoryCard(
      BuildContext context, MatchModel match, HomeStore homeStore) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "23/01/2023 - 02:45 PM",
              style: context.bodyMedium,
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      child: Image.network(
                          "https://d1muf25xaso8hp.cloudfront.net/https%3A%2F%2Fmeta-q.cdn.bubble.io%2Ff1512936020165x278911292087286720%2FA.png?w=&h=&auto=compress&dpr=1&fit=max"),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      match.firstBatTeamName ?? '',
                      style: context.titleMedium,
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      match.firstBatTeamScore ?? '',
                      style: context.titleLarge,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text("(${match.firstBatTeamOver ?? ''})"),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      child: Image.network(
                          "https://d1muf25xaso8hp.cloudfront.net/https%3A%2F%2Fmeta-q.cdn.bubble.io%2Ff1512936020165x278911292087286720%2FA.png?w=&h=&auto=compress&dpr=1&fit=max"),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      match.secondBatTeamName ?? '',
                      style: context.titleMedium,
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      match.secondBatTeamScore ?? '',
                      style: context.titleLarge,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text("(${match.secondBatTeamOver ?? ''})"),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              match.wonBy == null
                  ? "${match.tossName} obted ${match.tossElect} first"
                  : match.wonBy == 'tie'
                      ? "Match is tie"
                      : "${match.wonName} won by ${match.wonBy}",
              style: context.bodyMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: match.wonId == null
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: [
                      match.wonId == null
                          ? TextButton(
                              onPressed: () {
                                GoRouter.of(context).pushNamed(
                                    RoutesName.scoreCount.name,
                                    pathParameters: {
                                      'matchId': match.key.toString()
                                    });
                              },
                              child: const Text("Resume"))
                          : const SizedBox.shrink(),
                      TextButton(
                          onPressed: () {
                            GoRouter.of(context).pushNamed(
                                RoutesName.scoreBoard.name,
                                pathParameters: {
                                  "matchId": match.key.toString()
                                });
                          },
                          child: const Text("Score Card")),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      homeStore.removeMatch(int.parse(match.id!));
                    },
                    icon: const Icon(Icons.delete))
              ],
            )
          ],
        ),
      ),
    );
  }
}
