import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
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

  static Future _notificationDetails() async {
    const sound = 'digital_alarm_sound.wav';
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id 1',
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


  static tz.TZDateTime _convertDateTimeToTZ(DateTime time, int daysUntilNextAlarm) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day + daysUntilNextAlarm, time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
      ? scheduledDate.add(const Duration(days: 1))
      : scheduledDate;
  }

  static void initialScheduleNotifications(Alarm alarm) async {
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
        nextWeekdayAlarm = alarmSelectedWeekdays[i];
        break;
      }
      // in the case that the next day is before today's weekday
      if (i == alarmSelectedWeekdays.length - 1) {
        nextWeekdayAlarm = alarmSelectedWeekdays[0];
        print('beginning');
        break;
      }
    }
    int weekdaysBetweenNowAndNextAlarm;
    if (nextWeekdayAlarm == todayWeekday) {
      // if alarm time is less than now and today schedule for next week
      if (alarm.time.hour < DateTime.now().hour || (alarm.time.hour == DateTime.now().hour && alarm.time.minute <= DateTime.now().minute)) {
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
    print('diff: $weekdaysBetweenNowAndNextAlarm');

    for (int i = 0; i < 6; i++) {
      scheduleNotification(
        alarm: alarm,
        delay: Duration(seconds: 30 * i),
        daysUntilNextAlarm: weekdaysBetweenNowAndNextAlarm,
        currentNotId: alarm.id! + i,
      );
    }
  }
  
  static void scheduleNextNotification({
    required Alarm alarm,
    Duration delay = Duration.zero,
    required int currentNotId,
  }) async {
    for (int i = alarm.firstNotId; i <= currentNotId; i++) {
      scheduleNotification(
        alarm: alarm,
        delay: Duration(seconds: 30 * (i + 9)),
        currentNotId: i,
      );
    }
  }

  static void scheduleNotification({
    required Alarm alarm, 
    Duration delay = Duration.zero,
    int daysUntilNextAlarm = 0,
    required int currentNotId,
    }) async {
    final int id = currentNotId;
    final String title = '${DateFormat('h:mm a').format(alarm.time)} Alarm';
    const String body = 'Click this notification to turn off the alarm!';
    final String payload = alarm.id.toString() + " " + currentNotId.toString();

    final scheduledDate = _convertDateTimeToTZ(alarm.time.add(delay), daysUntilNextAlarm);

    _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
  }

  static void resetAlarm(Alarm alarm) {
    NotificationApi.cancelAlarm(alarm);
    NotificationApi.initialScheduleNotifications(alarm);
  }

  static void cancelAlarm(Alarm alarm) {
    for (int i = alarm.firstNotId; i <= alarm.lastNotId; i++) {
      cancel(i);
    }
  }

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();

  static Future<List<PendingNotificationRequest>> retrievePendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}