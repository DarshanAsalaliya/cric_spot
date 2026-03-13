import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/bloc/tournament/tournament_cubit.dart';
import 'package:cric_spot/bloc/tournament/tournament_state.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/enum/box_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/model/match/match_model.dart';
import 'package:cric_spot/service/supabase_sync_service.dart';
import 'package:cric_spot/ui/tournament/pages/tournament_match_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class TournamentDetailPage extends StatelessWidget {
  final String tournamentId;

  const TournamentDetailPage({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TournamentCubit()..loadTournamentDetail(tournamentId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tournament'),
        ),
        body: BlocBuilder<TournamentCubit, TournamentState>(
          builder: (context, state) {
            if (state.status == TournamentStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == TournamentStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Failed to load',
                  style: context.bodyMedium?.copyWith(color: context.error),
                ),
              );
            }

            final tournament = state.selectedTournament;
            if (tournament == null) return const SizedBox.shrink();

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<TournamentCubit>().loadTournamentDetail(tournamentId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tournament header
                    Text(
                      tournament['name'] as String? ?? '',
                      style: context.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    _StatusChip(status: tournament['status'] as String? ?? 'upcoming'),
                    const SizedBox(height: 24),

                    // Action buttons row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showAddTeamDialog(context),
                            icon: const Icon(Icons.group_add, size: 18),
                            label: const Text('Add Team'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: state.tournamentTeams.length >= 2
                                ? () => _navigateToMatchSetup(context, state)
                                : null,
                            icon: const Icon(Icons.sports_cricket, size: 18),
                            label: const Text('Create Match'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Teams section
                    Text(
                      'Teams (${state.tournamentTeams.length})',
                      style: context.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (state.tournamentTeams.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.groups_outlined,
                                    size: 48, color: context.onSurfaceVariant),
                                const SizedBox(height: 8),
                                Text(
                                  'No teams added yet',
                                  style: context.bodyMedium
                                      ?.copyWith(color: context.onSurfaceVariant),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap "Add Team" to get started',
                                  style: context.bodySmall
                                      ?.copyWith(color: context.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ...state.tournamentTeams.map((tt) {
                        final team = tt['teams'] as Map<String, dynamic>?;
                        final teamId = tt['team_id'] as String;
                        final teamName = team?['name'] as String? ?? 'Unknown Team';
                        final players = state.teamPlayers[teamId] ?? [];

                        return _TeamCard(
                          teamId: teamId,
                          teamName: teamName,
                          players: players,
                          tournamentId: tournamentId,
                        );
                      }),
                    const SizedBox(height: 24),

                    // Matches section
                    Text(
                      'Matches (${state.tournamentMatches.length})',
                      style: context.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (state.tournamentMatches.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.sports_cricket_outlined,
                                    size: 48, color: context.onSurfaceVariant),
                                const SizedBox(height: 8),
                                Text(
                                  'No matches yet',
                                  style: context.bodyMedium
                                      ?.copyWith(color: context.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ...state.tournamentMatches.map((match) =>
                          _MatchCard(match: match, tournamentId: tournamentId)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToMatchSetup(BuildContext context, TournamentState state) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TournamentCubit>(),
          child: TournamentMatchSetupPage(
            tournamentId: tournamentId,
            teams: state.tournamentTeams,
          ),
        ),
      ),
    );
  }

  void _showAddTeamDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Team'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Team name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              context
                  .read<TournamentCubit>()
                  .createTeamForTournament(tournamentId, name);
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// -- Status chip widget --

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'in_progress':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: context.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// -- Match card with start/resume --

class _MatchCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final String tournamentId;

  const _MatchCard({required this.match, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    final team1 = match['first_bat_team_name'] as String? ?? '';
    final team2 = match['second_bat_team_name'] as String? ?? '';
    final score1 = match['first_bat_team_score'] as String? ?? '0/0';
    final score2 = match['second_bat_team_score'] as String? ?? '0/0';
    final status = match['status'] as String? ?? 'upcoming';
    final overs = match['overs'] as int? ?? 0;
    final format = match['match_format'] as String? ??
        SupabaseSyncService.getMatchFormat(overs);
    final matchId = match['id'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: status == 'live' ? () => _resumeMatch(context, matchId) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Format & status row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      SupabaseSyncService.formatLabel(format),
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _MatchStatusBadge(status: status),
                ],
              ),
              const SizedBox(height: 12),

              // Scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(team1,
                        style: context.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Text(score1, style: context.bodyMedium),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(team2,
                        style: context.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Text(score2, style: context.bodyMedium),
                ],
              ),

              if (match['won_by_description'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  match['won_by_description'] as String,
                  style: context.bodySmall
                      ?.copyWith(color: context.onSurfaceVariant),
                ),
              ],

              // Action buttons
              if (status == 'upcoming' || status == 'live') ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == 'upcoming')
                      FilledButton.tonalIcon(
                        onPressed: () => _startMatch(context, matchId, match),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('Start'),
                      ),
                    if (status == 'live')
                      FilledButton.icon(
                        onPressed: () => _resumeMatch(context, matchId),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('Resume'),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Start an upcoming match - navigate to the match setup flow
  /// with pre-filled team names from this tournament match.
  void _startMatch(BuildContext context, String remoteMatchId, Map<String, dynamic> matchData) {
    final bloc = GetIt.instance.get<MatchSetupBloc>();
    final team1 = matchData['first_bat_team_name'] as String? ?? '';
    final team2 = matchData['second_bat_team_name'] as String? ?? '';
    final overs = matchData['overs'] as int? ?? 20;

    // Pre-fill the match setup
    bloc.add(MatchSetupSetTournamentId(tournamentId));
    bloc.add(MatchSetupHostTeamNameChanged(team1));
    bloc.add(MatchSetupVisitorTeamNameChanged(team2));
    bloc.add(MatchSetupOverChanged(overs.toString()));
    bloc.add(const MatchSetupSetIsMatchNew(true));

    // Navigate to player select
    GoRouter.of(context).pushNamed(RoutesName.playerSelect.name);
  }

  /// Resume a live match - find the Hive match by remoteId and navigate to scoring.
  void _resumeMatch(BuildContext context, String remoteMatchId) {
    try {
      final matchBox = GetIt.instance.get<Box<MatchModel>>(instanceName: BoxType.match.name);
      final hiveMatch = matchBox.values.cast<MatchModel?>().firstWhere(
        (m) => m?.remoteId == remoteMatchId,
        orElse: () => null,
      );

      if (hiveMatch != null && hiveMatch.id != null) {
        GoRouter.of(context).pushNamed(
          RoutesName.scoreCount.name,
          pathParameters: {'matchId': hiveMatch.id!},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match not found locally. Start the match first.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not find match data')),
      );
    }
  }
}

class _MatchStatusBadge extends StatelessWidget {
  final String status;
  const _MatchStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'live':
        color = Colors.green;
        label = 'LIVE';
        break;
      case 'completed':
        color = Colors.blue;
        label = 'COMPLETED';
        break;
      default:
        color = Colors.orange;
        label = 'UPCOMING';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: context.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// -- Team card (unchanged from previous) --

class _TeamCard extends StatelessWidget {
  final String teamId;
  final String teamName;
  final List<Map<String, dynamic>> players;
  final String tournamentId;

  const _TeamCard({
    required this.teamId,
    required this.teamName,
    required this.players,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.groups, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    teamName,
                    style: context.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, size: 20),
                  tooltip: 'Add Player',
                  onPressed: () => _showAddPlayerSheet(context),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline,
                      size: 20, color: context.error),
                  tooltip: 'Remove Team',
                  onPressed: () {
                    context
                        .read<TournamentCubit>()
                        .removeTeamFromTournament(tournamentId, teamId);
                  },
                ),
              ],
            ),
            const Divider(),
            if (players.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No players added',
                  style: context.bodySmall
                      ?.copyWith(color: context.onSurfaceVariant),
                ),
              )
            else
              ...players.map((tp) {
                final player = tp['players'] as Map<String, dynamic>?;
                final playerName = player?['name'] as String? ?? 'Unknown';
                final playerId = tp['player_id'] as String;
                final totalMatches = player?['total_matches'] as int? ?? 0;

                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 16,
                    child: Text(
                      playerName.isNotEmpty ? playerName[0].toUpperCase() : '?',
                      style: context.bodySmall,
                    ),
                  ),
                  title: Text(playerName, style: context.bodyMedium),
                  subtitle: totalMatches > 0
                      ? Text('$totalMatches matches',
                          style: context.bodySmall
                              ?.copyWith(color: context.onSurfaceVariant))
                      : null,
                  trailing: IconButton(
                    icon: Icon(Icons.close, size: 18, color: context.error),
                    onPressed: () {
                      context
                          .read<TournamentCubit>()
                          .removePlayerFromTeam(teamId, playerId);
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showAddPlayerSheet(BuildContext context) {
    final cubit = context.read<TournamentCubit>();
    cubit.clearSearch();
    final searchController = TextEditingController();
    final newPlayerController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text('Add Player to $teamName',
                        style: Theme.of(sheetContext).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search players by name...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            cubit.clearSearch();
                          },
                        ),
                      ),
                      onChanged: (q) => cubit.searchPlayers(q),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: BlocBuilder<TournamentCubit, TournamentState>(
                        builder: (ctx, state) {
                          if (state.isSearching) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final results = state.searchResults;
                          if (searchController.text.trim().length >= 2 &&
                              results.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.person_off, size: 48, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  const Text('No players found'),
                                  const SizedBox(height: 16),
                                  FilledButton.icon(
                                    onPressed: () {
                                      newPlayerController.text = searchController.text.trim();
                                      _showCreatePlayerDialog(ctx, newPlayerController);
                                    },
                                    icon: const Icon(Icons.person_add),
                                    label: const Text('Create New Player'),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (results.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.search, size: 48, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  const Text('Search for existing players'),
                                  const SizedBox(height: 16),
                                  OutlinedButton.icon(
                                    onPressed: () => _showCreatePlayerDialog(ctx, newPlayerController),
                                    icon: const Icon(Icons.person_add),
                                    label: const Text('Or Create New Player'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: results.length + 1,
                            itemBuilder: (_, i) {
                              if (i == results.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      newPlayerController.text = searchController.text.trim();
                                      _showCreatePlayerDialog(ctx, newPlayerController);
                                    },
                                    icon: const Icon(Icons.person_add),
                                    label: const Text('Create New Player'),
                                  ),
                                );
                              }
                              final player = results[i];
                              final name = player['name'] as String? ?? 'Unknown';
                              final username = player['username'] as String?;
                              final matches = player['total_matches'] as int? ?? 0;
                              final runs = player['total_runs'] as int? ?? 0;
                              final wickets = player['total_wickets'] as int? ?? 0;
                              final playerId = player['id'] as String;
                              final alreadyInTeam = (state.teamPlayers[teamId] ?? [])
                                  .any((tp) => tp['player_id'] == playerId);
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
                                ),
                                title: Text(name),
                                subtitle: Text([
                                  if (username != null) '@$username',
                                  '$matches M',
                                  '$runs R',
                                  '$wickets W',
                                ].join(' · ')),
                                trailing: alreadyInTeam
                                    ? const Chip(label: Text('Added'))
                                    : IconButton(
                                        icon: const Icon(Icons.add_circle),
                                        onPressed: () => cubit.addPlayerToTeam(teamId, playerId),
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showCreatePlayerDialog(BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create New Player'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Player name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              context.read<TournamentCubit>().createPlayerForTeam(teamId, name);
              Navigator.pop(dialogContext);
            },
            child: const Text('Create & Add'),
          ),
        ],
      ),
    );
  }
}
