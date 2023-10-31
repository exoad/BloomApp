// ignore_for_file: library_private_types_in_public_api

import 'package:blosso_mindfulness/bits/parts.dart';
import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:blosso_mindfulness/bits/debug.dart';
import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((value) {
    prefs = value;
    prefs.reload();
    init().then((_) {
      runApp(_AppWrapper(
          appHome:
              !getIsNewUser() // oh fuck, dont reverse the conditions here. first time did it and got the wrong results. im too lazy to reverse the values of the resultants so just inverting the condition itself :/
                  ? const MainApp()
                  : launchCarousel()));
    });
  });
}

Widget launchDailyEntryCarousel(EphemeralTelemetry now) =>
    _InputTracker(now: now);

class _InputTracker extends StatefulWidget {
  final EphemeralTelemetry now;
  const _InputTracker({super.key, required this.now});

  @override
  State<_InputTracker> createState() => _InputTrackerState();
}

class _InputTrackerState extends State<_InputTracker> {
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
            title:
                "How many hours did you spend with family or friends?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursSpentWithFamily = e.toInt();
              },
              min: 0,
              max: 10,
              divisions: 10,
              labelConsumer: (val) => val > 12
                  ? "Greater than 12 hours"
                  : val < 1
                      ? "Less than 1 hour"
                      : "$val hours",
            )),
        makeCustomInputDetails(
            title: "How many hours of exercise did you get?",
            child: ActionableSlider(
              consumer: (e) {
                widget.now.hoursExercising = e.toInt();
              },
              min: 0,
              max: 8,
              divisions: 8,
              labelConsumer: (val) => val > 8
                  ? "Greater than 8 hours"
                  : val < 1
                      ? "Less than 1 hour"
                      : "$val hours",
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
              labelConsumer: (val) => val > 12
                  ? "Greater than 12 hours"
                  : val < 1
                      ? "Less than 1 hour"
                      : "$val hours",
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
        makeCustomInputDetails(
          title: "Tag emotions to this day",
          child: SizedBox(
            height: 200, // Adjust the height as needed
            child: Scrollbar(
              child: ListView(
                children: [
                  _buildCheckbox(
                    "Happy 😃",
                    widget.now.emotionTags.contains("happy"),
                    (val) => _handleEmotionTag("happy", val!),
                  ),
                  _buildCheckbox(
                    "Sad 😢",
                    widget.now.emotionTags.contains("sad"),
                    (val) => _handleEmotionTag("sad", val!),
                  ),
                  _buildCheckbox(
                    "Angry 😠",
                    widget.now.emotionTags.contains("angry"),
                    (val) => _handleEmotionTag("angry", val!),
                  ),
                  _buildCheckbox(
                    "Anxious 😰",
                    widget.now.emotionTags.contains("anxious"),
                    (val) => _handleEmotionTag("anxious", val!),
                  ),
                  _buildCheckbox(
                    "Depressed 😔",
                    widget.now.emotionTags.contains("depressed"),
                    (val) => _handleEmotionTag("depressed", val!),
                  ),
                  _buildCheckbox(
                    "Excited 😁",
                    widget.now.emotionTags.contains("excited"),
                    (val) => _handleEmotionTag("excited", val!),
                  ),
                  _buildCheckbox(
                    "Calm 😌",
                    widget.now.emotionTags.contains("calm"),
                    (val) => _handleEmotionTag("calm", val!),
                  ),
                  _buildCheckbox(
                    "Frustrated 😡",
                    widget.now.emotionTags.contains("frustrated"),
                    (val) => _handleEmotionTag("frustrated", val!),
                  ),
                  _buildCheckbox(
                    "Surprised 😲",
                    widget.now.emotionTags.contains("surprised"),
                    (val) => _handleEmotionTag("surprised", val!),
                  ),
                ],
              ),
            ),
          ),
        ),
        makeTextInputDetails(
            title: "Add a brief note to your entry",
            callback: (str) {
              widget.now.briefNote = str;
            })
      ],
      submissionCallback: () {
        setLastEntryIndexOneMore();
        setLastEntryTimeAsNow();
      },
    );
  }
}

Widget launchCarousel() => InputDetailsCarousel(
      firstPage: (
        title: "Let's set you up",
        hint: "Tap > for the next step"
      ),
      submissionCallback: () {
        setIsNewUser(false);
        firstTimeValidateTelemetry();
      },
      otherPages: [
        makeTextInputDetails(
            title: "What should we call you?",
            hintText: "John",
            callback: setUserName),
        makeCustomInputDetails(
            title: "What is your age range?",
            child: Center(
              child: ActionableSlider(
                consumer: setUserAgeGroup,
                min: 10,
                max: 90,
                divisions: 8,
                labelConsumer: (val) =>
                    "Age Range: ${val.toInt()}-${(val + 10).toInt()}",
              ),
            )),
        makeCustomInputDetails(
            title: "Note",
            child: const Text(
              "The following forms are just to build your profile. They are not required.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )),
        makeCustomInputDetails(
            title: "Your sex", child: const _UserSexSelection()),
        makeCustomInputDetails(
            title: "Select an avatar",
            child: const _UserSelectAvatar())
      ],
    );

class _UserSelectAvatar extends StatefulWidget {
  const _UserSelectAvatar({
    super.key,
  });

  @override
  State<_UserSelectAvatar> createState() => _UserSelectAvatarState();
}

class _UserSelectAvatarState extends State<_UserSelectAvatar> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RandomAvatar(getUserAvatarSVG(), width: 108, height: 108),
      const SizedBox(height: 40),
      TextButton.icon(
          onPressed: () {
            String svg = RandomAvatarString(
                DateTime.now().toIso8601String(),
                trBackground: false);
            setUserAvatarSVG(svg);
            setState(() {});
          },
          icon: const Icon(Icons.replay_rounded),
          label: const Text("Generate"))
    ]);
  }
}

class _UserSexSelection extends StatelessWidget {
  const _UserSexSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FemaleSex(),
          SizedBox(width: 20),
          _MaleSex(),
        ]);
  }
}

class _MaleSex extends StatefulWidget {
  const _MaleSex({
    super.key,
  });

  @override
  State<_MaleSex> createState() => _MaleSexState();
}

class _MaleSexState extends State<_MaleSex> {
  Color maleButtonColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setUserSex("male"),
      onTapDown: (details) {
        setState(() {
          maleButtonColor = Colors.blue.shade200;
        });
      },
      onTapUp: (details) {
        setState(() {
          maleButtonColor = Colors.blue;
        });
        setUserSex("male");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: maleButtonColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.male_rounded,
                size: 64,
                color: Colors.white,
              ),
              Text(
                "Male",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FemaleSex extends StatefulWidget {
  const _FemaleSex({
    super.key,
  });

  @override
  State<_FemaleSex> createState() => _FemaleSexState();
}

class _FemaleSexState extends State<_FemaleSex> {
  Color femaleButtonColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setUserSex("female"),
      onTapDown: (details) {
        setState(() {
          femaleButtonColor = Colors.pink.shade200;
        });
      },
      onTapUp: (details) {
        setState(() {
          femaleButtonColor = Colors.pink;
        });
        setUserSex("female");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: femaleButtonColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.female_rounded,
                size: 64,
                color: Colors.white,
              ),
              Text(
                "Female",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeSlider extends StatefulWidget {
  final void Function(double) consumer;
  const _AgeSlider({super.key, required this.consumer});

  @override
  State<_AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<_AgeSlider> {
  double _sliderVal = 50;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _sliderVal,
      onChanged: (val) {
        setState(() {
          _sliderVal = val;
        });
      },
      min: 10,
      max: 90,
      divisions: 9,
      allowedInteraction: SliderInteraction.tapAndSlide,
    );
  }
}

class _AppWrapper extends StatelessWidget {
  final Widget appHome;
  const _AppWrapper({super.key, required this.appHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appLaF(),
        debugShowCheckedModeBanner: false,
        home: appHome);
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _StatsPage extends StatelessWidget {
  static Widget _makeBorderComponent({required Widget child}) =>
      Container(
          decoration: const BoxDecoration(
              color: LaF.primaryColor,
              borderRadius:
                  BorderRadius.all(LaF.roundedRectBorderRadius)),
          child: Padding(
              padding: const EdgeInsets.all(10), child: child));

  @override
  Widget build(BuildContext context) {
    List<Widget> telemetryData = <Widget>[];
    int lastYear = -1;
    int lastMonth = -1;
    late bool makeNewMonthDivision;
    for (double i = 0; i <= getLastEntryIndex(); i++) {
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
                        fontSize: 18,
                        fontWeight: FontWeight.w500))
              ])),
            if (makeNewMonthDivision) const SizedBox(height: 10),
            _makeBorderComponent(
              child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "Entry: ${iTele.entryIndex}")
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
            _makeBorderComponent(
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
                                            FontWeight.normal))
                              ]))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _makeBorderComponent(
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

typedef InfoDisplayPage = ({String title, String hint});

class InputDetailsCarousel extends StatefulWidget {
  final InfoDisplayPage? firstPage;
  final List<Widget> otherPages;
  final void Function()? submissionCallback;
  const InputDetailsCarousel(
      {Key? key,
      this.firstPage,
      this.otherPages = const [],
      this.submissionCallback})
      : super(key: key);

  @override
  State<InputDetailsCarousel> createState() =>
      _InputDetailsCarouselState();
}

class _InputDetailsCarouselState extends State<InputDetailsCarousel> {
  final PageController pageController =
      PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewChildren = List.from(<Widget>[
      if (widget.firstPage != null)
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text:
                    "${widget.firstPage!.title}\n\n\n", // fuck the null checking, we can ignore after null check previous
                style: const TextStyle(
                    fontSize: 34, fontWeight: FontWeight.w800)),
            TextSpan(
              text: widget.firstPage!.hint,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ]),
          textAlign: TextAlign.center,
        ),
    ])
      ..addAll(widget.otherPages);

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 300,
            child: PageView(
              controller: pageController,
              pageSnapping: true,
              padEnds: true,
              onPageChanged: (value) => setState(() {}),
              allowImplicitScrolling: false,
              children: pageViewChildren,
            ),
          ),
          Flexible(
            flex: 0,
            child: _InputDetailsControllerRow(
                pageController: pageController,
                pageViewChildren: pageViewChildren,
                submissionCallback: widget.submissionCallback),
          ),
        ],
      ),
    );
  }
}

class _InputDetailsControllerRow extends StatefulWidget {
  const _InputDetailsControllerRow(
      {super.key,
      required this.pageController,
      required this.pageViewChildren,
      required this.submissionCallback});

  final PageController pageController;
  final List<Widget> pageViewChildren;
  final void Function()? submissionCallback;

  @override
  State<_InputDetailsControllerRow> createState() =>
      _InputDetailsControllerRowState();
}

// this works now woohoo!
class _InputDetailsControllerRowState
    extends State<_InputDetailsControllerRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: IconButton(
                onPressed: () {
                  if (widget.pageController.page! - 1 >= 0) {
                    widget.pageController
                        .animateToPage(
                          (widget.pageController.page! - 1).toInt(),
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear,
                        )
                        .then((value) => setState(
                            () {})); // most lazy repaint scheduling XD
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 32),
              ),
            ),
            Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Builder(builder: (_) {
                  // man for some reason it can have fractional pages ?!??!!?!? wtf
                  return widget.pageController.page != null &&
                          widget.pageController.page! + 1 ==
                              widget.pageViewChildren.length
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                              return const MainApp();
                            }));
                            widget.submissionCallback?.call();
                          },
                          icon: const Icon(Icons.check_rounded,
                              size: 32))
                      : const SizedBox(width: 42, height: 42);
                })), // getting this arrow to work took me way too fucking long
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: IconButton(
                onPressed: () {
                  if (widget.pageController.page! + 1 <=
                      widget.pageViewChildren.length - 1) {
                    widget.pageController
                        .animateToPage(
                          (widget.pageController.page! + 1)
                              .toInt(), // as int fails for conversions
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear,
                        )
                        .then((value) => setState(
                            () {})); // most lazy repaint scheduling XD
                  }
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (widget.pageController.page != null)
          Text(
              "${widget.pageController.page!.toInt() + 1} / ${widget.pageViewChildren.length}")
      ],
    );
  }
}

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  DateTime currentMonth = DateTime.now();
  Random random = Random();
  Map<DateTime, int?> completedPrompts = {};

  DateTime getFirstDayOfWeekForWeek(
      int weekIndex, int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    while (firstDayOfMonth.weekday != 1) {
      firstDayOfMonth =
          firstDayOfMonth.subtract(const Duration(days: 1));
    }
    return firstDayOfMonth.add(Duration(days: 7 * weekIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${DateFormat.MMMM().format(currentMonth)} ${currentMonth.year}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () {
            if (currentMonth.month > 1 ||
                currentMonth.year > DateTime.now().year) {
              setState(() {
                currentMonth = DateTime(
                    currentMonth.year, currentMonth.month - 1, 1);
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              if (currentMonth.month < DateTime.now().month ||
                  currentMonth.year < DateTime.now().year) {
                setState(() {
                  currentMonth = DateTime(
                      currentMonth.year, currentMonth.month + 1, 1);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount:
            getNumberOfWeeks(currentMonth.year, currentMonth.month),
        itemBuilder: (context, index) {
          int reverseIndex = getNumberOfWeeks(
                  currentMonth.year, currentMonth.month) -
              1 -
              index;
          DateTime firstDayOfWeek = getFirstDayOfWeekForWeek(
              reverseIndex, currentMonth.year, currentMonth.month);
          String formattedDate =
              "${firstDayOfWeek.month}-${firstDayOfWeek.day}";

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  DateTime? selectedDate = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            'Choose a day for the week of $formattedDate'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(7, (idx) {
                            DateTime day = firstDayOfWeek
                                .add(Duration(days: idx));
                            return ListTile(
                              title: Text(
                                  '${DateFormat.EEEE().format(day)} ${day.day}'),
                              onTap: () =>
                                  Navigator.pop(context, day),
                            );
                          }),
                        ),
                      );
                    },
                  );

                  if (selectedDate != null &&
                      completedPrompts[selectedDate] == null) {
                    completedPrompts[selectedDate] =
                        random.nextInt(7) + 1;
                    setState(() {});
                  }
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.green,
                      child: Center(
                          child: Text('Week of $formattedDate')),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: index == 0 ? 250.0 : 150.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/Background/Background1.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ...generateFlowersForWeek(firstDayOfWeek),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int getNumberOfWeeks(int year, int month) {
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    return ((lastDayOfMonth.day + lastDayOfMonth.weekday - 1) / 7)
        .ceil();
  }

  List<Widget> generateFlowersForWeek(DateTime startOfWeek) {
    List<Widget> flowers = [];
    List<Offset> spots = [
      const Offset(50, 150),
      const Offset(100, 150),
      const Offset(150, 150),
      const Offset(200, 150),
      const Offset(250, 150),
      const Offset(300, 150),
      const Offset(350, 150),
    ];

    DateTime day = startOfWeek;
    for (int i = 0; i < 7; i++) {
      int? flowerNum = completedPrompts[day];
      if (flowerNum != null) {
        flowers.add(
          Positioned(
            left: spots[i].dx,
            top: spots[i].dy,
            child: Image.asset('assets/Flowers/Flower$flowerNum.png',
                width: 75, height: 75),
          ),
        );
      }
      day = day.add(const Duration(days: 1));
    }
    return flowers;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasCompletedTask =
      false; //NEED TO CHANGE BASED ON IF THEY COMPLETED OR NOT

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasCompletedTask) ...[
            // Show Mood and Rating
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    'Your Mood Today: Happy', // Replace 'Happy' with actual mood data
                    style:
                        TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: 4.5/5', // Replace '4.5/5' with actual rating data
                    style:
                        TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
          ] else ...[
            // Reminder to complete the task
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.red,
              child: const Text(
                'Complete your prompts for the day or your flower won\'t be planted!',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MainAppState extends State<MainApp> {
  final PageController pageController =
      PageController(initialPage: 0);
  String appBarTitle = LaF.appName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: LaF.primaryColor,
          foregroundColor: LaF.primaryColorFgContrast,
          title: Text(
            appBarTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctxt) {
                  return Drawer(
                      child: ListView(
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                        const DrawerHeader(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color.fromARGB(255, 236, 218, 195),
                                  Color.fromARGB(255, 245, 211, 169),
                                  Color.fromARGB(255, 247, 203, 139)
                                ],
                                    stops: [
                                  0.0,
                                  0.45,
                                  0.7
                                ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Text("Actions",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24))),
                        makeListTile_SideDrawer(
                            icon: Icons.home_rounded,
                            title: "Home",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(0);
                              setState(() {
                                appBarTitle = "Bloom";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.lightbulb_rounded,
                            title: "Tips",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(1);
                              setState(() {
                                appBarTitle = "Personalized Tips";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.person_rounded,
                            title: "Profile",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(3);
                              setState(() {
                                appBarTitle = "Personal Statistics";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon:
                                Icons.settings_accessibility_rounded,
                            title: "Garden",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(2);
                              setState(() {
                                appBarTitle = "Bloom";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.change_circle_rounded,
                            title: "Change Profile",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(4);
                              setState(() {
                                appBarTitle = "Settings";
                              });
                            }),
                        if (APP_DEVELOPMENT_MODE)
                          makeListTile_SideDrawer(
                              icon: Icons.bug_report_rounded,
                              title: "APP_DEBUG",
                              onTap: () {
                                Navigator.of(context).pop();
                                _animateToPage(4);
                              })
                      ]));
                }));
              },
              icon: const Icon(Icons.menu_rounded)),
          centerTitle: true,
          primary: true,
          automaticallyImplyLeading: false,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: "Add an entry",
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctxt) => launchDailyEntryCarousel(
                    EphemeralTelemetry(getLastEntryIndex()))));
          },
          child: const Icon(Icons.add_box_rounded, size: 32),
        ),
        body: PageView(
          controller: pageController,
          pageSnapping: true,
          padEnds: false,
          allowImplicitScrolling: false,
          children: <Widget>[
            //const Page1_Home(),
            const HomePage(), // 0
            debug_wrapPageNumber(
                bg: Colors.purple, text: "Tips Page"), // 1
            GardenPage(), // 2
            _StatsPage(), // 3
            const DebuggingStuffs(), // 4
          ],
        ));
  }
}
