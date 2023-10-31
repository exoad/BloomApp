import 'package:flutter/material.dart';
import 'package:blosso_mindfulness/bits/consts.dart';

double clampDouble(
        {required double value,
        required double min,
        required double max}) =>
    value < min
        ? min
        : value > max
            ? max
            : value;

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

Widget _acquireInputTitleText(
    {required String title, TextStyle? titleStyle}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Text(
      title,
      style: titleStyle ??
          const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              overflow: TextOverflow.clip),
      textAlign: TextAlign.center,
    ),
  );
}

Widget makeTextInputDetails(
    {required String title,
    required void Function(String) callback,
    TextStyle? titleStyle,
    TextStyle? hintStyle,
    String hintText = ""}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _acquireInputTitleText(title: title, titleStyle: titleStyle),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(34.0),
          child: Builder(builder: (context) {
            TextEditingController controller =
                TextEditingController();
            controller.addListener(() {
              callback.call(controller.text);
            });
            return TextFormField(
              cursorColor: LaF.primaryColor,
              textAlign: TextAlign.center,
              controller: controller,
              decoration: InputDecoration(
                  focusColor: LaF.primaryColor,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          LaF.roundedRectBorderRadius)),
                  hintText: hintText,
                  alignLabelWithHint: true,
                  hintStyle: hintStyle ??
                      const TextStyle(
                          color: Color.fromARGB(178, 133, 133, 133))),
            );
          }),
        )
      ]);
}

Widget makeCustomInputDetails(
    {required String title,
    TextStyle? titleStyle,
    required Widget child}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _acquireInputTitleText(title: title, titleStyle: titleStyle),
        const SizedBox(height: 20),
        child
      ]);
}

String fmtDateTime(DateTime time) =>
    "${time.hour}:${time.minute} ${time.month}/${time.day}/${time.year}";

Widget makeListTile_SideDrawer(
    {required IconData icon,
    required String title,
    required void Function() onTap,
    Color? iconColor,
    Color? textColor}) {
  return ListTile(
      onTap: onTap.call,
      title: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: iconColor ?? Colors.black,
          ),
          const SizedBox(width: 30),
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.black)),
        ],
      ));
}

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
