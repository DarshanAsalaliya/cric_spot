import 'package:animations/animations.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:cric_spot/ui/home/pages/history/history_page.dart';
import 'package:cric_spot/ui/home/pages/new_match/new_match_page.dart';
import 'package:cric_spot/ui/home/pages/team/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> pages = {
      0: const NewMatchPage(),
      1: TeamsPage(),
      2: const HistoryPage()
    };
    final homeStore = Provider.of<HomeStore>(context);
    return Observer(builder: (_) {
      return PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        duration: const Duration(milliseconds: 300),
        child: pages[homeStore.selectedIndex],
      );
    });
  }
}
