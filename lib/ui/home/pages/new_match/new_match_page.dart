import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/enum/opted_type.dart';
import 'package:cric_spot/core/enum/team_type.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    final homeStore = getIt.get<HomeStore>();
    homeStore.getAllData();
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
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            AutoCompleteTextField<TeamModel>(
                key: hostkey,
                controller: hostTeamController,
                clearOnSubmit: false,
                textInputAction: TextInputAction.next,
                suggestions: homeStore.teams,
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
                  homeStore.hostTeamNameChange(val);
                },
                itemSubmitted: (team) {
                  hostTeamController.text = team.name!;
                  homeStore.hostTeamNameChange(team.name!);
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
            Observer(builder: (_) {
              return homeStore.hostTeamNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          homeStore.hostTeamNameError!,
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
                suggestions: homeStore.teams,
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
                  homeStore.visitorTeamNameChange(val);
                },
                itemSubmitted: (team) {
                  visitorTeamController.text = team.name!;
                  homeStore.visitorTeamNameChange(team.name!);
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
            Observer(builder: (_) {
              return homeStore.visitorTeamNameError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          homeStore.visitorTeamNameError!,
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
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            Observer(builder: (_) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        homeStore.tossWon(TeamType.host);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: TeamType.host,
                                groupValue: homeStore.tossWonBy,
                                onChanged: (value) {
                                  homeStore.tossWon(value);
                                }),
                            Observer(builder: (_) {
                              return Text(homeStore.hostTeamName == ""
                                  ? "Host Team"
                                  : homeStore.hostTeamName);
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        homeStore.tossWon(TeamType.visitor);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: TeamType.visitor,
                                groupValue: homeStore.tossWonBy,
                                onChanged: (value) {
                                  homeStore.tossWon(value);
                                }),
                            Observer(builder: (_) {
                              return Text(homeStore.visitorTeamName == ""
                                  ? "Visitor Team"
                                  : homeStore.visitorTeamName);
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
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            Observer(builder: (_) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        homeStore.optedBy(OptedType.bat);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: OptedType.bat,
                                groupValue: homeStore.opted,
                                onChanged: (value) {
                                  homeStore.optedBy(value);
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
                        homeStore.optedBy(OptedType.bowl);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Radio(
                                value: OptedType.bowl,
                                groupValue: homeStore.opted,
                                onChanged: (value) {
                                  homeStore.optedBy(value);
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
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: overController,
              hintText: "Overs",
              keyboardType: TextInputType.number,
              onChanged: (val) {
                homeStore.over = val;
                homeStore.overError = null;
              },
            ),
            Observer(builder: (_) {
              return homeStore.overError == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          homeStore.overError!,
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
                        GoRouter.of(context)
                            .push(RoutesName.adwanceSetting.path);
                      },
                      child: const Text("Adwance Setting")),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: FilledButton(
                        onPressed: () {
                          homeStore.isMatchNew = true;
                          // GoRouter.of(context).push(RoutesName.scoreCount.path);
                          homeStore.validate();
                          if (homeStore.canStartMatch) {
                            GoRouter.of(context)
                                .push(RoutesName.playerSelect.path);
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