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

void setLastEntryIndexOneMore() =>
    prefs.setDouble("lastEntryIndex", getLastEntryIndex() + 1);

void setLastEntryIndex(double newValue) =>
    prefs.setDouble("lastEntryIndex", newValue);

void firstTimeValidateTelemetry() {
  setEngagementTime(0.0);
  setLastEntryIndex(0.0);
  setLastEntryTime(DateTime.now());
}
