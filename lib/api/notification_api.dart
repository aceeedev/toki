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

  static void showSheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDateTime,
    required Map selectedDays,
    required int firstNotId,
    required int lastNotId,
  }) async {
    List<int> days = [];
    if (selectedDays['Su']) {
      days.add(DateTime.sunday);
    }
    if (selectedDays['Mo']) {
      days.add(DateTime.monday);
    }
    if (selectedDays['Tu']) {
      days.add(DateTime.tuesday);
    }
    if (selectedDays['We']) {
      days.add(DateTime.wednesday);
    }
    if (selectedDays['Th']) {
      days.add(DateTime.thursday);
    }
    if (selectedDays['Fr']) {
      days.add(DateTime.friday);
    }
    if (selectedDays['Sa']) {
      days.add(DateTime.saturday);
    }

    final scheduledDates = _scheduleWeekly(
      Time(scheduledDateTime.hour, scheduledDateTime.minute), 
      days: days
    );
    for (int i = firstNotId; i <= lastNotId; i++) {
      final scheduledDate = scheduledDates[i-firstNotId]; 

      _notifications.zonedSchedule(
        id + i,
        title,
        body,
        scheduledDate,
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
      ? scheduledDate.add(const Duration(days: 1))
      : scheduledDate;
  }

  static List<tz.TZDateTime> _scheduleWeekly(Time time, {required List<int> days}) {
    return days.map((day) {
      tz.TZDateTime scheduledDate = _scheduleDaily(time);

      while (day != scheduledDate.weekday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }).toList();  
  }

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();
}