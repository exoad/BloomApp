import 'dart:convert';

import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:random_avatar/random_avatar.dart';

void invalidateEphemeral() {
  setIsNewUser(true);
  setUserName("");
  setLastEntryTime(DateTime.fromMillisecondsSinceEpoch(0));
}

bool _safeGetBool(String key, bool defaultVal) {
  bool? val = prefs.getBool(key);
  if (val == null) {
    prefs.setBool(key, defaultVal);
  }
  return prefs.getBool(key)!;
}

double _safeGetDouble(String key, double defaultVal) {
  double? val = prefs.getDouble(key);
  if (val == null) {
    prefs.setDouble(key, defaultVal);
  }
  return prefs.getDouble(key)!;
}

int _safeGetInt(String key, int defaultVal) {
  int? val = prefs.getInt(key);
  if (val == null) {
    prefs.setInt(key, defaultVal);
  }
  return prefs.getInt(key)!;
}

String _safeGetString(String key, String defaultVal) {
  String? val = prefs.getString(key);
  if (val == null) {
    prefs.setString(key, defaultVal);
  }
  return prefs.getString(key)!;
}

bool _hasBeen24Hours(DateTime from, DateTime now) {
  return now.difference(from).inHours >= 24;
}

void updateStreak() {
  DateTime lastEntryTime =
      DateTime.fromMillisecondsSinceEpoch(getLastEntryTime());
  if (_hasBeen24Hours(lastEntryTime, DateTime.now())) {
    setUserStreak(getUserStreak() + 1);
  } else {
    setUserStreak(0);
  }
}

void setUserStreak(int newValue) =>
    prefs.setInt("userStreak", newValue);

int getUserStreak() => _safeGetInt("userStreak", 0);

bool getIsNewUser() => _safeGetBool("isNewUser", true);

void setIsNewUser(bool newValue) =>
    prefs.setBool("isNewUser", newValue);

String getUserAvatarSVG() =>
    prefs.getString("userAvatarSVG") ??
    RandomAvatarString(
      DateTime.now().toIso8601String(),
      trBackground: false,
    );

void setUserAvatarSVG(String newValue) =>
    prefs.setString("userAvatarSVG", newValue);

String getUserName() => _safeGetString("userName", "John");

void setUserName(String newValue) =>
    prefs.setString("userName", newValue);

double getUserAgeGroup() => _safeGetDouble("userAgeGroup", 0);

void setUserAgeGroup(double newValue) =>
    prefs.setDouble("userAgeGroup", newValue);

String getUserSex() => _safeGetString("userSex", "N/A");

void setUserSex(String newValue) =>
    prefs.setString("userSex", newValue);

int getLastEntryTime() => _safeGetInt("lastEntryTime",
    DateTime.fromMillisecondsSinceEpoch(0).millisecondsSinceEpoch);

void setLastEntryTimeAsNow() => prefs.setInt(
    "lastEntryTime", DateTime.now().millisecondsSinceEpoch);

void setLastEntryTime(DateTime newValue) =>
    prefs.setInt("lastEntryTime", newValue.millisecondsSinceEpoch);

double getLastEntryIndex() => _safeGetDouble("lastEntryIndex", 0);

double getCurrentWorkingEntryIndex() => getLastEntryIndex() + 1;

void setLastEntryIndexOneMore() =>
    prefs.setDouble("lastEntryIndex", getLastEntryIndex() + 1);

bool didTodaysEntry() {
  DateTime now = DateTime.now();
  DateTime lastEntryTime =
      DateTime.fromMillisecondsSinceEpoch(getLastEntryTime());
  return now.year == lastEntryTime.year &&
      now.month == lastEntryTime.month &&
      now.day == lastEntryTime.day;
}

void setLastEntryIndexOneLess() => getLastEntryIndex() - 1 < 0
    ? prefs.setDouble("lastEntryIndex", 0)
    : prefs.setDouble("lastEntryIndex", getLastEntryIndex() - 1);

void setLastEntryIndex(double newValue) =>
    prefs.setDouble("lastEntryIndex", newValue);

void insertEntry(EphemeralTelemetry newEntry) {
  prefs.setString(
      "userEntry_EphemeralData${newEntry.entryIndex}",
      jsonEncode(<String, dynamic>{
        "entryIndex": newEntry.entryIndex,
        "moodScale": newEntry.moodScale,
        "briefNote": newEntry.briefNote,
        "hoursOfSleep": newEntry.hoursOfSleep,
        "entryTimeEpochMS": newEntry.entryTimeEpochMS,
        "emotionTags": newEntry.emotionTags,
        "stressorsOfToday": newEntry.stressorsOfToday,
        "hoursOnScreen": newEntry.hoursOnScreen,
        "hoursExercising": newEntry.exercised,
        "howStressed": newEntry.howStressed,
        "hoursSpentWithFamily": newEntry.hoursSpentWithFamily,
        "sleepRating": newEntry.sleepRating,
        "hoursOutside": newEntry.hoursOutside,
        "hoursRecreational": newEntry.hoursRecreational,
        "hoursProductive": newEntry.hoursProductive,
        "energyLevelRating": newEntry.energyLevelRating,
      }));
  setLastEntryIndexOneMore();
}

void removeAllEntries() {
  for (int i = 0; i < getLastEntryIndex(); i++) {
    prefs.remove("userEntry_EphemeralData$i");
  }
}

EphemeralTelemetry getEntryByDate(DateTime time) {
  for (double i = 0; i <= getLastEntryIndex(); i++) {
    if (prefs.getString("userEntry_EphemeralData$i") != null) {
      Map<String, dynamic> jsonData =
          jsonDecode(prefs.getString("userEntry_EphemeralData$i")!);
      if (jsonData["entryTimeEpochMS"] ==
          time.millisecondsSinceEpoch) {
        return EphemeralTelemetry(i,
            moodScale: jsonData["moodScale"] as int,
            briefNote: jsonData["briefNote"].toString(),
            hoursOfSleep: jsonData["hoursOfSleep"] as int,
            entryTime: jsonData["entryTimeEpochMS"] as int,
            emotionTags: jsonData["emotionTags"].toString(),
            stressorsOfToday: jsonData["stressorsOfToday"].toString(),
            hoursOnScreen: jsonData["hoursOnScreen"] as int,
            exercised: jsonData["hoursExercising"] as bool,
            howStressed: jsonData["howStressed"] as int,
            hoursOutside: jsonData["hoursOutside"] as int,
            energyLevelRating: jsonData["energyLevelRating"] as int,
            hoursRecreational: jsonData["houseRecreational"] as int,
            hoursProductive: jsonData["hoursProductive"] as int,
            hoursSpentWithFamily:
                jsonData["hoursSpentWithFamily"] as int,
            sleepRating: jsonData["sleepRating"] as int);
      }
    }
  }
  return EphemeralTelemetry(0);
}

bool isEntryThereByDay(DateTime time) {
  for (int i = 0; i < getLastEntryIndex(); i++) {
    EphemeralTelemetry curr = getEntry(i.toDouble());
    DateTime currT =
        DateTime.fromMillisecondsSinceEpoch(curr.entryTimeEpochMS);
    if (currT.day == time.day &&
        currT.month == time.month &&
        currT.year == time.year) {
      return true;
    }
  }
  return false;
}

String? getEntry_JSON(double index) {
  if (prefs.getString("userEntry_EphemeralData$index") != null) {
    Map<String, dynamic> jsonData =
        jsonDecode(prefs.getString("userEntry_EphemeralData$index")!);
    return jsonData.toString();
  }
  return null;
}

void invalidateAllEntries() {
  for (double i = 0; i <= getLastEntryIndex(); i++) {
    prefs.remove("userEntry_EphemeralData$i");
  }
  setLastEntryIndex(0);
  setLastEntryTime(DateTime.fromMillisecondsSinceEpoch(0));
}

EphemeralTelemetry getEntry(double index) {
  if (prefs.getString("userEntry_EphemeralData$index") != null) {
    Map<String, dynamic> jsonData =
        jsonDecode(prefs.getString("userEntry_EphemeralData$index")!);
    return EphemeralTelemetry(index,
        moodScale: jsonData["moodScale"] as int,
        briefNote: jsonData["briefNote"].toString(),
        hoursOfSleep: jsonData["hoursOfSleep"] as int,
        entryTime: jsonData["entryTimeEpochMS"] as int,
        emotionTags: jsonData["emotionTags"].toString(),
        stressorsOfToday: jsonData["stressorsOfToday"].toString(),
        hoursOnScreen: jsonData["hoursOnScreen"] as int,
        exercised: jsonData["hoursExercising"] as bool,
        howStressed: jsonData["howStressed"] as int,
        hoursOutside: jsonData["hoursOutside"] as int,
        energyLevelRating: jsonData["energyLevelRating"] as int,
        hoursRecreational: jsonData["hoursRecreational"] as int,
        hoursProductive: jsonData["hoursProductive"] as int,
        hoursSpentWithFamily: jsonData["hoursSpentWithFamily"] as int,
        sleepRating: jsonData["sleepRating"] as int);
  }
  return EphemeralTelemetry(index);
}

class EphemeralTelemetry {
  final double entryIndex;

  int moodScale;
  String briefNote;
  String emotionTags;
  String stressorsOfToday;
  int hoursOnScreen;
  bool exercised;
  int hoursOutside;
  int howStressed;
  int hoursSpentWithFamily;
  int sleepRating;
  int hoursOfSleep;
  int entryTimeEpochMS;
  int hoursProductive;
  int hoursRecreational;
  int energyLevelRating;

  EphemeralTelemetry(this.entryIndex,
      {this.moodScale = -1,
      this.hoursOfSleep = -1,
      this.emotionTags = "",
      this.briefNote = "",
      this.energyLevelRating = -1,
      this.hoursOutside = -1,
      this.hoursProductive = -1,
      this.sleepRating = -1,
      this.hoursRecreational = -1,
      this.hoursOnScreen = -1,
      this.howStressed = -1,
      this.stressorsOfToday = "",
      this.exercised = false,
      this.hoursSpentWithFamily = -1,
      int? entryTime})
      : entryTimeEpochMS =
            entryTime ?? DateTime.now().millisecondsSinceEpoch;
}

void firstTimeValidateTelemetry() {
  setLastEntryIndex(0.0);
  setLastEntryTimeAsNow();
}
