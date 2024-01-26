import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/model/bowling/bowling_lineup_model.dart';
import 'package:cric_spot/store/score/score_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class SelectBowlerPage extends StatelessWidget {
  const SelectBowlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<AutoCompleteTextFieldState<BowlingLineUpModel>> bowlerKey =
        GlobalKey();
    TextEditingController bowlerController = TextEditingController();

    final scoreStore = getIt.get<ScoreStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bowler'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Select a new bowler",
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            // TypeAheadField<BowlingLineUpModel>(
            //     hideOnEmpty: true,
            //     suggestionsCallback: (search) {
            //       return scoreStore.currentInning!.bowlingLineup!
            //           .where((element) => element.name!.contains(search))
            //           .toList();
            //     },
            //     onSelected: (bowler) {
            //       scoreStore.newBowler = bowler.name!;
            //     },
            //     itemBuilder: (context, bowler) {
            //       return ListTile(
            //         title: Text(bowler.name!),
            //         subtitle: Text("${bowler.ball! ~/ 6}.${bowler.ball! % 6}"),
            //       );
            //     },
            //     builder: (context, controller, focusNode) {
            //       return TextField(
            //         controller: controller,
            //         focusNode: focusNode,
            //         textCapitalization: TextCapitalization.words,
            //         onChanged: (val) {
            //           scoreStore.newBowler = val;
            //         },
            //         keyboardType: TextInputType.name,
            //         decoration: const InputDecoration(
            //           hintText: "Player name",
            //         ),
            //       );
            //     }),
            AutoCompleteTextField<BowlingLineUpModel>(
                key: bowlerKey,
                controller: bowlerController,
                clearOnSubmit: false,
                textInputAction: TextInputAction.next,
                suggestions: scoreStore.currentInning!.bowlingLineup!,
                keyboardType: TextInputType.name,
                cursorColor: context.primary,
                cursorWidth: 3,
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: "Bowler name",
                ),
                itemBuilder: (context, bowler) {
                  return ListTile(
                    title: Text(bowler.name!),
                    subtitle: Text("${bowler.ball! ~/ 6}.${bowler.ball! % 6}"),
                  );
                },
                textChanged: (val) {
                  scoreStore.newBowler = val;
                },
                itemSubmitted: (bowler) {
                  bowlerController.text = bowler.name!;
                  scoreStore.newBowler = bowler.name!;
                  return bowler.name!;
                },
                itemSorter: (a, b) => a.name == b.name
                    ? 0
                    : int.parse(a.playerId!) > int.parse(b.playerId!)
                        ? -1
                        : 1,
                itemFilter: (team, input) {
                  return team.name!.contains(input);
                }),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: Observer(builder: (_) {
                return FilledButton(
                    onPressed: scoreStore.newBowler == ''
                        ? null
                        : () async {
                            await scoreStore.selectNewBowler();
                            if (!context.mounted) return;
                            GoRouter.of(context).pop();
                          },
                    child: const Text("Done"));
              }),
            )
          ],
        ),
      ),
    );
  }
}
