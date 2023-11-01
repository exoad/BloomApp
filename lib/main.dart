import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((value) {
    prefs = value;
    prefs.reload();
    runApp(_AppWrapper(
        appHome:
            !getIsNewUser() ? const MainApp() : launchCarousel()));
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


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool hasCompletedTask = false;

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
                    'Your Mood Today: Happy',
                    style:
                        TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: 4.5/5',
                    style:
                        TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
          ] else ...[
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
            const HomePage(),
            debug_wrapPageNumber(
                bg: Colors.purple, text: "Tips Page"),
            const GardenPage(),
            const ProfilePage(),
            const DebuggingStuffs(),
          ],
        ));
  }
}
