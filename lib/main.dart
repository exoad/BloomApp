import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project_1_app/bits/debug.dart';
import 'package:project_1_app/bits/helper.dart';
import 'package:project_1_app/bits/consts.dart';
import 'package:project_1_app/parts/block.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  init().then((_) => runApp(const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final PageController pageController =
      PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int index) =>
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appLaF(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: LaF.primaryColor,
          foregroundColor: LaF.primaryColorFgContrast,
          title: const Text("AppName",
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
                    Color.fromARGB(255, 240, 153, 47),
                    Color.fromARGB(255, 255, 153, 0)
                  ],
                      stops: [
                    0.0,
                    0.35,
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
              onTap: () => _animateToPage(4))
        ])),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => pageController.animateToPage(4,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut),
          child: const Icon(Ionicons.chatbubble),
        ),
        bottomNavigationBar:
            BottNavBar(pageController: pageController),
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
            debug_wrapPageNumber(bg: const Color.fromARGB(255, 63, 214, 234), text: "Page 3"),
            debug_wrapPageNumber(bg: Colors.green, text: "Page 4"),
            debug_wrapPageNumber(bg: Colors.red, text: "Page 5"),
          ],
        ),
      ),
    );
  }
}

class Page1_Home extends StatelessWidget {
  const Page1_Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // Replace this with your actual list items
              return wrapAsHomeLabel(
                  padding: LaF.homeComponentPadding,
                  child: Column(
                    children: <Widget>[
                      wrapAsHomeLabel(
                        padding: LaF.homeComponentPadding,
                        child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      "assets/app_icon/icon_64x64.png")),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Text(uiText["TitleLabel"],
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight:
                                                FontWeight.w700,
                                            fontSize: 30,
                                            fontFamily: "FiraMono")),
                                    Text(uiText["AuthorsSublabel"],
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight:
                                                FontWeight.w500,
                                            fontSize: 14,
                                            fontFamily: "FiraMono"))
                                  ])
                            ]),
                      ),
                      const Block.claimed(
                          backgroundColor: LaF.primaryColorBlueTint,
                          child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                    flex: 3,
                                    child: Icon(
                                        Icons.warning_amber_rounded,
                                        size: 54)),
                                Text.rich(
                                  TextSpan(children: <InlineSpan>[
                                    TextSpan(
                                        text: "Placeholder\n",
                                        style: TextStyle(
                                          overflow:
                                              TextOverflow.ellipsis,
                                        )),
                                  ]),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34,
                                      fontFamily: "FiraMono"),
                                )
                              ])),
                      const Block(
                          backgroundColor: LaF.primaryColorGreenTint,
                          padding: LaF.homeComponentPadding,
                          child: Text("Placeholder"))
                    ],
                  ));
            },
            childCount:
                1, // Set the number of list items you want to display
          ),
        ),
      ],
    );
  }
}

class BottNavBar extends StatelessWidget {
  const BottNavBar({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          labeledIconBtn(
              child: bottomAppBarPageControlledBtn(
                  pageNum: 0,
                  icon: const Icon(Icons.home_filled),
                  controller: pageController),
              label: uiText["HomeLabel"]),
          labeledIconBtn(
            child: bottomAppBarPageControlledBtn(
                pageNum: 1,
                icon: const Icon(Icons.lightbulb_rounded),
                controller: pageController),
            label: uiText["TipsLabel"]!,
          ),
          labeledIconBtn(
            child: bottomAppBarPageControlledBtn(
                pageNum: 2,
                icon: const Icon(Icons.format_list_bulleted_rounded),
                controller: pageController),
            label: uiText["LogLabel"]!,
          ),
          labeledIconBtn(
            child: bottomAppBarPageControlledBtn(
                pageNum: 3,
                icon: const Icon(Icons.settings),
                controller: pageController),
            label: uiText["SettingsLabel"]!,
          ),
        ],
      )),
    );
  }
}
