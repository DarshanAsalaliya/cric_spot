import 'package:cric_spot/bloc/player_profile/player_profile_cubit.dart';
import 'package:cric_spot/bloc/player_profile/player_profile_state.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerProfilePage extends StatelessWidget {
  final String playerId;
  final String? playerName;

  const PlayerProfilePage({
    super.key,
    required this.playerId,
    this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerProfileCubit()..loadProfile(playerId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(playerName ?? 'Player Profile'),
        ),
        body: BlocBuilder<PlayerProfileCubit, PlayerProfileState>(
          builder: (context, state) {
            if (state.status == PlayerProfileStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == PlayerProfileStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Failed to load profile',
                  style: context.bodyMedium?.copyWith(color: context.error),
                ),
              );
            }
            if (state.status != PlayerProfileStatus.loaded) {
              return const SizedBox.shrink();
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<PlayerProfileCubit>().loadProfile(playerId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: context.primaryContainer,
                            child: Text(
                              (state.playerName ?? '?')[0].toUpperCase(),
                              style: context.headlineLarge?.copyWith(
                                color: context.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.playerName ?? 'Unknown',
                            style: context.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.totalMatches} Matches',
                            style: context.bodyMedium?.copyWith(
                              color: context.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick stats row
                    _QuickStatsRow(state: state),
                    const SizedBox(height: 24),

                    // Overall Batting Stats
                    _SectionHeader(title: 'Batting (Overall)'),
                    const SizedBox(height: 8),
                    _BattingStatsCard(
                      innings: state.totalInningsBatted,
                      runs: state.totalRuns,
                      balls: state.totalBallsFaced,
                      highestScore: state.highestScore,
                      fours: state.totalFours,
                      sixes: state.totalSixes,
                      notOuts: state.totalNotOuts,
                      fifties: state.totalFifties,
                      hundreds: state.totalHundreds,
                      average: state.battingAverage,
                      strikeRate: state.strikeRate,
                    ),
                    const SizedBox(height: 16),

                    // Overall Bowling Stats
                    _SectionHeader(title: 'Bowling (Overall)'),
                    const SizedBox(height: 8),
                    _BowlingStatsCard(
                      innings: state.totalInningsBowled,
                      wickets: state.totalWickets,
                      runsConceded: state.totalRunsConceded,
                      ballsBowled: state.totalBallsBowled,
                      maidens: state.totalMaidens,
                      bestBowling: state.bestBowling,
                      average: state.bowlingAverage,
                      economy: state.economyRate,
                    ),

                    // Format-specific stats
                    if (state.formatStats.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _SectionHeader(title: 'Stats by Format'),
                      const SizedBox(height: 8),
                      ...state.formatStats.map((fs) => _FormatStatsSection(stats: fs)),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -- Quick stats row --

class _QuickStatsRow extends StatelessWidget {
  final PlayerProfileState state;
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
              Text(value,
                  style: context.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label,
                  style: context.bodySmall
                      ?.copyWith(color: context.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

// -- Batting stats card --

class _BattingStatsCard extends StatelessWidget {
  final int innings, runs, balls, highestScore, fours, sixes, notOuts, fifties, hundreds;
  final double average, strikeRate;

  const _BattingStatsCard({
    required this.innings,
    required this.runs,
    required this.balls,
    required this.highestScore,
    required this.fours,
    required this.sixes,
    required this.notOuts,
    required this.fifties,
    required this.hundreds,
    required this.average,
    required this.strikeRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatRow('Innings', '$innings'),
            _StatRow('Runs', '$runs'),
            _StatRow('Balls Faced', '$balls'),
            _StatRow('Highest Score', '$highestScore'),
            _StatRow('Not Outs', '$notOuts'),
            _StatRow('Fours', '$fours'),
            _StatRow('Sixes', '$sixes'),
            _StatRow('50s / 100s', '$fifties / $hundreds'),
            _StatRow('Average', average.toStringAsFixed(2)),
            _StatRow('Strike Rate', strikeRate.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}

// -- Bowling stats card --

class _BowlingStatsCard extends StatelessWidget {
  final int innings, wickets, runsConceded, ballsBowled, maidens;
  final String bestBowling;
  final double average, economy;

  const _BowlingStatsCard({
    required this.innings,
    required this.wickets,
    required this.runsConceded,
    required this.ballsBowled,
    required this.maidens,
    required this.bestBowling,
    required this.average,
    required this.economy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatRow('Innings', '$innings'),
            _StatRow('Wickets', '$wickets'),
            _StatRow('Runs Conceded', '$runsConceded'),
            _StatRow('Overs', '${ballsBowled ~/ 6}.${ballsBowled % 6}'),
            _StatRow('Maidens', '$maidens'),
            _StatRow('Best', bestBowling),
            _StatRow('Average', average.toStringAsFixed(2)),
            _StatRow('Economy', economy.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}

// -- Format-specific stats section --

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

// -- Shared widgets --

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
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
          Text(
            value,
            style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
