import 'package:cric_spot/bloc/tournament/tournament_cubit.dart';
import 'package:cric_spot/bloc/tournament/tournament_state.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TournamentListPage extends StatelessWidget {
  const TournamentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TournamentCubit()..loadTournaments(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tournaments'),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              GoRouter.of(context).push(RoutesName.createTournament.path);
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: BlocBuilder<TournamentCubit, TournamentState>(
          builder: (context, state) {
            if (state.status == TournamentStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == TournamentStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Something went wrong',
                      style: context.bodyMedium?.copyWith(color: context.error),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<TournamentCubit>().loadTournaments(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state.tournaments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events_outlined,
                        size: 64, color: context.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      'No tournaments yet',
                      style: context.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first tournament',
                      style: context.bodyMedium
                          ?.copyWith(color: context.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tournaments.length,
              itemBuilder: (context, index) {
                final tournament = state.tournaments[index];
                final status = tournament['status'] as String? ?? 'upcoming';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.emoji_events,
                      color: status == 'in_progress'
                          ? Colors.green
                          : status == 'completed'
                              ? context.onSurfaceVariant
                              : context.primary,
                    ),
                    title: Text(tournament['name'] as String? ?? ''),
                    subtitle: Text(status.replaceAll('_', ' ').toUpperCase()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final id = tournament['id'] as String;
                      GoRouter.of(context).pushNamed(
                        RoutesName.tournamentDetail.name,
                        pathParameters: {'tournamentId': id},
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
