// ignore_for_file: library_private_types_in_public_api

import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:blosso_mindfulness/bits/debug.dart';
import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:blosso_mindfulness/bits/consts.dart';
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
                  : InputDetailsCarousel(
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
                              child: Slider(
                                value: 20,
                                onChanged: (val) {},
                                min: 10,
                                max: 90,
                                allowedInteraction:
                                    SliderInteraction.tapAndSlide,
                              ),
                            ))
                      ],
                    )));
    });
  });
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
  @override
  Widget build(BuildContext context) {
    List<Widget> telemetryData = <Widget>[];

    for (int i = 0; i < getLastEntryIndex(); i++) {
      telemetryData
          .add(Text("Index: ${getEntry(i.toDouble())?.entryIndex}"));
    }
    return Padding(
      padding: const EdgeInsets.all(18),
      child: CustomScrollView(slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return telemetryData[
              index]; // dangerous area if we dont have the valid delegates for the required widgets fed into the stats tree
        }, childCount: telemetryData.length))
      ]),
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
    return Flex(
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
                      icon: const Icon(Icons.check_rounded, size: 32))
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
            icon:
                const Icon(Icons.arrow_forward_ios_rounded, size: 32),
          ),
        ),
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
  DateTime getFirstDayOfWeekForWeek(int weekIndex, int year, int month) {
        DateTime firstDayOfMonth = DateTime(year, month, 1);
        int daysToSkip = weekIndex * 7;  // 7 days per week
        return firstDayOfMonth.add(Duration(days: daysToSkip));
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${DateFormat.MMMM().format(currentMonth)} ${currentMonth.year}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () {
            setState(() {
              currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}), // This will refresh the page and replant the flowers
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: getNumberOfWeeks(currentMonth.year, currentMonth.month),
        itemBuilder: (context, index) {
          DateTime firstDayOfWeek = getFirstDayOfWeekForWeek(index, currentMonth.year, currentMonth.month);
          String formattedDate = "${firstDayOfWeek.month}-${firstDayOfWeek.day}";
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.green,  // or any color you prefer
                child: Center(child: Text('Week of $formattedDate')),
              ),
              Stack(
                children: [
                  Container(
                    height: 150.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Background/Background1.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ...generateFlowers(),  // Spread operator to put the list of flowers onto the stack
                ],
              ),
            ],
          );
        },
      ),
      
    );
  }
  
  int getNumberOfWeeks(int year, int month) {
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    int weekdayOfFirst = DateTime(year, month, 1).weekday;
    int weekdayOfLast = lastDayOfMonth.weekday;
    int daysInFirstWeek = 8 - weekdayOfFirst;
    int daysInLastWeek = weekdayOfLast;
    int daysInBetween = lastDayOfMonth.day - daysInFirstWeek - daysInLastWeek;
    return (daysInBetween / 7).ceil() + 2;
  }

  List<Widget> generateFlowers() {
    List<Widget> flowers = [];

    // Defining 7 spots for the flowers on the background
    List<Offset> spots = [
      const Offset(50, 100),
      const Offset(100, 100),
      const Offset(150, 100),
      const Offset(200, 100),
      const Offset(250, 100),
      const Offset(300, 100),
      const Offset(350, 100),
    ];

    for (var spot in spots) {
      int flowerNum = random.nextInt(7) + 1; // Random number between 1 and 7
      flowers.add(
      
        Positioned(
          left: spot.dx,
          top: spot.dy,
          child: Image.asset('assets/Flowers/Flower$flowerNum.png', width: 50, height: 50), // Adjust width and height as needed
        ),
      );
    }

    return flowers;
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  bool hasCompletedTask = false; //NEED TO CHANGE BASED ON IF THEY COMPLETED OR NOT

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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: 4.5/5', // Replace '4.5/5' with actual rating data
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                'Complete your prompts for the day or your tree won\'t be planted!',
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
                            icon: Ionicons.chatbubble,
                            title: "Chat",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(6);
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
                                appBarTitle = "Bloom";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.calculate_rounded,
                            title: "Statistics",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(3);
                              setState(() {
                                appBarTitle = "Bloom";
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
                            icon: Icons.settings_rounded,
                            title: "Settings",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(4);
                              setState(() {
                                appBarTitle = "Bloom";
                              });
                            }),
                        if (APP_DEVELOPMENT_MODE)
                          makeListTile_SideDrawer(
                              icon: Icons.bug_report_rounded,
                              title: "APP_DEBUG",
                              onTap: () {
                                Navigator.of(context).pop();
                                _animateToPage(5);
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
          onPressed: () => pageController.animateToPage(6,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut),
          child: const Icon(Ionicons.chatbubble),
        ),
        body: PageView(
          controller: pageController,
          pageSnapping: true,
          padEnds: false,
          allowImplicitScrolling: false,
          children: <Widget>[
            //const Page1_Home(),
            HomePage(),// 0
            debug_wrapPageNumber(
                bg: Colors.purple, text: "Tips Page"), // 1
            GardenPage(), // 2
            _StatsPage(), // 3
            debug_wrapPageNumber(
                bg: Colors.red, text: "Settings Page"), // 4
            const DebuggingStuffs(), // 5
            debug_wrapPageNumber(bg: Colors.red, text: "Chat Page"), // 6
          ],
        ));
  }
}
