import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class SimpleLineChart extends StatefulWidget {
  final List<int> data;
  final int minX;
  final int minY;
  final int maxX;
  final int maxY;
  final String title;
  const SimpleLineChart(
      {super.key,
      required this.data,
      required this.minX,
      required this.minY,
      required this.maxX,
      required this.maxY,
      required this.title});

  @override
  State<StatefulWidget> createState() => SimpleLineChartState();
}

class SimpleLineChartState extends State<SimpleLineChart> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: LineChart(LineChartData(
                      rangeAnnotations: RangeAnnotations(
                          horizontalRangeAnnotations: [
                            HorizontalRangeAnnotation(
                                y1: widget.minY.toDouble(),
                                y2: 3,
                                color: Colors.red.withOpacity(0.3)),
                            HorizontalRangeAnnotation(
                                y1: 3,
                                y2: 6,
                                color:
                                    Colors.yellow.withOpacity(0.3)),
                            HorizontalRangeAnnotation(
                                y1: 6,
                                y2: widget.maxY.toDouble(),
                                color: Colors.green.withOpacity(0.3)),
                          ]),
                      lineTouchData: const LineTouchData(
                          handleBuiltInTouches: true),
                      minX: widget.minX.toDouble(),
                      maxX: widget.maxX.toDouble(),
                      minY: widget.minY.toDouble(),
                      maxY: widget.maxY.toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: const Color.fromARGB(
                              255, 255, 251, 245),
                          barWidth: 4,
                          gradient: const LinearGradient(colors: [
                            Colors.orange,
                            Colors.teal,
                            Colors.red,
                            Colors.blue
                          ]),
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                          preventCurveOverShooting: true,
                          spots: widget.data
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(),
                                  e.value.toDouble()))
                              .toList(),
                        )
                      ])),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RandomAvatar(getUserAvatarSVG(),
                      width: 44, height: 44),
                  const SizedBox(width: 12),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Welcome ",
                        style:
                            TextStyle(fontWeight: FontWeight.w800)),
                    TextSpan(text: getUserName())
                  ], style: const TextStyle(fontSize: 20))),
                  const SizedBox(width: 12),
                  TextButton.icon(
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                              Colors.orange)),
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text("Refresh")),
                ],
              ),
              const SizedBox(height: 15),
              if (!didTodaysEntry())
                makeBorderComponent(
                    color: Colors.red.shade300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_rounded, size: 32),
                        const SizedBox(width: 16),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                            text:
                                "You haven't made an entry today yet!\n",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          if (DateTime.fromMillisecondsSinceEpoch(
                                  getLastEntryTime()) !=
                              DateTime.fromMillisecondsSinceEpoch(0))
                            TextSpan(
                                text:
                                    "Last entry was made on ${fmtDateTime(DateTime.fromMillisecondsSinceEpoch(getLastEntryTime()))}",
                                style: const TextStyle(fontSize: 16))
                          else
                            const TextSpan(
                                text: "Last entry was never made",
                                style: TextStyle(fontSize: 16))
                        ]))
                      ],
                    ))
              else
                makeBorderComponent(
                    color: Colors.green.shade300,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_rounded, size: 32),
                          const SizedBox(width: 16),
                          Text.rich(TextSpan(children: [
                            const TextSpan(
                              text: "You have added today's entry\n",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const TextSpan(
                                text: "Entry was made at ",
                                style: TextStyle(fontSize: 16)),
                            TextSpan(
                                text: fmtDateTime(DateTime
                                    .fromMillisecondsSinceEpoch(
                                        getLastEntryTime()))),
                            const TextSpan(
                                text: "\n\nCheck back tomorrow!")
                          ]))
                        ])),
              const SizedBox(height: 15),
              makeBorderComponent(
                  color: Colors.blue.shade300,
                  child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 32),
                        SizedBox(width: 16),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text:
                                  "Make sure to fill out everything!\n",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                                text:
                                    "This will give you better results",
                                style: TextStyle(fontSize: 16)),
                          ]),
                          softWrap: true,
                        )
                      ])),
              const SizedBox(height: 30),
              const Text("Your stats & graphs",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              makeBorderComponent(
                child: Builder(builder: (ctxt) {
                  List<int> moodScale = [];
                  int current_i = getLastEntryIndex().toInt();
                  for (int i = 0; i <= 5; i++) {
                    if (current_i - i < 0) {
                      break;
                    }

                    moodScale.add(clampDouble(
                            value: getEntry(current_i - i.toDouble())
                                .moodScale
                                .toDouble(),
                            min: 0,
                            max: 10)
                        .toInt());
                  }
                  return SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: SimpleLineChart(
                          title: "Mood of past 5 entries",
                          data: moodScale,
                          minX: 0,
                          minY: 0,
                          maxX: 5,
                          maxY: 10));
                }),
              ),
              const SizedBox(height: 8),
              makeBorderComponent(
                child: Builder(builder: (ctxt) {
                  List<int> hoursSlept = [];
                  int current_i = getLastEntryIndex().toInt();
                  for (int i = 0; i <= 5; i++) {
                    if (current_i - i < 0) {
                      break;
                    }

                    hoursSlept.add(clampDouble(
                            value: getEntry(current_i - i.toDouble())
                                .hoursOfSleep
                                .toDouble(),
                            min: 0,
                            max: 24)
                        .toInt());
                  }
                  return SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: SimpleLineChart(
                          title: "Hours slept of past 5 entries",
                          data: hoursSlept,
                          minX: 0,
                          minY: 0,
                          maxX: 5,
                          maxY: 12));
                }),
              ),
              const SizedBox(height: 8),
              makeBorderComponent(
                child: Builder(builder: (ctxt) {
                  List<int> hoursOnScreen = [];
                  int current_i = getLastEntryIndex().toInt();
                  for (int i = 0; i <= 5; i++) {
                    if (current_i - i < 0) {
                      break;
                    }

                    hoursOnScreen.add(clampDouble(
                            value: getEntry(current_i - i.toDouble())
                                .hoursOnScreen
                                .toDouble(),
                            min: 0,
                            max: 24)
                        .toInt());
                  }
                  return SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: SimpleLineChart(
                          title: "Hours on screen of past 5 entries",
                          data: hoursOnScreen,
                          minX: 0,
                          minY: 0,
                          maxX: 5,
                          maxY: 12));
                }),
              ),
            ]),
      ),
    );
  }
}
