import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/enum/team_type.dart';
import 'package:cric_spot/core/enum/opted_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

/// Page to set up a match within a tournament.
/// Pre-selects teams from the tournament, user configures overs/toss/players.
class TournamentMatchSetupPage extends StatefulWidget {
  final String tournamentId;
  final List<Map<String, dynamic>> teams;

  const TournamentMatchSetupPage({
    super.key,
    required this.tournamentId,
    required this.teams,
  });

  @override
  State<TournamentMatchSetupPage> createState() =>
      _TournamentMatchSetupPageState();
}

class _TournamentMatchSetupPageState extends State<TournamentMatchSetupPage> {
  String? _teamAId;
  String? _teamBId;
  String? _teamAName;
  String? _teamBName;
  final _oversController = TextEditingController(text: '20');
  TeamType _tossWonBy = TeamType.host;
  OptedType _opted = OptedType.bat;
  int _currentStep = 0;

  @override
  void dispose() {
    _oversController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _availableTeams {
    return widget.teams.map((tt) {
      final team = tt['teams'] as Map<String, dynamic>?;
      return {
        'id': tt['team_id'] as String,
        'name': team?['name'] as String? ?? 'Unknown',
      };
    }).toList();
  }

  String get _matchFormat {
    final overs = int.tryParse(_oversController.text) ?? 20;
    if (overs == 10) return 'T10';
    if (overs <= 20) return 'T20';
    if (overs <= 50) return 'ODI';
    return 'Custom';
  }

  String get _batTeamName {
    if (_tossWonBy == TeamType.host && _opted == OptedType.bat) return _teamAName ?? '';
    if (_tossWonBy == TeamType.host && _opted == OptedType.bowl) return _teamBName ?? '';
    if (_tossWonBy == TeamType.visitor && _opted == OptedType.bat) return _teamBName ?? '';
    return _teamAName ?? '';
  }

  String get _bowlTeamName => _batTeamName == _teamAName ? (_teamBName ?? '') : (_teamAName ?? '');

  bool get _canProceedStep0 =>
      _teamAId != null && _teamBId != null && _teamAId != _teamBId;

  bool get _canProceedStep1 =>
      _oversController.text.isNotEmpty &&
      (int.tryParse(_oversController.text) ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                FilledButton(
                  onPressed: _canContinue() ? details.onStepContinue : null,
                  child: Text(_currentStep == 2 ? 'Start Match' : 'Continue'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 1: Select teams
          Step(
            title: const Text('Select Teams'),
            subtitle: _teamAName != null && _teamBName != null
                ? Text('$_teamAName vs $_teamBName')
                : null,
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildTeamSelection(),
          ),

          // Step 2: Set overs & format
          Step(
            title: const Text('Match Settings'),
            subtitle: _canProceedStep1
                ? Text('$_matchFormat · ${_oversController.text} overs')
                : null,
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _buildMatchSettings(),
          ),

          // Step 3: Toss
          Step(
            title: const Text('Toss'),
            subtitle: _currentStep >= 2
                ? Text('$_batTeamName bats first')
                : null,
            isActive: _currentStep >= 2,
            state: StepState.indexed,
            content: _buildTossSection(),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _canProceedStep0;
      case 1:
        return _canProceedStep1;
      case 2:
        return true;
      default:
        return false;
    }
  }

  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _startMatch();
    }
  }

  Widget _buildTeamSelection() {
    final teams = _availableTeams;
    if (teams.length < 2) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'You need at least 2 teams in the tournament to create a match.',
          style: context.bodyMedium?.copyWith(color: context.error),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Team A (Host)', style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _teamAId,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: teams
              .where((t) => t['id'] != _teamBId)
              .map((t) => DropdownMenuItem(
                    value: t['id'] as String,
                    child: Text(t['name'] as String),
                  ))
              .toList(),
          onChanged: (val) {
            final team = teams.firstWhere((t) => t['id'] == val);
            setState(() {
              _teamAId = val;
              _teamAName = team['name'] as String;
            });
          },
        ),
        const SizedBox(height: 16),
        Text('Team B (Visitor)', style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _teamBId,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: teams
              .where((t) => t['id'] != _teamAId)
              .map((t) => DropdownMenuItem(
                    value: t['id'] as String,
                    child: Text(t['name'] as String),
                  ))
              .toList(),
          onChanged: (val) {
            final team = teams.firstWhere((t) => t['id'] == val);
            setState(() {
              _teamBId = val;
              _teamBName = team['name'] as String;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMatchSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _oversController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Overs',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.sports_cricket, size: 20, color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(width: 8),
              Text(
                'Format: $_matchFormat',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTossSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Toss won by', style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
        const SizedBox(height: 4),
        SegmentedButton<TeamType>(
          segments: [
            ButtonSegment(
              value: TeamType.host,
              label: Text(_teamAName ?? 'Team A'),
            ),
            ButtonSegment(
              value: TeamType.visitor,
              label: Text(_teamBName ?? 'Team B'),
            ),
          ],
          selected: {_tossWonBy},
          onSelectionChanged: (s) => setState(() => _tossWonBy = s.first),
        ),
        const SizedBox(height: 16),
        Text('Elected to', style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
        const SizedBox(height: 4),
        SegmentedButton<OptedType>(
          segments: const [
            ButtonSegment(value: OptedType.bat, label: Text('Bat')),
            ButtonSegment(value: OptedType.bowl, label: Text('Bowl')),
          ],
          selected: {_opted},
          onSelectionChanged: (s) => setState(() => _opted = s.first),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Match Summary', style: context.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('$_batTeamName bats first'),
                Text('$_bowlTeamName bowls first'),
                Text('${_oversController.text} overs · $_matchFormat'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _startMatch() {
    final bloc = GetIt.instance.get<MatchSetupBloc>();

    // Set tournament context
    bloc.add(MatchSetupSetTournamentId(widget.tournamentId));

    // Set team names
    bloc.add(MatchSetupHostTeamNameChanged(_teamAName ?? ''));
    bloc.add(MatchSetupVisitorTeamNameChanged(_teamBName ?? ''));

    // Set overs
    bloc.add(MatchSetupOverChanged(_oversController.text));

    // Set toss
    bloc.add(MatchSetupTossWonChanged(_tossWonBy));
    bloc.add(MatchSetupOptedChanged(_opted));

    // Mark as new match
    bloc.add(const MatchSetupSetIsMatchNew(true));

    // Navigate to player select (existing flow picks up from here)
    GoRouter.of(context).pushNamed(RoutesName.playerSelect.name);
  }
}
