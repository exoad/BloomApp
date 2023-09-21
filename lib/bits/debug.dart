import 'package:flutter/material.dart';

Widget debug_wrapPageNumber({required Color bg, required String text}) =>
    Container(
        color: bg,
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 64)),
        ));
