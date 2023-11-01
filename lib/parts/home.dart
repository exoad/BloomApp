import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
                height: 37,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 238, 182, 98),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: LineChart(LineChartData(
                      lineTouchData: const LineTouchData(
                          handleBuiltInTouches: true),
                      minX: widget.minX.toDouble(),
                      maxX: widget.maxX.toDouble(),
                      minY: widget.minY.toDouble(),
                      maxY: widget.maxY.toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color:
                              const Color.fromARGB(255, 238, 182, 98),
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [
                const TextSpan(
                    text: "Welcome ",
                    style: TextStyle(fontWeight: FontWeight.w800)),
                TextSpan(text: getUserName())
              ], style: const TextStyle(fontSize: 20))),
              const SizedBox(height: 15),
              Builder(builder: (ctxt) {
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
                    height: 400,
                    width: double.infinity,
                    child: SimpleLineChart(
                        title: "Mood of past 5 entries",
                        data: moodScale,
                        minX: 0,
                        minY: 0,
                        maxX: 5,
                        maxY: 10));
              })
            ]));
  }
}
