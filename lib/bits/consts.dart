import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

final class LaF {
  static const String appName = "Bloom";

  static const Color empty = Color.fromARGB(0, 0, 0, 0);
  static const Color primaryBackground =
      Color.fromARGB(255, 247, 237, 225);
  static const Color primaryColor =
      Color.fromARGB(255, 233, 204, 160);
  static const Color primaryColorTint =
      Color.fromARGB(255, 243, 197, 144);
  static const Color primaryColorTintDarker_Pressed =
      Color.fromARGB(180, 199, 144, 81);
  static const Color primaryColorFgContrast =
      Color.fromARGB(255, 48, 48, 48);

  static const Color primaryLightTint =
      Color.fromARGB(255, 241, 241, 241);
  static const Color primaryColorGreenTint =
      Color.fromARGB(255, 180, 242, 183);
  static const Color primaryColorBlueTint =
      Color.fromARGB(255, 17, 125, 174);

  static bool useLabeledBottomAppBarButtons = true;

  static const EdgeInsets outerComponentPadding =
      EdgeInsets.only(bottom: 8, left: 6, right: 6, top: 8);
  static const EdgeInsets homeComponentPadding =
      EdgeInsets.only(bottom: 4, left: 6, right: 6, top: 4);
  static const Radius roundedRectBorderRadius = Radius.circular(12);
  static String languageLocale = "en_US"; // ! NOTE: this is default
}

const bool APP_DEVELOPMENT_MODE = true;

ThemeData appLaF() {
  return ThemeData(
      highlightColor: LaF.primaryBackground,
      useMaterial3: false,
      primaryColor: LaF.primaryColor,
      primaryColorDark: LaF.primaryColor,
      appBarTheme: const AppBarTheme(shadowColor: Colors.transparent),
      scaffoldBackgroundColor: LaF.primaryBackground,
      bottomAppBarTheme: const BottomAppBarTheme(
        color: LaF.primaryColor,
        shadowColor: LaF.empty,
        surfaceTintColor: LaF.primaryColorTint,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: LaF.primaryColor,
          foregroundColor: LaF.primaryColorFgContrast,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(LaF.roundedRectBorderRadius))),
      shadowColor: LaF.empty,
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(
            LaF.primaryColorFgContrast),
      )),
      iconTheme:
          const IconThemeData(color: LaF.primaryColorFgContrast));
}

late final SharedPreferences prefs;

late YamlMap uiText;