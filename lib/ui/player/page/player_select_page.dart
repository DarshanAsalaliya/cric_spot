import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/bloc/score/score_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PlayerSelectPage extends StatelessWidget {
  const PlayerSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matchSetupBloc = context.read<MatchSetupBloc>();

    TextEditingController strikerController = TextEditingController();
    TextEditingController nonStrikerController = TextEditingController();
    TextEditingController bowlerController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select opening players'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Striker",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: strikerController,
              hintText: "Player name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (val) {
                matchSetupBloc.add(MatchSetupStrikerNameChanged(val));
                // homeStore.hostTeamNameChange(val);
              },
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.strikerNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.strikerNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Non-Striker",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: nonStrikerController,
              hintText: "Player name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (val) {
                matchSetupBloc.add(MatchSetupNonStrikerNameChanged(val));
                // homeStore.visitorTeamNameChange(val);
              },
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.nonStrikerNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.nonStrikerNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Opening Bowler",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: bowlerController,
              hintText: "Player name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (val) {
                matchSetupBloc.add(MatchSetupOpeningBowlerNameChanged(val));
                // homeStore.visitorTeamNameChange(val);
              },
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.openingBowlerNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.openingBowlerNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
                onPressed: () async {
                  final matchSetupBloc = context.read<MatchSetupBloc>();
                  matchSetupBloc.add(const MatchSetupValidateOpener());
                  // Check validation inline
                  final currentState = matchSetupBloc.state;
                  if (currentState.strikerName.isNotEmpty &&
                      currentState.nonStrikerName.isNotEmpty &&
                      currentState.openingBowlerName.isNotEmpty) {
                    if (currentState.isMatchNew) {
                      matchSetupBloc.add(const MatchSetupCreateMatch());
                      // Listen for match creation via stream
                      await for (final state in matchSetupBloc.stream) {
                        if (state.status == MatchSetupStatus.created && state.matchId != null) {
                          if (!context.mounted) return;
                          GoRouter.of(context).pop();
                          GoRouter.of(context).pushNamed(RoutesName.scoreCount.name,
                              pathParameters: {'matchId': state.matchId!});
                          break;
                        }
                        if (state.status == MatchSetupStatus.error) {
                          break;
                        }
                      }
                    } else {
                      context.read<ScoreBloc>().add(ChangeInning(
                          striker: currentState.strikerName,
                          nonStriker: currentState.nonStrikerName,
                          bowler: currentState.openingBowlerName));
                      if (!context.mounted) return;
                      GoRouter.of(context).pop();
                    }
                  }
                },
                child: const Text("Start Match"))
          ],
        ),
      ),
    );
  }
}
