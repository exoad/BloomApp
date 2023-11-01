import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:flutter/material.dart';

Widget launchDailyEntryCarousel(EphemeralTelemetry now) =>
    _InputWrapper(now: now);

class _InputWrapper extends StatelessWidget {
  final EphemeralTelemetry now;
  const _InputWrapper({super.key, required this.now});

  @override
  Widget build(BuildContext context) {
    return didTodaysEntry()
        ? const InputDetailsCarousel(
            firstPage: (
              title: "You already added an entry for today",
              hint: "You may only add one entry per day"
            ),
          )
        : InputTracker(now: now);
  }
}

class InputTracker extends StatefulWidget {
  final EphemeralTelemetry now;
  const InputTracker({super.key, required this.now});

  @override
  State<InputTracker> createState() => _InputTrackerState();
}

class _InputTrackerState extends State<InputTracker> {
  Widget _buildCheckbox(
      String label, bool value, void Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  void _handleEmotionTag(String tag, bool value) {
    if (value) {
      widget.now.emotionTags += "$tag,";
    } else {
      widget.now.emotionTags =
          widget.now.emotionTags.replaceAll("$tag,", "");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InputDetailsCarousel(
      firstPage: const (
        title: "Adding Entry",
        hint:
            "This tracker will help you input the right data for an entry."
      ),
      otherPages: [
        makeCustomInputDetails(
            title: "How many hours of sleep did you get last night?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursOfSleep = e.toInt();
              },
              min: 0,
              max: 13,
              divisions: 13,
              labelConsumer: (val) => val > 12
                  ? "Greater than 12 hours"
                  : val < 1
                      ? "Less than 1 hour"
                      : "$val hours",
            )),
        makeCustomInputDetails(
            title: "Rate your sleep quality",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.sleepRating = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (e) => e <= 3
                  ? "🙁 Poor"
                  : e >= 4 && e <= 6
                      ? "😐 Decent"
                      : "😄 Good",
            )),
        makeCustomInputDetails(
            title: "Rate your energy level",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.energyLevelRating = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (e) => e <= 3
                  ? "🙁 Poor"
                  : e >= 4 && e <= 6
                      ? "😐 Decent"
                      : "😄 Good",
            )),
        makeCustomInputDetails(
            title:
                "How many hours did you spend with family or friends?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursSpentWithFamily = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (val) =>
                  actionableSliderHoursContext(1, 10, val),
            )),
        makeCustomInputDetails(
            title: "Did you exercise?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.exercised = e == 1;
              },
              min: 0,
              max: 1,
              divisions: 1,
              labelConsumer: (val) => val == 1
                  ? "Yes, I exercised"
                  : "No, I did not exercise",
            )),
        makeCustomInputDetails(
            title: "How many hours did you spend outside?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursOutside = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (val) =>
                  actionableSliderHoursContext(1, 10, val),
            )),
        makeCustomInputDetails(
            title: "How many hours did you spend being productive?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursProductive = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (val) =>
                  actionableSliderHoursContext(1, 10, val),
            )),
        makeCustomInputDetails(
            title: "How many hours did you spend recreationally?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursRecreational = e.toInt();
              },
              min: 0,
              max: 8,
              divisions: 8,
              labelConsumer: (val) =>
                  actionableSliderHoursContext(1, 8, val),
            )),
        makeCustomInputDetails(
            title: "How many hours were you on an electronic device?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursOnScreen = e.toInt();
              },
              min: 0,
              max: 13,
              divisions: 13,
              labelConsumer: (val) =>
                  actionableSliderHoursContext(1, 12, val),
            )),
        makeCustomInputDetails(
            title: "How stressed were you?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.howStressed = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (e) => e >= 7
                  ? "🙁 Very stressed"
                  : e >= 4 && e <= 6
                      ? "😐 Kind of stressed"
                      : "😄 Not really stressed",
            )),
        makeCustomInputDetails(
            title: "Rate your day",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.moodScale = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (e) => e <= 3
                  ? "🙁 Dpressing"
                  : e >= 4 && e <= 6
                      ? "😐 It was ok"
                      : "😄 Memorable",
            )),
        makeTextInputDetails(
            title: "Add a brief note to your entry",
            callback: (str) {
              widget.now.briefNote = str;
            })
      ],
      submissionCallback: () {
        insertEntry(widget.now);
        setLastEntryTimeAsNow();
      },
    );
  }
}
