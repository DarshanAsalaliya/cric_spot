import 'package:cric_spot/bloc/auth/auth_cubit.dart';
import 'package:cric_spot/bloc/auth/auth_state.dart';
import 'package:cric_spot/bloc/player_profile/player_profile_state.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthCubit>().loadFullProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () => _showSignOutDialog(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (!state.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Not signed in'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => GoRouter.of(context).push(RoutesName.login.path),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<AuthCubit>().loadFullProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(state: state),
                  const SizedBox(height: 20),

                  // Quick stats row
                  _QuickStatsRow(state: state),
                  const SizedBox(height: 24),

                  // Account actions
                  _AccountActions(state: state),
                  const SizedBox(height: 24),

                  // Batting stats
                  if (state.careerStats != null) ...[
                    _SectionHeader(title: 'Batting (Overall)'),
                    const SizedBox(height: 8),
                    _BattingStatsCard(state: state),
                    const SizedBox(height: 16),

                    // Bowling stats
                    _SectionHeader(title: 'Bowling (Overall)'),
                    const SizedBox(height: 8),
                    _BowlingStatsCard(state: state),
                  ],

                  // Format-specific stats
                  if (state.formatStats.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionHeader(title: 'Stats by Format'),
                    const SizedBox(height: 8),
                    ...state.formatStats.map((fs) => _FormatStatsSection(stats: fs)),
                  ],

                  const SizedBox(height: 24),

                  // My Tournaments
                  _SectionHeader(title: 'My Tournaments'),
                  const SizedBox(height: 8),
                  _MyTournaments(tournaments: state.myTournaments),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
              Navigator.pop(ctx);
              GoRouter.of(context).go(RoutesName.landing.path);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AuthState state;
  const _ProfileHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: context.primaryContainer,
            child: Text(
              (state.displayName ?? state.user?.email ?? '?')[0].toUpperCase(),
              style: context.headlineLarge?.copyWith(color: context.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.displayName ?? 'No Name',
            style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (state.username != null) ...[
            const SizedBox(height: 2),
            Text(
              '@${state.username}',
              style: context.bodyMedium?.copyWith(color: context.primary),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            state.user?.email ?? '',
            style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            '${state.totalMatches} Matches',
            style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  final AuthState state;
  const _QuickStatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickStat(label: 'Runs', value: '${state.totalRuns}'),
        _QuickStat(label: 'HS', value: '${state.highestScore}'),
        _QuickStat(label: 'Wkts', value: '${state.totalWickets}'),
        _QuickStat(label: '50s', value: '${state.totalFifties}'),
        _QuickStat(label: '100s', value: '${state.totalHundreds}'),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  const _QuickStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(value, style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label, style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountActions extends StatelessWidget {
  final AuthState state;
  const _AccountActions({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Display Name'),
            subtitle: Text(state.displayName ?? 'Not set'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditDialog(
              context,
              title: 'Edit Display Name',
              currentValue: state.displayName ?? '',
              hint: 'Display Name',
              onSave: (v) => context.read<AuthCubit>().updateDisplayName(v),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text('Username'),
            subtitle: Text(state.username != null ? '@${state.username}' : 'Set a username'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditDialog(
              context,
              title: 'Set Username',
              currentValue: state.username ?? '',
              hint: 'username (lowercase, no spaces)',
              onSave: (v) async {
                final success = await context.read<AuthCubit>().updateUsername(v);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Username already taken or invalid')),
                  );
                }
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(state.user?.email ?? ''),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String currentValue,
    required String hint,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: CricTextFormField(
          controller: controller,
          hintText: hint,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.none,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                onSave(val);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _BattingStatsCard extends StatelessWidget {
  final AuthState state;
  const _BattingStatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatRow('Innings', '${state.totalInningsBatted}'),
            _StatRow('Runs', '${state.totalRuns}'),
            _StatRow('Balls Faced', '${state.totalBallsFaced}'),
            _StatRow('Highest Score', '${state.highestScore}'),
            _StatRow('Not Outs', '${state.totalNotOuts}'),
            _StatRow('Fours', '${state.totalFours}'),
            _StatRow('Sixes', '${state.totalSixes}'),
            _StatRow('50s / 100s', '${state.totalFifties} / ${state.totalHundreds}'),
            _StatRow('Average', state.battingAverage.toStringAsFixed(2)),
            _StatRow('Strike Rate', state.strikeRate.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}

class _BowlingStatsCard extends StatelessWidget {
  final AuthState state;
  const _BowlingStatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatRow('Innings', '${state.totalInningsBowled}'),
            _StatRow('Wickets', '${state.totalWickets}'),
            _StatRow('Runs Conceded', '${state.totalRunsConceded}'),
            _StatRow('Overs', '${state.totalBallsBowled ~/ 6}.${state.totalBallsBowled % 6}'),
            _StatRow('Maidens', '${state.totalMaidens}'),
            _StatRow('Best', state.bestBowling),
            _StatRow('Average', state.bowlingAverage.toStringAsFixed(2)),
            _StatRow('Economy', state.economyRate.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}

class _FormatStatsSection extends StatelessWidget {
  final FormatStats stats;
  const _FormatStatsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${stats.label} (${stats.matches} matches)',
            style: context.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Batting', style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600, color: context.onSurfaceVariant)),
                const SizedBox(height: 4),
                _StatRow('Innings', '${stats.inningsBatted}'),
                _StatRow('Runs', '${stats.runs}'),
                _StatRow('HS', '${stats.highestScore}'),
                _StatRow('Not Outs', '${stats.notOuts}'),
                _StatRow('4s / 6s', '${stats.fours} / ${stats.sixes}'),
                _StatRow('50s / 100s', '${stats.fifties} / ${stats.hundreds}'),
                _StatRow('Avg', stats.battingAverage.toStringAsFixed(2)),
                _StatRow('SR', stats.strikeRate.toStringAsFixed(2)),
                const Divider(),
                Text('Bowling', style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600, color: context.onSurfaceVariant)),
                const SizedBox(height: 4),
                _StatRow('Innings', '${stats.inningsBowled}'),
                _StatRow('Wickets', '${stats.wickets}'),
                _StatRow('Best', stats.bestBowling),
                _StatRow('Avg', stats.bowlingAverage.toStringAsFixed(2)),
                _StatRow('Econ', stats.economyRate.toStringAsFixed(2)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.bodyMedium),
          Text(value, style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MyTournaments extends StatelessWidget {
  final List<Map<String, dynamic>> tournaments;
  const _MyTournaments({required this.tournaments});

  @override
  Widget build(BuildContext context) {
    if (tournaments.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Not part of any tournament yet',
              style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return Column(
      children: tournaments.map((t) {
        final status = t['tournament_status'] as String? ?? '';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              Icons.emoji_events,
              color: status == 'in_progress' ? Colors.green : context.primary,
            ),
            title: Text(t['tournament_name'] as String? ?? ''),
            subtitle: Text('Team: ${t['team_name'] ?? 'Unknown'}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: status == 'in_progress'
                    ? Colors.green.withValues(alpha: 0.1)
                    : context.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status.replaceAll('_', ' ').toUpperCase(),
                style: context.bodySmall,
              ),
            ),
            onTap: () {
              final id = t['tournament_id'] as String?;
              if (id != null) {
                GoRouter.of(context).pushNamed(
                  RoutesName.tournamentDetail.name,
                  pathParameters: {'tournamentId': id},
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
