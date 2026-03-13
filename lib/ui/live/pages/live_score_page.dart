import 'dart:async';

import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/service/supabase_sync_service.dart';
import 'package:flutter/material.dart';

class LiveScorePage extends StatefulWidget {
  final String matchId;
  const LiveScorePage({super.key, required this.matchId});

  @override
  State<LiveScorePage> createState() => _LiveScorePageState();
}

class _LiveScorePageState extends State<LiveScorePage> {
  final _syncService = getIt.get<SupabaseSyncService>();
  Map<String, dynamic> _matchData = {};
  List<Map<String, dynamic>> _innings = [];
  late StreamSubscription _matchSub;
  late StreamSubscription _inningsSub;

  @override
  void initState() {
    super.initState();
    _matchSub = _syncService.watchMatch(widget.matchId).listen((data) {
      if (mounted && data.isNotEmpty) {
        setState(() => _matchData = data);
      }
    });
    _inningsSub = _syncService.watchInnings(widget.matchId).listen((data) {
      if (mounted) {
        setState(() => _innings = data);
      }
    });
  }

  @override
  void dispose() {
    _matchSub.cancel();
    _inningsSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLive = _matchData['status'] == 'live';
    final firstTeam = _matchData['first_bat_team_name'] ?? '';
    final secondTeam = _matchData['second_bat_team_name'] ?? '';
    final firstScore = _matchData['first_bat_team_score'] ?? '0/0';
    final firstOver = _matchData['first_bat_team_over'] ?? '0.0';
    final secondScore = _matchData['second_bat_team_score'] ?? '0/0';
    final secondOver = _matchData['second_bat_team_over'] ?? '0.0';

    return Scaffold(
      appBar: AppBar(
        title: Text('$firstTeam vs $secondTeam'),
        actions: [
          if (isLive)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
        ],
      ),
      body: _matchData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // First innings card
                  _buildInningsCard(
                    context,
                    teamName: firstTeam,
                    score: firstScore,
                    overs: firstOver,
                    inningData: _innings.where((i) => i['is_first_inning'] == true).firstOrNull,
                  ),
                  const SizedBox(height: 16),
                  // Second innings card
                  _buildInningsCard(
                    context,
                    teamName: secondTeam,
                    score: secondScore,
                    overs: secondOver,
                    inningData: _innings.where((i) => i['is_first_inning'] == false).firstOrNull,
                  ),
                  if (_matchData['won_by_description'] != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      _matchData['won_by_description'],
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildInningsCard(
    BuildContext context, {
    required String teamName,
    required String score,
    required String overs,
    Map<String, dynamic>? inningData,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  teamName,
                  style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$score ($overs ov)',
                  style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (inningData != null) ...[
              const SizedBox(height: 8),
              Text(
                'Extras: ${inningData['extra_total'] ?? 0} '
                '(W ${inningData['extra_wide'] ?? 0}, '
                'NB ${inningData['extra_noball'] ?? 0}, '
                'B ${inningData['extra_bye'] ?? 0}, '
                'LB ${inningData['extra_legbye'] ?? 0})',
                style: context.bodySmall?.copyWith(color: context.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
