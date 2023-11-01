import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

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
    contentTitle: "Sleep More!",
    contentBody:
        "The American Academy of Sleep Medicine recommends over 7 hours for those ages 20 and up.",
    condition: (telemetry) =>
        telemetry.hoursOfSleep < 7 && getUserAgeGroup() >= 20,
    color: Colors.orange
  ),
  (
    source: "Columbia University of Pyschiatry",
    contentTitle: "Sleep More!",
    contentBody:
        "The American Academy of Sleep Medicine recommends over 8 hours for those ages 13-18 to have adequate energy and focus during the day.",
    condition: (telemetry) =>
        telemetry.hoursOfSleep < 8 && getUserAgeGroup() <= 18 && getUserAgeGroup() >= 13,
    color: Colors.orange
  ),
  (
    source: "Columbia University of Pyschiatry",
    contentTitle: "Sleep More!",
    contentBody:
        "The American Academy of Sleep Medicine recommends at least 9 hours of sleep for those under the age of 12 to improve mental and physical development ",
    condition: (telemetry) =>
        telemetry.hoursOfSleep < 7 && getUserAgeGroup() < 12,
    color: Colors.orange
  ),
  (
    source: "Columbia University of Psychiatry",
    contentTitle: "Try to Relax!",
    contentBody:  
      "Chronic high levels of stress can lead to serious health issues, such as weakened immune function and increased risk of heart disease. Over time, it can also contribute to mental health conditions like depression and anxiety.",
    condition: (telemetry) =>
        telemetry.howStressed > 4,
    color: Color.fromARGB(255, 147, 237, 150)
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
  (
    source: "Columbia University of Psychiatry",
    contentTitle: "Seek Quality Sleep!",
    contentBody: 
        "Ensure your room is dark and quiet for a better sleep experience. Limit screen time before bed to enhance sleep quality.",
    condition: (telemetry) => telemetry.sleepRating > 5,
    color: Colors.blueGrey
  ),
  (
    source: "",
    contentTitle: "Stay Connected!",
    contentBody:
        "Spending time with loved ones can boost your mood and provide support during challenging times.",
    condition: (telemetry) => telemetry.hoursSpentWithFamily > 2,
    color: Colors.lightBlue
  ),
  (
    source: "Columbia University of Psychiatry",
    contentTitle: "Get Active!",
    contentBody:
        "Engaging in regular physical activity can elevate mood and reduce feelings of anxiety.",
    condition: (telemetry) => telemetry.exercised == false,
    color: Colors.greenAccent
  ),
  (
    source:  "Columbia University of Psychiatry",
    contentTitle: "Nature's Boost!",
    contentBody:
        "Spending time outside can refresh your mind. Natural sunlight provides vitamin D, which is essential for many bodily functions.",
    condition: (telemetry) => telemetry.hoursOutside > 2,
    color: Colors.lightGreen
  ),
  (
    source: "Columbia University of Psychiatry",
    contentTitle: "Screen Break!",
    contentBody:
        "Extended screen time can strain your eyes. Make sure to take short breaks and reduce screen brightness in low light.",
    condition: (telemetry) => telemetry.hoursOnScreen < 3,
    color: Colors.deepPurple
  ),
  (
    source: "",
    contentTitle: "Balance is Key!",
    contentBody:
        "Taking time to relax is crucial for mental health. Consider adding relaxation techniques like meditation to your routine.",
    condition: (telemetry) => telemetry.hoursRecreational > 3,
    color: Colors.purpleAccent
  ),
  (
    source: "",
    contentTitle: "Take Breaks!",
    contentBody:
        "Long hours on work or study can be draining. Remember to take short breaks and set realistic goals.",
    condition: (telemetry) => telemetry.hoursProductive < 6,
    color: Colors.teal
  ),
  (
    source: "Columbia University of Psychiatry",
    contentTitle: "Re-energize!",
    contentBody:
        "Low energy levels can be a sign of poor nutrition or dehydration. Consider checking your diet or water intake.",
    condition: (telemetry) => telemetry.energyLevelRating > 4,
    color: Colors.yellow
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
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Row(
            children: [
              RandomAvatar(getUserAvatarSVG(), width: 32, height: 32),
              const SizedBox(width: 10),
              const Text("Recommended",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 28)),
            ],
          ),
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
          child: Row(
            children: [
              Icon(Icons.all_inbox_rounded, size: 32),
              SizedBox(width: 10),
              Text("All tips",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 28)),
            ],
          ),
        ),
        ...otherTips_Widget
      ],
    );
  }
}
