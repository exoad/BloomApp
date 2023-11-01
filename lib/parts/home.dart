import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<int> data;

  const SimpleLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    LineChartData lineChartData = LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: data.length.toDouble() - 1,
      minY: 0,
      maxY: data
          .reduce(
              (value, element) => value > element ? value : element)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: data.asMap().entries.map((entry) {
            return FlSpot(
                entry.key.toDouble(), entry.value.toDouble());
          }).toList(),
          isCurved: true,
          color: Colors.blue,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );

    return LineChart(
      lineChartData,
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
                // count from current_i to current_i -5 but handle also if current_i > 5
                int current_i = getLastEntryIndex().toInt();
                for (int i = 0; i < 5; i++) {
                  if (current_i - i < 0) {
                    break;
                  }
                  moodScale.add(
                      getEntry(current_i - i.toDouble()).moodScale);
                }
                return SizedBox(
                    height: 200,
                    child: SimpleLineChart(data: moodScale));
              })
            ]));
  }
}
