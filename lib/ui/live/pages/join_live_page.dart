import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/service/supabase_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JoinLivePage extends StatefulWidget {
  const JoinLivePage({super.key});

  @override
  State<JoinLivePage> createState() => _JoinLivePageState();
}

class _JoinLivePageState extends State<JoinLivePage> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinMatch() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty || code.length != 6) {
      setState(() => _error = 'Enter a valid 6-character match code');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final syncService = getIt.get<SupabaseSyncService>();
    final matchData = await syncService.getMatchByShareCode(code);

    if (!mounted) return;

    if (matchData != null) {
      final matchId = matchData['id'] as String;
      GoRouter.of(context).pushNamed(
        RoutesName.liveScore.name,
        pathParameters: {'matchId': matchId},
      );
    } else {
      setState(() {
        _isLoading = false;
        _error = 'No match found with this code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Live'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Icon(
              Icons.live_tv,
              size: 80,
              color: context.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter Match Code',
              style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ask the scorer for their 6-character match code',
              style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            CricTextFormField(
              controller: _codeController,
              hintText: 'Match Code (e.g. AX7K2P)',
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: context.bodySmall?.copyWith(color: context.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _joinMatch,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Watch Match'),
            ),
          ],
        ),
      ),
    );
  }
}
