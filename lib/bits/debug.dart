import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:blosso_mindfulness/bits/telemetry.dart';
import 'package:flutter/material.dart';

Widget debug_wrapPageNumber(
        {required Color bg, required String text}) =>
    Container(
        color: bg,
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 64)),
        ));

class DebuggingStuffs extends StatefulWidget {
  const DebuggingStuffs({super.key});

  @override
  State<DebuggingStuffs> createState() => _DebuggingStuffsState();
}

class _DebuggingStuffsState extends State<DebuggingStuffs> {
  static Widget _dbgButton(
      {required String text,
      required IconData icon,
      required void Function() onPressed}) {
    return TextButton.icon(
        onPressed: onPressed, icon: Icon(icon), label: Text(text));
  }

  static InlineSpan _makeProperty({required String name}) {
    return TextSpan(
        text: "$name = ",
        style: const TextStyle(fontWeight: FontWeight.w800),
        children: [
          TextSpan(
              text: "${prefs.get(name).toString()}\n",
              style: const TextStyle(fontWeight: FontWeight.w600))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // buttons here just for debugging certain data, dont remove the ones already here, might be troublesome
          // although the implementation is kinda tedious with repetitive code practices, but who cares
          _dbgButton(
              text: "NEW_USER",
              icon: Icons.person_add_alt_1_rounded,
              onPressed: () {
                setIsNewUser(!getIsNewUser());
                setState(() {});
              }),
          _dbgButton(
              text: "USER_NAME_EMPTY",
              icon: Icons.compress_rounded,
              onPressed: () {
                setUserName("");
                setState(() {});
              }),
          _dbgButton(
              text: "+1 ENTRY_INDEX",
              icon: Icons.exposure_plus_1_rounded,
              onPressed: () {
                setLastEntryIndexOneMore();
                setState(() {});
              }),
          _dbgButton(
              text: "0 ENTRY_INDEX",
              icon: Icons.restore_rounded,
              onPressed: () {
                setLastEntryIndex(0);
                setState(() {});
              }),
          _dbgButton(
              text: "-1 ENTRY_INDEX",
              icon: Icons.exposure_minus_1_rounded,
              onPressed: () {
                setLastEntryIndexOneLess();
                setState(() {});
              }),
          _dbgButton(
              text: "RESET_LAST_ENTRY_TIME",
              icon: Icons.calendar_month_rounded,
              onPressed: () {
                setLastEntryTime(
                    DateTime.fromMillisecondsSinceEpoch(0));
                setState(() {});
              }),
          _dbgButton(
              text: "RESET_ALL",
              icon: Icons.restore_rounded,
              onPressed: () {
                invalidateEphemeral();
                setState(() {});
              }),
          _dbgButton(
              text: "SET_LAST_ENTRY_TIME_NOW",
              icon: Icons.calendar_today_rounded,
              onPressed: () {
                setLastEntryTimeAsNow();
                setState(() {});
              }),
          _dbgButton(
              text: "REFRESH_PREFS",
              icon: Icons.refresh_rounded,
              onPressed: () => setState(() {})),
          Text.rich(TextSpan(children: [
            _makeProperty(name: "isNewUser"),
            _makeProperty(name: "userName"),
            _makeProperty(name: "lastEntryTime"),
            _makeProperty(name: "lastEntryIndex"),
          ], style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}
