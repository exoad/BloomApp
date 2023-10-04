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

Text withText(
        {required String data,
        double? fontSize,
        FontWeight? fontWeight,
        Paint? foregroundColor,
        double? wordSpacing,
        StrutStyle? strutStyle,
        TextAlign? textAlign,
        TextDirection? textDirection,
        Locale? locale,
        bool? softWrap,
        TextOverflow? overflow,
        double? textScaleFactor,
        int? maxLines,
        String? semanticsLabel,
        TextWidthBasis? textWidthBasis,
        TextHeightBehavior? textHeightBehavior,
        Color? selectionColor}) =>
    Text(data,
        textAlign: textAlign,
        strutStyle: strutStyle,
        selectionColor: selectionColor,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        textDirection: textDirection,
        style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            foreground: foregroundColor,
            fontFamily: "FiraMonoe"));
