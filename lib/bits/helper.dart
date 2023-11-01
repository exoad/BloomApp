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

String monthNumToName(int monthNum) {
  return monthNum == DateTime.january
      ? "January"
      : monthNum == DateTime.february
          ? "February"
          : monthNum == DateTime.march
              ? "March"
              : monthNum == DateTime.april
                  ? "April"
                  : monthNum == DateTime.may
                      ? "May"
                      : monthNum == DateTime.june
                          ? "June"
                          : monthNum == DateTime.july
                              ? "July"
                              : monthNum == DateTime.august
                                  ? "August"
                                  : monthNum == DateTime.september
                                      ? "September"
                                      : monthNum == DateTime.october
                                          ? "October"
                                          : monthNum ==
                                                  DateTime.november
                                              ? "November"
                                              : monthNum ==
                                                      DateTime
                                                          .december
                                                  ? "December"
                                                  : "Unknown";
}

Color monthColor(int monthNum) {
  return monthNum == DateTime.january
      ? Colors.pink
      : monthNum == DateTime.february
          ? Colors.blue
          : monthNum == DateTime.march
              ? Colors.green.shade700
              : monthNum == DateTime.april
                  ? Colors.orange
                  : monthNum == DateTime.may
                      ? Colors.purple
                      : monthNum == DateTime.june
                          ? Colors.red
                          : monthNum == DateTime.july
                              ? Colors.teal
                              : monthNum == DateTime.august
                                  ? Colors.cyan
                                  : monthNum == DateTime.september
                                      ? Colors.indigo
                                      : monthNum == DateTime.october
                                          ? const Color.fromARGB(
                                              255, 192, 209, 40)
                                          : monthNum ==
                                                  DateTime.november
                                              ? Colors.orange.shade600
                                              : monthNum ==
                                                      DateTime
                                                          .december
                                                  ? Colors
                                                      .pink.shade800
                                                  : Colors.black;
}

String actionableSliderHoursContext(
        double min, double max, double val) =>
    val > max
        ? "Greater than $max hours"
        : val < min
            ? "Less than $min hour"
            : "$val hours";

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
