import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_modal.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/model/team/team_model.dart';
import 'package:cric_spot/store/team/team_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class TeamsPage extends StatelessWidget {
  TeamsPage({super.key});

  final TextEditingController teamNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final teamStore = getIt.get<TeamStore>();

  @override
  Widget build(BuildContext context) {
    teamStore.teams();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Observer(builder: (_) {
          return ListView.builder(
              itemCount: teamStore.teamModelList.length,
              itemBuilder: (context, index) {
                return teamCard(context, teamStore.teamModelList[index]);
              });
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FocusScope.of(context).requestFocus(_focusNode);
          showAddTeamModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddTeamModal(BuildContext context, {TeamModel? team}) {
    cricAlertDialog(context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CricTextFormField(
              focusNode: _focusNode,
              controller: teamNameController,
              hintText: "Team name",
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        title: const Text("Create New Team"),
        confirmationButton: TextButton(
          onPressed: () {
            if (team == null) {
              teamStore.addTeam(TeamModel(
                  name: teamNameController.text, match: 0, win: 0, loss: 0));
            } else {
              team.name = teamNameController.text;
              teamStore.updateTeam(team);
            }

            teamNameController.clear();
            GoRouter.of(context).pop();
          },
          child: const Text('OK'),
        ),
        cancelButton: TextButton(
          onPressed: () {
            teamNameController.clear();
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ));

    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void deleteDialog(BuildContext context, int key) {
    cricAlertDialog(context,
        child: const Text("You want to delete"),
        title: const Text("Are you sure?"),
        confirmationButton: TextButton(
            onPressed: () {
              teamStore.removeTeam(key);
              GoRouter.of(context).pop();
            },
            child: const Text('Delete')));
  }

  Card teamCard(BuildContext context, TeamModel team) {
    print(team.id);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Image.network(
                  "https://d1muf25xaso8hp.cloudfront.net/https%3A%2F%2Fmeta-q.cdn.bubble.io%2Ff1512936020165x278911292087286720%2FA.png?w=&h=&auto=compress&dpr=1&fit=max"),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name ?? '',
                    style: context.titleMedium,
                  ),
                  Text(
                    "Match: ${team.match}",
                    style: context.bodySmall,
                  ),
                  Text(
                    "Won: ${team.win}  Loss: ${team.loss}",
                    style: context.bodySmall,
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  teamNameController.text = team.name!;
                  showAddTeamModal(context, team: team);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  deleteDialog(context, int.parse(team.id!));
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
