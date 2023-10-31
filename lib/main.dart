// ignore_for_file: library_private_types_in_public_api

import 'package:blosso_mindfulness/bits/parts.dart';
import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:blosso_mindfulness/bits/debug.dart';
import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  const GardenPage({super.key});
  //got this to work
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  DateTime currentMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${DateFormat.MMMM().format(currentMonth)} ${currentMonth.year}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () {
            setState(() {
              currentMonth = DateTime(
                  currentMonth.year, currentMonth.month - 1, 1);
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(
                    currentMonth.year, currentMonth.month + 1, 1);
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount:
            getNumberOfWeeks(currentMonth.year, currentMonth.month),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: 150.0,
              color: Colors.green,
              child:
                  const Center(child: Text('Current Weeks Garden')),
            );
          } else {
            return Container(
              height: 100.0,
              color: Colors.green[300 + (index * 100) % 300],
              child: Center(child: Text('Week ${index + 1} Garden')),
            );
          }
        },
      ),
    );
  }

  int getNumberOfWeeks(int year, int month) {
    //able to display months and weeks accurately
    //i need to go to sleep now fuck
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    int weekdayOfFirst = DateTime(year, month, 1).weekday;
    int weekdayOfLast = lastDayOfMonth.weekday;
    int daysInFirstWeek = 8 - weekdayOfFirst;
    int daysInLastWeek = weekdayOfLast;
    int daysInBetween =
        lastDayOfMonth.day - daysInFirstWeek - daysInLastWeek;
    return (daysInBetween / 7).ceil() +
        2; //adds for first and last week yo
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
                                appBarTitle = "Home";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.lightbulb_rounded,
                            title: "Tips",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(1);
                              setState(() {
                                appBarTitle = "Tips";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.person_rounded,
                            title: "Profile",
                            onTap: () {
                              Navigator.of(context).pop();
                              _animateToPage(3);
                              setState(() {
                                appBarTitle = "Profile";
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
                                appBarTitle = "Garden";
                              });
                            }),
                        makeListTile_SideDrawer(
                            icon: Icons.change_circle_rounded,
                            title: "Change Profile",
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctxt) =>
                                          launchCarousel()));
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
            debug_wrapPageNumber(
                bg: Colors.purple, text: "Home Page"), // 0
            debug_wrapPageNumber(
                bg: Colors.purple, text: "Tips Page"), // 1
            const GardenPage(), // 2
            _StatsPage(), // 3
            const DebuggingStuffs(), // 4
          ],
        ));
  }
}
