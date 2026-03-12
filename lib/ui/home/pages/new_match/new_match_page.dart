import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cric_spot/config/routes.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/enum/opted_type.dart';
import 'package:cric_spot/core/enum/team_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/bloc/match_setup/match_setup_bloc.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({super.key});

  @override
  State<NewMatchPage> createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {
  GlobalKey<AutoCompleteTextFieldState<TeamModel>> visitorKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<TeamModel>> hostkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MatchSetupBloc>();
    bloc.add(const MatchSetupLoadTeams());
    TextEditingController hostTeamController = TextEditingController();
    TextEditingController visitorTeamController = TextEditingController();
    TextEditingController overController = TextEditingController();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Teams",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            AutoCompleteTextField<TeamModel>(
                key: hostkey,
                controller: hostTeamController,
                clearOnSubmit: false,
                textInputAction: TextInputAction.next,
                suggestions: context.read<MatchSetupBloc>().state.teams,
                keyboardType: TextInputType.name,
                cursorColor: context.primary,
                cursorWidth: 3,
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: "Host Team",
                ),
                itemBuilder: (context, team) {
                  return ListTile(
                    title: Text(team.name!),
                  );
                },
                textChanged: (val) {
                  context.read<MatchSetupBloc>().add(MatchSetupHostTeamNameChanged(val));
                },
                itemSubmitted: (team) {
                  hostTeamController.text = team.name!;
                  context.read<MatchSetupBloc>().add(MatchSetupHostTeamNameChanged(team.name!));
                  return team.name!;
                },
                itemSorter: (a, b) => a.name == b.name
                    ? 0
                    : int.parse(a.id!) > int.parse(b.id!)
                        ? -1
                        : 1,
                itemFilter: (team, input) {
                  return team.name!.contains(input);
                }),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.hostTeamNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.hostTeamNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 16,
            ),
            AutoCompleteTextField<TeamModel>(
                key: visitorKey,
                controller: visitorTeamController,
                clearOnSubmit: false,
                textInputAction: TextInputAction.next,
                suggestions: context.read<MatchSetupBloc>().state.teams,
                keyboardType: TextInputType.name,
                cursorColor: context.primary,
                cursorWidth: 3,
                decoration: const InputDecoration(
                  hintText: "Visitor Team",
                ),
                itemBuilder: (context, team) {
                  return ListTile(
                    title: Text(team.name!),
                  );
                },
                textChanged: (val) {
                  context.read<MatchSetupBloc>().add(MatchSetupVisitorTeamNameChanged(val));
                },
                itemSubmitted: (team) {
                  visitorTeamController.text = team.name!;
                  context.read<MatchSetupBloc>().add(MatchSetupVisitorTeamNameChanged(team.name!));
                  return team.name!;
                },
                itemSorter: (a, b) => a.name == b.name
                    ? 0
                    : int.parse(a.id!) > int.parse(b.id!)
                        ? -1
                        : 1,
                itemFilter: (team, input) {
                  return team.name!.contains(input);
                }),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.visitorTeamNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.visitorTeamNameError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Toss won by?",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<MatchSetupBloc>().add(const MatchSetupTossWonChanged(TeamType.host));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: TeamType.host,
                                groupValue: state.tossWonBy,
                                onChanged: (value) {
                                  context.read<MatchSetupBloc>().add(MatchSetupTossWonChanged(value!));
                                }),
                            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
                              return Text(state.hostTeamName == "" ? "Host Team" : state.hostTeamName);
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<MatchSetupBloc>().add(const MatchSetupTossWonChanged(TeamType.visitor));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: TeamType.visitor,
                                groupValue: state.tossWonBy,
                                onChanged: (value) {
                                  context.read<MatchSetupBloc>().add(MatchSetupTossWonChanged(value!));
                                }),
                            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
                              return Text(state.visitorTeamName == "" ? "Visitor Team" : state.visitorTeamName);
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Opted to?",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<MatchSetupBloc>().add(const MatchSetupOptedChanged(OptedType.bat));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: OptedType.bat,
                                groupValue: state.opted,
                                onChanged: (value) {
                                  context.read<MatchSetupBloc>().add(MatchSetupOptedChanged(value!));
                                }),
                            const Text("Bat")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<MatchSetupBloc>().add(const MatchSetupOptedChanged(OptedType.bowl));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: OptedType.bowl,
                                groupValue: state.opted,
                                onChanged: (value) {
                                  context.read<MatchSetupBloc>().add(MatchSetupOptedChanged(value!));
                                }),
                            const Text("Bowl")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Overs?",
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: overController,
              hintText: "Overs",
              keyboardType: TextInputType.number,
              onChanged: (val) {
                context.read<MatchSetupBloc>().add(MatchSetupOverChanged(val));
              },
            ),
            BlocBuilder<MatchSetupBloc, MatchSetupState>(builder: (context, state) {
              return state.overError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.overError!,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push(RoutesName.adwanceSetting.path);
                      },
                      child: const Text("Adwance Setting")),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: FilledButton(
                        onPressed: () {
                          final bloc = context.read<MatchSetupBloc>();
                          bloc.add(const MatchSetupSetIsMatchNew(true));
                          bloc.add(const MatchSetupValidate());
                          final currentState = bloc.state;
                          // Validate manually for immediate navigation check
                          if (currentState.hostTeamName.isNotEmpty &&
                              currentState.visitorTeamName.isNotEmpty &&
                              currentState.over.isNotEmpty &&
                              currentState.hostTeamName != currentState.visitorTeamName) {
                            goRouter.push(RoutesName.playerSelect.path);
                          }
                        },
                        child: const Text("Start Match")))
              ],
            ),
          ],
        ),
      ),
    );
  }
}




/// cric text feild simple
        // CricTextFormField(
            //   controller: visitorTeamController,
            //   hintText: "Visitor team",
            //   keyboardType: TextInputType.name,
            //   textCapitalization: TextCapitalization.words,
            //   onChanged: (val) {
            //     homeStore.visitorTeamNameChange(val);
            //   },
            // ),


/// type ahed field
            // TypeAheadField<TeamModel>(
            //     hideOnEmpty: true,
            //     controller: visitorTeamController,
            //     suggestionsCallback: (search) {
            //       return homeStore.teams
            //           .where((element) => element.name!.contains(search))
            //           .toList();
            //     },
            //     onSelected: (team) {
            //       homeStore.visitorTeamNameChange(team.name!);
            //       visitorTeamController.text = team.name!;
            //     },
            //     itemBuilder: (context, team) {
            //       return ListTile(
            //         title: Text(team.name!),
            //       );
            //     },
            //     builder: (context, controller, focusNode) {
            //       return TextField(
            //         controller: visitorTeamController,
            //         focusNode: focusNode,
            //         textCapitalization: TextCapitalization.words,
            //         onChanged: (val) {
            //           homeStore.visitorTeamNameChange(val);
            //         },
            //         keyboardType: TextInputType.name,
            //         decoration: const InputDecoration(
            //           hintText: "Visitor Team",
            //         ),
            //       );
            //     }),


/// simple auto feild text
            // SimpleAutoCompleteTextField(
            //   key: key,
            //   clearOnSubmit: false,
            //   textInputAction: TextInputAction.next,
            //   controller: hostTeamController,
            //   decoration: const InputDecoration(
            //     hintText: "Host Team",
            //   ),
            //   suggestions: homeStore.teams.map((e) => e.name!).toList(),
            //   textChanged: (val) {
            //     homeStore.hostTeamNameChange(val);
            //   },
            //   textSubmitted: (val) {
            //     homeStore.hostTeamNameChange(val);
            //   },
            // ),