import 'package:flutter/material.dart';
import 'package:project_1_app/bits/consts.dart';

class Block extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final EdgeInsets padding;
  const Block(
      {super.key,
      required this.backgroundColor,
      required this.child,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: padding,
          child: Container(
              decoration: ShapeDecoration(
                color: backgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(LaF.roundedRectBorderRadius),
                ),
              ),
              child: Padding(
                  padding: padding,
                  child: Center(child: child))))
    ]);
  }
}
