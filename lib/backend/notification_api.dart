import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/alarm.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    // when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      }
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future _notificationDetails(Alarm alarm) async {
    String soundName = alarm.alarmRingtone;
    String sound = '';
    if (soundName == 'Default Ringtone') {
      sound = 'digital_alarm_sound.wav';
    } else {
      Exception('soundName $soundName does not match possible options');
    }
    return NotificationDetails(
      android: const AndroidNotificationDetails(
        'channel id',
        'channel name',
        //'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: sound,
      ),
    );
  }


  static tz.TZDateTime _convertDateTimeToTZ(DateTime time) {
    final scheduledDate = tz.TZDateTime(tz.local, time.year, time.month, time.day, time.hour, time.minute, time.second);

    return scheduledDate;
  }

  static updateCurrentAlarm(Alarm alarm, bool currentAlarm, bool alarmOn) {
    Alarm updatedAlarm = Alarm(
      id: alarm.id,
      time: alarm.time,
      selectedSu: alarm.selectedSu,
      selectedMo: alarm.selectedMo,
      selectedTu: alarm.selectedTu,
      selectedWe: alarm.selectedWe,
      selectedTh: alarm.selectedTh,
      selectedFr: alarm.selectedFr,
      selectedSa: alarm.selectedSa,
      alarmName: alarm.alarmName,
      alarmRingtone: alarm.alarmRingtone,
      alarmOn: alarmOn,
      currentAlarm: currentAlarm,
    );

    return updatedAlarm;
  }

  static int findDaysUntilAlarm(Alarm alarm) {
    int todayWeekday = DateTime.now().weekday;
    List alarmSelectedWeekdays = [];
    if (alarm.selectedMo) {
      alarmSelectedWeekdays.add(1);
    }
    if (alarm.selectedTu) {
      alarmSelectedWeekdays.add(2);
    }
    if (alarm.selectedWe) {
      alarmSelectedWeekdays.add(3);
    }
    if (alarm.selectedTh) {
      alarmSelectedWeekdays.add(4);
    }
    if (alarm.selectedFr) {
      alarmSelectedWeekdays.add(5);
    }
    if (alarm.selectedSa) {
      alarmSelectedWeekdays.add(6);
    }
    if (alarm.selectedSu) {
      alarmSelectedWeekdays.add(7);
    }

    int nextWeekdayAlarm = 0;
    for (int i = 0; i < alarmSelectedWeekdays.length; i++) {
      if (alarmSelectedWeekdays[i] >= todayWeekday) {
        if ((alarm.time.hour > DateTime.now().hour || (alarm.time.hour == DateTime.now().hour && alarm.time.minute > DateTime.now().minute))) {
          nextWeekdayAlarm = alarmSelectedWeekdays[i];
        } else {
          nextWeekdayAlarm = alarmSelectedWeekdays[i + 1 <= alarmSelectedWeekdays.length - 1 ? i + 1 : 0];
        }
        break;
      }
      // in the case that the next day is before today's weekday
      if (i == alarmSelectedWeekdays.length - 1) {
        nextWeekdayAlarm = alarmSelectedWeekdays[0];
        break;
      }
    }
    int weekdaysBetweenNowAndNextAlarm;
    if (nextWeekdayAlarm == todayWeekday) {
      // if alarm time is less than now and today schedule for next week
      if ((alarm.time.hour < DateTime.now().hour || (alarm.time.hour == DateTime.now().hour && alarm.time.minute <= DateTime.now().minute)) && alarmSelectedWeekdays.length == 1) {
        weekdaysBetweenNowAndNextAlarm = 7;
      } else {
        weekdaysBetweenNowAndNextAlarm = nextWeekdayAlarm - todayWeekday;
      }
    } else if (nextWeekdayAlarm > todayWeekday) {
      weekdaysBetweenNowAndNextAlarm = nextWeekdayAlarm - todayWeekday;
    } else {
      // if the next alarm is a weekday that is less than today's, aka next week
      weekdaysBetweenNowAndNextAlarm = (7 - todayWeekday) + nextWeekdayAlarm;
    }

    print(weekdaysBetweenNowAndNextAlarm);

    return weekdaysBetweenNowAndNextAlarm;
  }

  Future<Map<String, dynamic>?> getNextAlarm() async {
    List<Alarm> alarmsFromDB = await TokiDatabase.instance.readAllAlarms('Time ASC');

    List<Map<String, dynamic>> nextAlarmsWithDateTimes = [];
    DateTime today = DateTime.now();
    for (Alarm alarm in alarmsFromDB) {
      if (alarm.alarmOn) {
        DateTime newDateTime = DateTime(
          today.year, 
          today.month, 
          today.day + findDaysUntilAlarm(alarm),
          alarm.time.hour, 
          alarm.time.minute,
        );

        nextAlarmsWithDateTimes.add({
          'id': alarm.id,
          'time': newDateTime,
        });
      }
    }

    if (nextAlarmsWithDateTimes.isEmpty) {
      return null;
    }

    int customTimeSort(Map<String, dynamic> a, Map<String, dynamic> b) {
      DateTime aTime = a['time'];
      DateTime bTime = b['time'];

      return aTime.compareTo(bTime);
    }

    nextAlarmsWithDateTimes.sort(customTimeSort);
    print(nextAlarmsWithDateTimes);

    Alarm nextAlarm = await TokiDatabase.instance.readAlarm(nextAlarmsWithDateTimes.first['id']);
      
    return {
      'nextAlarm': nextAlarm,
      'alarmTime': nextAlarmsWithDateTimes.first['time']
    };
  }

  static void scheduleNotification() async {
    final Map<String, dynamic>? nextAlarmInfo = await NotificationApi().getNextAlarm();
    if (nextAlarmInfo == null) {
      return;
    }

    final Alarm alarm = nextAlarmInfo['nextAlarm'];
    final DateTime scheduledDateTime = nextAlarmInfo['alarmTime'];

    if (!alarm.currentAlarm) {
      Alarm updatedAlarm = updateCurrentAlarm(alarm, true, alarm.alarmOn);
      TokiDatabase.instance.updateAlarm(updatedAlarm);

      final String title = '${DateFormat('h:mm a').format(alarm.time)} Alarm';
      const String body = 'Click this notification to turn off the alarm!';
      final String payload = alarm.id.toString();

      final scheduledTZDateTime = _convertDateTimeToTZ(scheduledDateTime);

      // schedule all notifcations for that alarm
      for (int i = 0; i < 64; i++) {
        _notifications.zonedSchedule(
          i,
          title,
          body,
          scheduledTZDateTime.add(Duration(seconds: 30 * i)),
          await _notificationDetails(alarm),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: 
            UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }
  }

  static void resetAlarm() {
    NotificationApi.cancelAll();
    NotificationApi.scheduleNotification();
  }

  static void cancelAlarm(Alarm alarm) async {
    if (alarm.currentAlarm) {
      Alarm updatedAlarm = updateCurrentAlarm(alarm, false, false);
      TokiDatabase.instance.updateAlarm(updatedAlarm);

      resetAlarm();
    }
  }

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();

  static Future<List<PendingNotificationRequest>> retrievePendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}