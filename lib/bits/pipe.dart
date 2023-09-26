import 'dart:io';


String loadString_sync(String fileLocale) => File(fileLocale).readAsStringSync();

