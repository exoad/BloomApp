import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'pipe.dart';

final class LaF {
  static const Color empty = Color.fromARGB(0, 0, 0, 0);
  static const Color primaryBackground =
      Color.fromARGB(255, 247, 237, 225);
  static const Color primaryColor =
      Color.fromARGB(255, 247, 204, 147);
  static const Color primaryColorTint =
      Color.fromARGB(255, 235, 208, 118);
  static const Color primaryColorTintDarker_Pressed =
      Color.fromARGB(180, 199, 144, 81);
  static const Color primaryColorConstrast =
      Color.fromARGB(255, 255, 145, 0);
  static const Color primaryColorFgContrast =
      Color.fromARGB(255, 48, 48, 48);

  static const Color primaryLightTint =
      Color.fromARGB(255, 241, 241, 241);
  static const Color primaryColorGreenTint =
      Color.fromARGB(255, 180, 242, 183);
  static const Color primaryColorBlueTint =
      Color.fromARGB(255, 177, 221, 241);

  static bool useLabeledBottomAppBarButtons = true;

  static const EdgeInsets outerComponentPadding =
      EdgeInsets.only(bottom: 8, left: 6, right: 6, top: 8);
  static const EdgeInsets homeComponentPadding =
      EdgeInsets.only(bottom: 4, left: 6, right: 6, top: 4);
  static const Radius roundedRectBorderRadius = Radius.circular(20);

  static String languageLocale = "en_US"; // ! NOTE: this is default

  static const TextStyle blockTitleTextStyle = TextStyle(
      fontFamily: "FiraMono",
      fontWeight: FontWeight.w700,
      fontSize: 58);
  static const TextStyle blockSubTextStyle = TextStyle(
      fontFamily: "FiraMono",
      fontWeight: FontWeight.w500,
      fontSize: 30);
}

ThemeData appLaF() {
  return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: LaF.primaryBackground,
      bottomAppBarTheme: const BottomAppBarTheme(
          color: LaF.primaryColor,
          height: 75,
          shadowColor: LaF.empty,
          surfaceTintColor: LaF.primaryColorTint,
          shape: AutomaticNotchedShape(RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(LaF.roundedRectBorderRadius)))),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: LaF.primaryColorConstrast,
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

late YamlMap uiText;

Future<void> init() async {
  uiText = await loadYaml(
      await loadString_sync("assets/i18n/${LaF.languageLocale}.yaml"));

  uiText.forEach((k, v) => print("Loaded LOCALE_LANG: $k -> $v"));
}
