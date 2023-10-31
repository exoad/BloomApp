import 'dart:convert';

import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:random_avatar/random_avatar.dart';

class EphemeralTelemetry {
/*
How much sleep did you get last night
Sleep quality rating scale of 1-10
Time spent relaxing with friends/family
How much did you exercise today
How long were you on your screen today
How stressed were you on a scale of 1-10
What were some stressors for you yesterday
10.Daily Mood Rating
Emotion Tags
Brief notes about day
*/

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
  setUserName("");
  setLastEntryTime(DateTime.fromMillisecondsSinceEpoch(0));
}

bool getIsNewUser() => prefs.getBool("isNewUser") ?? true;

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

String getUserName() => prefs.getString("userName") ?? "";

void setUserName(String newValue) =>
    prefs.setString("userName", newValue);

double getUserAgeGroup() => prefs.getDouble("userAgeGroup") ?? 0;

void setUserAgeGroup(double newValue) =>
    prefs.setDouble("userAgeGroup", newValue);

String getUserSex() => prefs.getString("userSex") ?? "?";

void setUserSex(String newValue) =>
    prefs.setString("userSex", newValue);

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

void removeAllEntries() {
  for (int i = 0; i < getLastEntryIndex(); i++) {
    prefs.remove("userEntry_EphemeralData$i");
  }
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
  setLastEntryIndex(0.0);
  setLastEntryTime(DateTime.now());
}
