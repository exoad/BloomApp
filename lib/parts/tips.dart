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
    source: "Columbia University of Psychiatry",
    contentTitle: "Try to Relax!",
    contentBody:
        "Chronic high levels of stress can lead to serious health issues, such as weakened immune function and increased risk of heart disease. Over time, it can also contribute to mental health conditions like depression and anxiety.",
    condition: (telemetry) =>
        telemetry.howStressed >= 4 && telemetry.howStressed != -1,
    color: const Color.fromARGB(255, 147, 237, 150)
  ),
  (
    source: "Columbia University of Psychiatry",
    contentTitle: "Be Nice to Yourself",
    contentBody:
        "If you really are struggling to be nice to yourself, do something nice for someone else. Then, compliment yourself on doing it!",
    condition: (telemetry) =>
        telemetry.moodScale < 6 && telemetry.moodScale != -1,
    color: Colors.red
  ),
  (
    source: "National Institute of Health",
    contentTitle: "Sleep well",
    contentBody:
        "The American Academy of Sleep Medicine recommends between 8-10 hours of sleep per night for teenagers.",
    condition: (telemetry) =>
        telemetry.hoursOfSleep <= 8 &&
        getUserAgeGroup() < 20 &&
        telemetry.hoursOfSleep != -1,
    color: Colors.orange
  ),
  (
    source: "National Institute of Health",
    contentTitle: "Seek Quality Sleep!",
    contentBody:
        "Ensure your room is dark and quiet for a better sleep experience. Limit screen time before bed to enhance sleep quality.",
    condition: (telemetry) =>
        telemetry.sleepRating <= 5 && telemetry.hoursOfSleep != -1,
    color: Colors.blueGrey
  ),
  (
    source: "National Institute of Health",
    contentTitle: "Stay Connected!",
    contentBody:
        "Spending time with loved ones can boost your mood and provide support during challenging times.",
    condition: (telemetry) =>
        telemetry.hoursSpentWithFamily <= 2 &&
        telemetry.hoursSpentWithFamily != -1,
    color: Colors.lightBlue
  ),
  (
    source: "Center for disease Control",
    contentTitle: "Get Active!",
    contentBody:
        "Engaging in regular physical activity can elevate mood, reduce feelings of anxiety, and improve your cognitive health",
    condition: (telemetry) => telemetry.exercised == true,
    color: Colors.greenAccent
  ),
  (
    source: "United States Forest Service",
    contentTitle: "Nature's Boost!",
    contentBody:
        "Spending time outside can refresh your mind. Natural sunlight provides vitamin D, which is essential for many bodily functions.",
    condition: (telemetry) =>
        telemetry.hoursOutside < 2 && telemetry.hoursOutside != -1,
    color: Colors.lightGreen
  ),
  (
    source: "Harvard Medical School",
    contentTitle: "Screen Break!",
    contentBody:
        "Extended screen time can strain your eyes. Make sure to take short breaks and reduce screen brightness in low light.",
    condition: (telemetry) =>
        telemetry.hoursOnScreen >= 3 && telemetry.hoursOnScreen != -1,
    color: Colors.deepPurple
  ),
  (
    source: "Harvard Medical School",
    contentTitle: "Balance is Key!",
    contentBody:
        "Taking time to relax is crucial for mental health. Consider adding relaxation techniques like meditation to your routine.",
    condition: (telemetry) =>
        telemetry.hoursRecreational < 3 &&
        telemetry.hoursRecreational != -1,
    color: Colors.purpleAccent
  ),
  (
    source: "Mayo Clinic",
    contentTitle: "Take Breaks!",
    contentBody:
        "Long hours on work or study can be draining. Remember to take short breaks and set realistic goals.",
    condition: (telemetry) => telemetry.hoursProductive < 6 && telemetry.hoursProductive != -1,
    color: Colors.teal
  ),
  (
    source: "Mayo Clinic",
    contentTitle: "Re-energize!",
    contentBody:
        "Low energy levels can be a sign of poor nutrition, dehydration, or sleep. Consider checking your diet or water intake and getting more sleep.",
    condition: (telemetry) =>
        telemetry.energyLevelRating < 4 &&
        telemetry.hoursOfSleep != -1,
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
        getEntry(getLastEntryIndex() - 1);
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
