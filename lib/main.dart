import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:blosso_mindfulness/bits/debug.dart';
import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    List<Widget> telemetryData = const <Widget>[];

    return CustomScrollView(slivers: <Widget>[
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return const Text.rich(TextSpan(children: [
          TextSpan(
              text: "Personal Statistics",
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 28))
        ])); // dangerous area if we dont have the valid delegates for the required widgets fed into the stats tree
      }))
    ]);
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
          title: const Text(
            LaF.appName,
            style: TextStyle(fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
          centerTitle: true,
          primary: true,
          automaticallyImplyLeading: true,
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
              onTap: () {
                Navigator.of(context).pop();
                _animateToPage(0);
              }),
          makeListTile_SideDrawer(
              icon: Ionicons.chatbubble,
              title: "Chat",
              onTap: () {
                Navigator.of(context).pop();
                _animateToPage(6);
              }),
          makeListTile_SideDrawer(
              icon: Icons.lightbulb_rounded,
              title: "Tips",
              onTap: () {
                Navigator.of(context).pop();
                _animateToPage(1);
              }),
          makeListTile_SideDrawer(
              icon: Icons.calculate_rounded,
              title: "Statistics",
              onTap: () {
                Navigator.of(context).pop();
                _animateToPage(2);
              }),
          makeListTile_SideDrawer(
              icon: Icons.settings_accessibility_rounded,
              title: "Wellbeing",
              onTap: () {
                Navigator.of(context).pop();
                _animateToPage(3);
              }),
          makeListTile_SideDrawer(
              icon: Icons.settings_rounded,
              title: "Settings",
              onTap: () {
                Navigator.of(context).pop();
                _animateToPage(4);
              }),
          if (APP_DEVELOPMENT_MODE)
            makeListTile_SideDrawer(
                icon: Icons.bug_report_rounded,
                title: "APP_DEBUG",
                onTap: () {
                  Navigator.of(context).pop();
                  _animateToPage(5);
                })
        ])),
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
                bg: Colors.purple, text: "Home Page"),
            debug_wrapPageNumber(
                bg: Colors.purple, text: "Tips Page"),
            _StatsPage(),
            debug_wrapPageNumber(bg: Colors.green, text: "Wellbeing"),
            debug_wrapPageNumber(
                bg: Colors.red, text: "Settings Page"),
            const DebuggingStuffs(),
            debug_wrapPageNumber(bg: Colors.red, text: "Chat Page"),
          ],
        ));
  }
}
