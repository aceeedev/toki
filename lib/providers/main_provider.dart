import 'package:flutter/material.dart';
import 'package:toki/backend/notification_api.dart';

class MainProvider with ChangeNotifier{
  String _nextAlarmString = '';
  late GlobalKey _alarmPageScaffold;

  String get nextAlarmString => _nextAlarmString;
  GlobalKey get alarmPageScaffold => _alarmPageScaffold;


  void setNextAlarmString() async {
    final DateTime? nextAlarmDateTime = (await NotificationApi().getNextAlarm())?['alarmTime'];

    if (nextAlarmDateTime == null) {
      _nextAlarmString = 'No Alarms are enabled';
    } else {
      final Duration? nextAlarmDuration = nextAlarmDateTime.difference(DateTime.now());

      String formattedString = 'Next Alarm in';

      if (nextAlarmDuration?.inDays != 0) {
        formattedString += ' ${nextAlarmDuration?.inDays} days,';
      }
      if (nextAlarmDuration?.inHours != 0) {
        formattedString += ' ${nextAlarmDuration?.inHours.remainder(24)} hours,';
      }
      if (nextAlarmDuration?.inMinutes != 0) {
        formattedString += ' ${nextAlarmDuration?.inMinutes.remainder(60)} minutes,';
      }
      if (nextAlarmDuration?.inSeconds != 0) {
        formattedString += ' ${nextAlarmDuration?.inSeconds.remainder(60)} seconds';
      }
      
      _nextAlarmString = formattedString;
    }

    notifyListeners();
  }

  void setAlarmPageScaffold(GlobalKey newAlarmPageScaffold) {
    _alarmPageScaffold = newAlarmPageScaffold;
  }
}