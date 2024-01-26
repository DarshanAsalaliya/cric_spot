import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:cric_spot/main.dart';
import 'package:cric_spot/store/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AdwanceSettingPage extends StatelessWidget {
  const AdwanceSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeStore = getIt.get<HomeStore>();
    TextEditingController playerPerMatchController = TextEditingController();
    TextEditingController noBallRunController = TextEditingController();
    TextEditingController wideBallRunController = TextEditingController();
    playerPerMatchController.text = homeStore.playerPerMatch;
    noBallRunController.text = homeStore.noBallRun;
    wideBallRunController.text = homeStore.wideBallRun;

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
              style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: context.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            CricTextFormField(
              controller: playerPerMatchController,
              hintText: "11",
              keyboardType: TextInputType.number,
              onChanged: (val) {
                homeStore.playerPerMatch = val;
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
                  style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: context.onBackground),
                ),
                Observer(builder: (context) {
                  return Switch(
                      value: homeStore.isNoBall,
                      onChanged: (value) {
                        homeStore.isNoBall = value;
                      });
                })
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Observer(builder: (_) {
              return homeStore.isNoBall
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
                                Observer(builder: (context) {
                                  return Switch(
                                      value: homeStore.noBallReBall,
                                      onChanged: (value) {
                                        homeStore.noBallReBallSwitch(value);
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
                                      homeStore.noBallRun = val;
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
                  style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: context.onBackground),
                ),
                Observer(builder: (context) {
                  return Switch(
                      value: homeStore.isWideBall,
                      onChanged: (value) {
                        homeStore.isWideBall = value;
                      });
                })
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Observer(builder: (_) {
              return homeStore.isWideBall
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
                                Observer(builder: (context) {
                                  return Switch(
                                      value: homeStore.wideReBall,
                                      onChanged: (value) {
                                        homeStore.wideBallReBallSwitch(value);
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
                                      homeStore.wideBallRun = val;
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
            FilledButton(onPressed: () {}, child: const Text("Save Setting"))
          ],
        ),
      ),
    );
  }
}
