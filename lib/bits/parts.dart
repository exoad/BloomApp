import 'package:flutter/material.dart';
import 'package:blosso_mindfulness/bits/consts.dart';

class Block extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final EdgeInsets padding;
  const Block(
      {super.key,
      required this.backgroundColor,
      required this.child,
      required this.padding});

  const Block.claimed(
      {super.key,
      required this.backgroundColor,
      required this.child,
      this.padding = LaF.homeComponentPadding});

  Block.text(
      {super.key,
      required String titleText,
      this.padding = LaF.homeComponentPadding,
      required String subText,
      TextStyle titleTextStyle = LaF.blockTitleTextStyle,
      TextStyle subTextStyle = LaF.blockSubTextStyle,
      Widget? sideLabel,
      required this.backgroundColor})
      : child = sideLabel == null
            ? Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(text: titleText, style: titleTextStyle),
                TextSpan(text: subText, style: subTextStyle)
              ]))
            : Row(children: [
                sideLabel,
                Text.rich(TextSpan(children: <InlineSpan>[
                  TextSpan(text: titleText, style: titleTextStyle),
                  TextSpan(text: subText, style: subTextStyle)
                ]))
              ]);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: padding,
              child: Container(
                  decoration: ShapeDecoration(
                    color: backgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          LaF.roundedRectBorderRadius),
                    ),
                  ),
                  child: Padding(
                      padding: padding,
                      child: Center(
                        heightFactor: 1,
                        child: child,
                      ))))
        ]);
  }
}
