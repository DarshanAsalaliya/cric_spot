import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/model/partnership/partnership_model.dart';
import 'package:flutter/material.dart';

Widget batsmanScoreWidget({
  String? batsmanName,
  int? run,
  int? ball,
  int? four,
  int? six,
  required BuildContext context,
}) {
  return Row(
    children: [
      Expanded(child: Text(batsmanName ?? "Batsman")),
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${run ?? 'R'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${ball ?? 'B'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${four ?? '4s'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${six ?? '6s'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.13,
            child: Text(
              ball == null
                  ? 'SR'
                  : ball == 0
                      ? "0.00"
                      : ((run! * 100) / ball).toStringAsFixed(2),
              textAlign: TextAlign.end,
            ),
          )
        ],
      )
    ],
  );
}

Widget bowlerScoreWidget({
  String? bowlerName,
  int? ball,
  int? maidan,
  int? run,
  int? wicket,
  required BuildContext context,
}) {
  return Row(
    children: [
      Expanded(child: Text(bowlerName ?? "Bowler")),
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${ball == null ? 'O' : (ball ~/ 6)}.${(ball! % 6)}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${maidan ?? 'M'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${run ?? 'R'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.11,
            child: Text(
              "${wicket ?? 'W'}",
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.13,
            child: Text(
              ball == null
                  ? 'ER'
                  : ball == 0
                      ? "0.00"
                      : (run! / (ball / 6)).toStringAsFixed(1),
              textAlign: TextAlign.end,
            ),
          )
        ],
      )
    ],
  );
}

Widget playerPartnershipWidget(BuildContext context, PartnerShipModel part) {
  return Column(
    children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                part.currentStiker!.name!,
                style: context.titleLarge,
              ),
              Text("${part.currentStiker!.run} (${part.currentStiker!.ball})",
                  style: context.titleLarge)
            ],
          ),
          Column(
            children: [
              Text(part.run.toString(),
                  style: context.headlineLarge
                      ?.copyWith(color: context.onPrimaryContainer)),
              Text(
                "(${part.ball})",
                style: context.headlineSmall
                    ?.copyWith(color: context.onSurfaceVariant),
              )
            ],
          ),
          Column(
            children: [
              Text(
                part.currentNotStiker!.name!,
                style: context.titleLarge,
              ),
              Text(
                  "${part.currentNotStiker!.run} (${part.currentNotStiker!.ball})",
                  style: context.titleLarge)
            ],
          )
        ],
      ),
      const Divider(),
    ],
  );
}
