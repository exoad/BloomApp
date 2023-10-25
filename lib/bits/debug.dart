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

class DebuggingStuffs extends StatelessWidget {
  const DebuggingStuffs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Text.rich(TextSpan(children: [
        const TextSpan(
            text: "isNewUser = ",
            style: TextStyle(fontWeight: FontWeight.w800)),
        TextSpan(
          text: "${getIsNewUser().toString()}\n",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const TextSpan(
            text: "userName = ",
            style: TextStyle(fontWeight: FontWeight.w800)),
        TextSpan(
          text: "${getUserName()}\n",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ], style: const TextStyle(fontSize: 18))),
    );
  }
}
