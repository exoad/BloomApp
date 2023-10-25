import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:blosso_mindfulness/bits/debug.dart';
import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:blosso_mindfulness/bits/parts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((value) {
    prefs = value;
    init().then((_) => runApp(const _AppWrapper(appHome: MainApp())));
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

class InputDetailsCarousel extends StatefulWidget {
  const InputDetailsCarousel({super.key});

  @override
  State<InputDetailsCarousel> createState() =>
      _InputDetailsCarouselState();
}

class _InputDetailsCarouselState extends State<InputDetailsCarousel> {
  final PageController pageController =
      PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewChildren = const <Widget>[
      Center(
          child: Text.rich(TextSpan(children: [
        TextSpan(
            text: "Let's get started",
            style:
                TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
        TextSpan(
            text: "Tap \">\" for the next step",
            style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
      ])))
    ];

    return Column(
      children: [
        PageView(
            controller: pageController,
            pageSnapping: true,
            padEnds: true,
            allowImplicitScrolling: false,
            children: pageViewChildren),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    if (pageController.page! < 0 ||
                        pageController.page! >
                            pageViewChildren.length)
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.linear);
                    if (pageController.page! - 1 >= 0) {
                      pageController.animateToPage(
                          (pageController.page! - 1) as int,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: LaF.primaryColorFgContrast)),
              IconButton(
                  onPressed: () {
                    if (pageController.page! < 0 ||
                        pageController.page! >
                            pageViewChildren.length)
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.linear);
                    if (pageController.page! + 1 <=
                        pageViewChildren.length - 1) {
                      pageController.animateToPage(
                          (pageController.page! + 1) as int,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: LaF.primaryColorFgContrast))
            ]),
      ],
    );
  }
}

class _MainAppState extends State<MainApp> {
  final PageController pageController =
      PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _checkNewUser() async {
    if (getIsNewUser()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return NamePrompt(afterCallback: () {
            Navigator.of(context).pop();
          });
        },
      );
    }
  }

  void _animateToPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), _checkNewUser);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: LaF.primaryColor,
          foregroundColor: LaF.primaryColorFgContrast,
          title: const Text(LaF.appName,
              style: TextStyle(fontWeight: FontWeight.w700)),
          centerTitle: true,
          primary: true,
        ),
        drawer: Drawer(
            child:
                ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                    Color.fromARGB(255, 252, 218, 175),
                    Color.fromARGB(255, 250, 178, 90),
                    Color.fromARGB(255, 255, 153, 0)
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
                      fontWeight: FontWeight.w700, fontSize: 24))),
          makeListTile_SideDrawer(
              icon: Icons.home_rounded,
              title: "Home",
              onTap: () => _animateToPage(0)),
          makeListTile_SideDrawer(
              icon: Ionicons.chatbubble,
              title: "Chat",
              onTap: () => {}),
          makeListTile_SideDrawer(
              icon: Icons.lightbulb_rounded,
              title: "Tips",
              onTap: () => _animateToPage(1)),
          makeListTile_SideDrawer(
              icon: Icons.calculate_rounded,
              title: "Statistics",
              onTap: () => _animateToPage(2)),
          makeListTile_SideDrawer(
              icon: Icons.settings_accessibility_rounded,
              title: "Wellbeing",
              onTap: () => _animateToPage(3)),
          makeListTile_SideDrawer(
              icon: Icons.settings_rounded,
              title: "Settings",
              onTap: () => _animateToPage(4)),
          if (APP_DEVELOPMENT_MODE)
            makeListTile_SideDrawer(
                icon: Icons.bug_report_rounded,
                title: "APP_DEBUG",
                onTap: () => _animateToPage(5))
        ])),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => pageController.animateToPage(4,
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
                bg: Colors.purple, text: "Placeholder"),
            debug_wrapPageNumber(bg: Colors.purple, text: "Page 2"),
            debug_wrapPageNumber(
                bg: const Color.fromARGB(255, 63, 214, 234),
                text: "Page 3"),
            debug_wrapPageNumber(bg: Colors.green, text: "Page 4"),
            debug_wrapPageNumber(bg: Colors.red, text: "Page 5"),
            const DebuggingStuffs()
          ],
        ));
  }
}
