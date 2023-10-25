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

Map<String, dynamic> _perpetualTelemetry = {
  "isNewUser": true,
  "userName": "",
};

bool getIsNewUser() => _perpetualTelemetry["isNewUser"];

void setIsNewUser(bool newValue) =>
    _perpetualTelemetry["isNewUser"] = newValue;

String getUserName() => _perpetualTelemetry["userName"];

void setUserName(String newValue) =>
    _perpetualTelemetry["userName"] = newValue;

void loadPerpetualTelemetry() {
  _perpetualTelemetry["isNewUser"] ??= prefs.getBool("isUserName");
  _perpetualTelemetry["userName"] ??= prefs.getString("userName");
}
