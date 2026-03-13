import 'package:cric_spot/bloc/tournament/tournament_cubit.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _nameController = TextEditingController();
  final _cubit = TournamentCubit();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _createTournament() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreating = true);

    final tournamentId = await _cubit.createTournament(
      name: name,
      startDate: _startDate,
      endDate: _endDate,
    );

    if (!mounted) return;

    if (tournamentId != null) {
      // Replace this page with the tournament detail page
      GoRouter.of(context).pushReplacementNamed(
        RoutesName.tournamentDetail.name,
        pathParameters: {'tournamentId': tournamentId},
      );
    } else {
      setState(() => _isCreating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_cubit.state.errorMessage ?? 'Failed to create tournament'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tournament'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CricTextFormField(
              controller: _nameController,
              hintText: 'Tournament Name',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _pickDate(isStart: true),
              icon: const Icon(Icons.calendar_today),
              label: Text(_startDate != null
                  ? 'Start: ${_formatDate(_startDate!)}'
                  : 'Select Start Date'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _pickDate(isStart: false),
              icon: const Icon(Icons.calendar_today),
              label: Text(_endDate != null
                  ? 'End: ${_formatDate(_endDate!)}'
                  : 'Select End Date'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isCreating ? null : _createTournament,
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
