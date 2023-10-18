import 'package:flutter/services.dart';

Future<String> loadString_sync(String fileLocale) =>
    rootBundle.loadString(fileLocale);
