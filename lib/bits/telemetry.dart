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

bool getIsNewUser() => prefs.getBool("isNewUser") ?? true;

void setIsNewUser(bool newValue) =>
    prefs.setBool("isNewUser", newValue);

String getUserName() => prefs.getString("userName") ?? "";

void setUserName(String newValue) =>
    prefs.setString("userName", newValue);
