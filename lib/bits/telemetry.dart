import 'dart:convert';

import 'package:blosso_mindfulness/bits/consts.dart';

class EphemeralTelemetry {
  /*
Daily mood rating on a scale.
Emotion tags (happy, sad, anxious, anry).
Time spent relaxing
Time spent with friends/family
Brief notes or descriptions about the day.
Duration of sleep.
Sleep quality rating.
Type and duration of exercise.
Physical activity levels throughout the day.
Daily stress rating.
Stressors or triggers.
   */

  /*------------------------------------------------------ /
  / double dateTimeStamp;                                  /
  / int moodScale;                                         /
  / double minutesSpentRelaxing;                           /
  / double minutesSpentWithFamily;                         /
  / double minutesSpentWithFriends;                        /
  / double hoursOfSleep;                                   /
  / String briefNote;                                      /
  /                                                        /
  / EphemeralTelemetry({this.dailyMoods = const <int>[]}); /
  /-------------------------------------------------------*/

  final double entryIndex;

  // the below are actual related data to the user
  int moodScale; // out of 5
  String briefNote;
  double hoursOfSleep;
  int entryTimeEpochMS; // using DateTime.frommillisecondsfromepoch or something

  EphemeralTelemetry(this.entryIndex,
      {this.moodScale = 5,
      this.briefNote = "N/A",
      this.hoursOfSleep = 0,
      int? entryTime})
      : entryTimeEpochMS =
            entryTime ?? DateTime.now().millisecondsSinceEpoch;
}

void invalidateEphemeral() {
  // basically resets the user data to default
  setIsNewUser(true);
  setEngagementTime(0);
  setUserName("");
  setLastEntryTime(DateTime.fromMillisecondsSinceEpoch(0));
}

T _safeGet<T>(String key, T defaultValue) {
  // primary fx for when we have to rewrite the datatype of an object and thus saves us the pain of debugging errors
  // probably not going to use this fx anyways
  late T obj;
  try {
    obj = prefs.get(key) as T;
  } catch (e) {
    obj = defaultValue;
    if (T.runtimeType == int) {
      prefs.setInt(key, defaultValue as int);
    } else if (T.runtimeType == double) {
      prefs.setDouble(key, defaultValue as double);
    } else if (T.runtimeType == String) {
      prefs.setString(key, defaultValue.toString());
    } else if (T.runtimeType == List<String>) {
      prefs.setStringList(key, defaultValue as List<String>);
    }
  }
  return obj;
}

bool getIsNewUser() => prefs.getBool("isNewUser") ?? true;

void setIsNewUser(bool newValue) =>
    prefs.setBool("isNewUser", newValue);

String getUserName() => prefs.getString("userName") ?? "";

void setUserName(String newValue) =>
    prefs.setString("userName", newValue);

double getEngagementTime() =>
    prefs.getDouble("engagementTime") ?? 0.0;

void setEngagementTime(double newValue) =>
    prefs.setDouble("engagementTime", newValue);

int getLastEntryTime() => prefs.getInt("lastEntryTime") ?? 00;

void setLastEntryTimeAsNow() => prefs.setInt(
    "lastEntryTime", DateTime.now().millisecondsSinceEpoch);

void setLastEntryTime(DateTime newValue) =>
    prefs.setInt("lastEntryTime", newValue.millisecondsSinceEpoch);

double getLastEntryIndex() => prefs.getDouble("lastEntryIndex") ?? 0;

double getCurrentWorkingEntryIndex() => getLastEntryIndex() + 1;

void setLastEntryIndexOneMore() =>
    prefs.setDouble("lastEntryIndex", getLastEntryIndex() + 1);

void setLastEntryIndexOneLess() => getLastEntryIndex() - 1 <
        0 // we dont have to be null aware as this fx takes care of the nullability check
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
        "entryTimeEpochMS": newEntry.entryTimeEpochMS
      }));
  setLastEntryIndexOneMore();
}

EphemeralTelemetry? getEntry(double index) {
  if (prefs.getString("userEntry_EphemeralData$index") != null) {
    Map<String, dynamic> jsonData =
        jsonDecode(prefs.getString("userEntry_EphemeralData$index")!);
    return EphemeralTelemetry(index,
        moodScale: jsonData["moodScale"] as int,
        briefNote: jsonData["briefNote"].toString(),
        hoursOfSleep: jsonData["hoursOfSleep"] as double,
        entryTime: jsonData["entryTimeEpochMS"] as int);
  }
  return null;
}

void firstTimeValidateTelemetry() {
  setEngagementTime(0.0);
  setLastEntryIndex(0.0);
  setLastEntryTime(DateTime.now());
}
