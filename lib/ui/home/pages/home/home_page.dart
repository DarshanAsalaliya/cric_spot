import 'package:cric_spot/core/enum/page_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:cric_spot/ui/home/widgets/content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

final destinations = [
  Destination(
      icon: const Icon(Icons.sports_cricket_outlined),
      selectedIcon: const Icon(Icons.sports_cricket),
      pageType: PageType.newMatch),
  Destination(
      icon: const Icon(Icons.groups_2_outlined),
      selectedIcon: const Icon(Icons.groups_2_sharp),
      pageType: PageType.teams),
  Destination(
      icon: const Icon(Icons.history_outlined),
      selectedIcon: const Icon(Icons.history),
      pageType: PageType.history)
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeStore = Provider.of<HomeStore>(context);
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        title: const Text("Crick Spot"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: const ContentWidget(),
      bottomNavigationBar: Observer(builder: (_) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: NavigationBar(
            elevation: 1,
            backgroundColor: context.surface,
            selectedIndex: homeStore.selectedIndex,
            onDestinationSelected: (index) => homeStore.currentIndex(index),
            destinations: destinations
                .sublist(0, 3)
                .map((e) => NavigationDestination(
                      icon: e.icon,
                      selectedIcon: e.selectedIcon,
                      label: e.pageType.name,
                    ))
                .toList(),
          ),
        );
      }),
    );
  }
}

class Destination {
  Destination(
      {required this.icon, required this.selectedIcon, required this.pageType});
  final Icon icon;
  final Icon selectedIcon;
  final PageType pageType;
}
