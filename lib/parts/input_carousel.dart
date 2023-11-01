import 'package:blosso_mindfulness/main.dart';
import 'package:flutter/material.dart';

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
                text: "${widget.firstPage!.title}\n\n\n",
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

class _InputDetailsControllerRowState
    extends State<_InputDetailsControllerRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flex(
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
                        .then((value) => setState(() {}));
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
                          icon: const Icon(Icons.check_rounded,
                              size: 32))
                      : const SizedBox(width: 42, height: 42);
                })),
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: IconButton(
                onPressed: () {
                  if (widget.pageController.page! + 1 <=
                      widget.pageViewChildren.length - 1) {
                    widget.pageController
                        .animateToPage(
                          (widget.pageController.page! + 1).toInt(),
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear,
                        )
                        .then((value) => setState(() {}));
                  }
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (widget.pageController.page != null)
          Text(
              "${widget.pageController.page!.toInt() + 1} / ${widget.pageViewChildren.length}")
      ],
    );
  }
}
