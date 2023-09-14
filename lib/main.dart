import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project_1_app/bits/helper.dart';
import 'package:project_1_app/bits/consts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MainApp());
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appLaF(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Ionicons.chatbubble),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
              bottom: 8, left: 6, right: 6, top: 4),
          child: BottomAppBar(
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
                    icon: const Icon(
                        Icons.format_list_bulleted_rounded),
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
              const SizedBox(width: 30)
            ],
          )),
        ),
        body: PageView(
          controller: pageController,
          pageSnapping: true,
          padEnds: false,
          allowImplicitScrolling: false,
          children: <Widget>[
            Center(
                child: PageView(
              scrollDirection: Axis.vertical,
              allowImplicitScrolling: true,
              children: [
                wrapAsHomeLabel(
                    child: const Text("Placeholder Title"),
                    color: LaF.primaryColorBlueTint),
              ],
            )),
            Container(color: Colors.red),
            Container(color: Colors.orange),
            Container(color: Colors.green),
            Container(color: Colors.pink)
          ],
        ),
      ),
    );
  }
}
