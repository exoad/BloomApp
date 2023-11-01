import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> telemetryData = <Widget>[];
    int lastYear = -1;
    int lastMonth = -1;
    late bool makeNewMonthDivision;
    for (double i = getLastEntryIndex() - 1; i >= 0; i--) {
      EphemeralTelemetry iTele = getEntry(i);
      DateTime iTeleTimeStamp =
          DateTime.fromMillisecondsSinceEpoch(iTele.entryTimeEpochMS);
      if (lastYear == -1 || lastMonth == -1) {
        lastYear = iTeleTimeStamp.year;
        lastMonth = iTeleTimeStamp.month;
        makeNewMonthDivision = true;
      } else {
        if (lastMonth != iTeleTimeStamp.month) {
          lastMonth = iTeleTimeStamp.month;
          makeNewMonthDivision = true;
        } else {
          makeNewMonthDivision = false;
        }
      }
      telemetryData.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (makeNewMonthDivision)
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: monthNumToName(lastMonth),
                    style: TextStyle(
                        color: monthColor(lastMonth),
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                TextSpan(
                    text: " $lastYear",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500))
              ])),
            if (makeNewMonthDivision) const SizedBox(height: 10),
            makeBorderComponent(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text:
                                "Entry: ${DateTime.fromMillisecondsSinceEpoch(iTele.entryTimeEpochMS).month} / ${DateTime.fromMillisecondsSinceEpoch(iTele.entryTimeEpochMS).day}\n\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        const TextSpan(
                            text: "Mood Rating:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.moodScale == -1 ? "??" : iTele.moodScale} / 10\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Hours of sleep:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.hoursOfSleep == -1 ? "??" : actionableSliderHoursContext(1, 12, iTele.hoursOfSleep.toDouble())}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Sleep quality rating:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.sleepRating == -1 ? "??" : iTele.sleepRating} / 10\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Hours spent with family:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.hoursSpentWithFamily == -1 ? "??" : actionableSliderHoursContext(1, 12, iTele.hoursSpentWithFamily.toDouble())}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Exercised:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.exercised ? "Yes" : "No"}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Hours on screen:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.hoursOnScreen == -1 ? "??" : actionableSliderHoursContext(1, 12, iTele.hoursOnScreen.toDouble())}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "How stressed were you:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.howStressed == -1 ? "??" : iTele.howStressed}/10\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Recreational hours:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.hoursRecreational == -1 ? "??" : actionableSliderHoursContext(1, 10, iTele.hoursRecreational.toDouble())}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Energy level rating:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.energyLevelRating == -1 ? "??" : iTele.energyLevelRating}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Productive hours:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.hoursProductive == -1 ? "??" : actionableSliderHoursContext(1, 10, iTele.hoursProductive.toDouble())}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Hours spent outside:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${iTele.hoursOutside == -1 ? "??" : actionableSliderHoursContext(1, 10, iTele.hoursOutside.toDouble())}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Brief note:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: "${iTele.briefNote}\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text: "Entry time:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: fmtDateTime(
                                DateTime.fromMillisecondsSinceEpoch(
                                    iTele.entryTimeEpochMS)),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                      ]))
                    ]),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            makeBorderComponent(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 0,
                        child: RandomAvatar(getUserAvatarSVG(),
                            height: 134, width: 134),
                      ),
                      const SizedBox(width: 40),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              children: [
                                Text(getUserName(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 28)),
                                const SizedBox(height: 6),
                                Text.rich(
                                    TextSpan(children: [
                                      const TextSpan(
                                          text: "Gender: ",
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.w800)),
                                      TextSpan(
                                        text: (getUserSex() ==
                                                "female"
                                            ? "♀️ Female"
                                            : getUserSex() == "male"
                                                ? "♂️ Male"
                                                : "❓ Not specified"),
                                      )
                                    ]),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.normal)),
                                const SizedBox(height: 6),
                                Text.rich(
                                    TextSpan(children: [
                                      const TextSpan(
                                          text: "Age Range: ",
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.w800)),
                                      TextSpan(
                                        text:
                                            "${getUserAgeGroup().toInt()}-${getUserAgeGroup().toInt() + 10}",
                                      )
                                    ]),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.normal)),
                                const SizedBox(height: 6),
                                TextButton.icon(
                                    style: const ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.all(LaF
                                                        .roundedRectBorderRadius))),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black)),
                                    onPressed: () {
                                      removeAllEntries();
                                      setLastEntryIndex(0);
                                      setLastEntryTime(DateTime
                                          .fromMillisecondsSinceEpoch(
                                              0));
                                    },
                                    label: const Text("Reset Entries",
                                        style: TextStyle(
                                            color: LaF.primaryColor,
                                            fontWeight:
                                                FontWeight.w700)),
                                    icon: const Icon(
                                        Icons.replay_rounded,
                                        color: LaF.primaryColor))
                              ]))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            makeBorderComponent(
                child: SizedBox(
                    width: double.infinity,
                    child: Text.rich(TextSpan(children: [
                      const TextSpan(
                          text: "Statistics\n",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const TextSpan(
                          text: "Last Entry Time: ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: fmtDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  getLastEntryTime())),
                          style: const TextStyle(fontSize: 18)),
                      const TextSpan(
                          text: "\nTotal entries: ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      TextSpan(
                          text:
                              getLastEntryIndex().toInt().toString(),
                          style: const TextStyle(fontSize: 18))
                    ])))),
            const SizedBox(height: 10),
            if (getLastEntryIndex() == 0)
              const Text.rich(TextSpan(children: [
                TextSpan(
                    text: "No entries found!",
                    style: TextStyle(
                        color: Color.fromARGB(150, 180, 180, 180),
                        fontWeight: FontWeight.w800,
                        fontSize: 24))
              ]))
            else
              ...telemetryData
          ],
        ),
      ),
    );
  }
}
