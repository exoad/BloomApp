import 'package:flutter/material.dart';
import 'package:project_1_app/bits/consts.dart';
import 'package:project_1_app/parts/block.dart';

/// Creates a labled Icon Button in the format that the label is vertically under the Icon Button.
/// [button] refers to the target IconButton and the [label] is the label for it and the optional [labelStyle]
Widget labeledIconBtn(
        {required IconButton child,
        required String label,
        TextStyle? labelStyle}) =>
    LaF.useLabeledBottomAppBarButtons
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [child, Text(label, style: labelStyle)])
        : child;

IconButton bottomAppBarPageControlledBtn(
        {required int pageNum,
        required Icon icon,
        required PageController controller}) =>
    IconButton(
      onPressed: () => controller.animateToPage(pageNum,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut),
      icon: icon,
    );

Widget wrapAsHomeLabel(
        {required Widget child,
        Color color = LaF.empty,
        EdgeInsets padding = LaF.outerComponentPadding}) =>
    Block(backgroundColor: color, padding: padding, child: child);
