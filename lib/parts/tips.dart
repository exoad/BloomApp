import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:flutter/material.dart';

typedef Tip = ({
  String source,
  String contentTitle,
  String contentBody,
  bool Function(EphemeralTelemetry telemetry) condition,
  Color color
});

final List<Tip> _tipsData = <Tip>[
  (
    source: "Columbia University of Pyschiatry",
    contentTitle: "Sleep well",
    contentBody:
        "The American Academy of Sleep Medicine recommends ... over 7 hours for those ages 20 and up.",
    condition: (telemetry) =>
        telemetry.hoursOfSleep < 7 && getUserAgeGroup() >= 20,
    color: Colors.orange
  ),
  (
    source: "Columbia University of Pyschiatry",
    contentTitle: "Be Nice to Yourself",
    contentBody:
        "If you really are struggling to be nice to yourself, do something nice for someone else. Then, compliment yourself on doing it!",
    condition: (telemetry) => telemetry.moodScale < 6,
    color: Colors.red
  ),
  (
    source: "Columbia University of Pyschiatry",
    contentTitle: "Sleep well",
    contentBody:
        "The American Academy of Sleep Medicine recommends between 8-10 hours of sleep per night for teenagers.",
    condition: (telemetry) =>
        telemetry.hoursOfSleep < 8 && getUserAgeGroup() < 20,
    color: Colors.orange
  ),
];

Widget _makeTipBox(Tip tip) {
  return Padding(
      padding: const EdgeInsets.all(15),
      child: makeBorderComponent(
          color: tip.color,
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: tip.contentTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const TextSpan(
              text: "\n\n",
            ),
            TextSpan(
              text: tip.contentBody,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const TextSpan(
              text: "\n\n",
            ),
            TextSpan(
              text: "Source: ${tip.source}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ]))));
}

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> recommendedTips_Widget = [];
    List<Widget> otherTips_Widget = [];
    EphemeralTelemetry currentTelemetry =
        EphemeralTelemetry(getLastEntryIndex());
    for (var element in _tipsData) {
      if (element.condition(currentTelemetry)) {
        recommendedTips_Widget.add(_makeTipBox(element));
      } else {
        otherTips_Widget.add(_makeTipBox(element));
      }
    }

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Text("Recommended",
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 28)),
        ),
        if (recommendedTips_Widget.isEmpty)
          const Text.rich(TextSpan(children: [
            TextSpan(
                text: "No recommended tips",
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(
                text:
                    "\nWe will recommend you tips when you need it\nOther wise scroll down to see all the avaliable tips!",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic))
          ]))
        else
          ...recommendedTips_Widget,
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Text("All tips",
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 28)),
        ),
        ...otherTips_Widget
      ],
    );
  }
}
