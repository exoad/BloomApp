// ignore_for_file: use_build_context_synchronously

import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  GardenPageState createState() => GardenPageState();
}

class GardenPageState extends State<GardenPage> {
  DateTime currentMonth = DateTime.now();
  Map<DateTime, bool> completedPrompts = {DateTime.now(): true};

  DateTime getFirstDayOfWeekForWeek(
      int weekIndex, int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    while (firstDayOfMonth.weekday != DateTime.monday) {
      firstDayOfMonth =
          firstDayOfMonth.subtract(const Duration(days: 1));
    }
    return firstDayOfMonth.add(Duration(days: 7 * weekIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LaF.primaryColor,
        foregroundColor: Colors.black,
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
        physics: const BouncingScrollPhysics(),
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
                        backgroundColor: LaF.primaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                LaF.roundedRectBorderRadius)),
                        title: Text(
                            'Choose a day for week $formattedDate',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(6, (idx) {
                            DateTime day = firstDayOfWeek
                                .add(Duration(days: idx));
                            return ListTile(
                                title: Text(
                                    '${DateFormat.EEEE().format(day)}, ${day.day}',
                                    style: const TextStyle(
                                        fontSize: 16)),
                                onTap: () => {
                                      Navigator.of(context).pop(day),
                                    });
                          }),
                        ),
                      );
                    },
                  );
                  if (selectedDate != null) {
                    bool entryExists =
                        isEntryThereByDay(selectedDate);
                    print("ENTRY_EXISTS $entryExists\n");
                    if (!entryExists) {
                      bool completedTracker =
                          isEntryThereByDay(selectedDate);
                      if (completedTracker) {
                        setState(() {
                          completedPrompts[selectedDate] = true;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'An entry already exists for this date.'),
                        ),
                      );
                    }
                  }
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.green.shade300,
                      child: Center(
                          child: Text('Week of $formattedDate',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16))),
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
}
