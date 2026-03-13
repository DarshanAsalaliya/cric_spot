import 'package:cric_spot/bloc/auth/auth_cubit.dart';
import 'package:cric_spot/bloc/auth/auth_state.dart';
import 'package:cric_spot/bloc/home/home_cubit.dart';
import 'package:cric_spot/bloc/home/home_state.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/enum/page_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/ui/home/widgets/content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        title: const Text("Crick Spot"),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push(RoutesName.tournamentList.path);
            },
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: 'Tournaments',
          ),
          IconButton(
            onPressed: () {
              GoRouter.of(context).push(RoutesName.joinLive.path);
            },
            icon: const Icon(Icons.live_tv),
            tooltip: 'Watch Live',
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.isAuthenticated) {
                return IconButton(
                  onPressed: () {
                    GoRouter.of(context).push(RoutesName.userProfile.path);
                  },
                  icon: const Icon(Icons.account_circle),
                  tooltip: 'Profile',
                );
              }
              return IconButton(
                onPressed: () {
                  GoRouter.of(context).push(RoutesName.login.path);
                },
                icon: const Icon(Icons.login),
                tooltip: 'Sign In',
              );
            },
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: const ContentWidget(),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: NavigationBar(
            elevation: 1,
            backgroundColor: context.surface,
            selectedIndex: state.selectedIndex,
            onDestinationSelected: (index) => context.read<HomeCubit>().changeIndex(index),
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
