import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdwanceSettingPage extends StatelessWidget {
  const AdwanceSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MatchSetupBloc>();
    TextEditingController playerPerMatchController = TextEditingController();
    TextEditingController noBallRunController = TextEditingController();
    TextEditingController wideBallRunController = TextEditingController();
    playerPerMatchController.text = bloc.state.playerPerMatch;
    noBallRunController.text = bloc.state.noBallRun;
    wideBallRunController.text = bloc.state.wideBallRun;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Match Setting"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Player per match?",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: playerPerMatchController,
              hintText: "11",
              keyboardType: TextInputType.number,
              onChanged: (val) {
                bloc.add(MatchSetupPlayerPerMatchChanged(val));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "No Ball",
                  style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
                ),
                BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
                  return Switch(
                      value: state.isNoBall,
                      onChanged: (value) {
                        bloc.add(MatchSetupNoBallToggled(value));
                      });
                })
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.isNoBall
                  ? Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Re-ball",
                                  style: context.bodyMedium,
                                )),
                                BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
                                  return Switch(
                                      value: state.noBallReBall,
                                      onChanged: (value) {
                                        bloc.add(MatchSetupNoBallReBallToggled(value));
                                      });
                                })
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "No ball Run",
                                    style: context.bodyMedium,
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CricTextFormField(
                                    onChanged: (val) {
                                      bloc.add(MatchSetupNoBallRunChanged(val));
                                    },
                                    controller: noBallRunController,
                                    hintText: "1",
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wide Ball",
                  style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
                ),
                BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
                  return Switch(
                      value: state.isWideBall,
                      onChanged: (value) {
                        bloc.add(MatchSetupWideBallToggled(value));
                      });
                })
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.isWideBall
                  ? Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Re-ball",
                                  style: context.bodyMedium,
                                )),
                                BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
                                  return Switch(
                                      value: state.wideReBall,
                                      onChanged: (value) {
                                        bloc.add(MatchSetupWideBallReBallToggled(value));
                                      });
                                })
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Wide ball Run",
                                    style: context.bodyMedium,
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CricTextFormField(
                                    controller: wideBallRunController,
                                    hintText: "1",
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      bloc.add(MatchSetupWideBallRunChanged(val));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
            const SizedBox(
              height: 8,
            ),
            FilledButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                child: const Text("Save Setting"))
          ],
        ),
      ),
    );
  }
}
