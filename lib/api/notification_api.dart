import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    //tz.setLocalLocation(tz.getLocation('America/Los_Angeles'));

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
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        //'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );

  static Future showSheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
    _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleWeekly(const Time(8), days: [DateTime.monday, DateTime.tuesday]),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: 
        UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute, now.second);

    return scheduledDate.isBefore(now)
      ? scheduledDate.add(const Duration(days: 1))
      : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);

    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}