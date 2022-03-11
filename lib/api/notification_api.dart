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


  static tz.TZDateTime _convertDateTimeToTZ(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, time.second);

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


    print(alarmSelectedWeekdays);
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
    int weekdaysBetweenNowAndNextAlarm = nextWeekdayAlarm - todayWeekday;
    print('diff: $weekdaysBetweenNowAndNextAlarm');

    for (int i = 0; i < 6; i++) {
      scheduleNotification(
        alarm: alarm,
        delay: Duration(days: weekdaysBetweenNowAndNextAlarm, seconds: 30 * i),
        currentNotId: alarm.id! + i,
      );
    }
  }

  static void scheduleNotification({
    required Alarm alarm, 
    Duration delay = Duration.zero,
    required int currentNotId,
    }) async {
    final int id = currentNotId;
    final String title = '${DateFormat('h:mm a').format(alarm.time)} Alarm';
    const String body = 'Click this notification to turn off the alarm!';
    final String payload = alarm.id.toString() + " " + currentNotId.toString();

    final scheduledDate = _convertDateTimeToTZ(alarm.time.add(delay));

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

  /*static Future showNotification({
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

  static void loopScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDateTime,
    required Map selectedDays,
    required int firstNotId,
    required int lastNotId,
  }) async {
    int numSelectedDays = 0;
    for (var element in ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']) {
      if (selectedDays[element]) {
        numSelectedDays++;
      }
    }

    for (int num = 0; num < 10; num++) {
      print('firstNotId: ${firstNotId + (num * numSelectedDays) - 1}');
      print('lastNotId ${firstNotId + ((num + 1) * numSelectedDays) - 1}');
      showSheduledNotification(
        title: title,
        body: body,
        payload: payload,
        scheduledDateTime: scheduledDateTime.add(Duration(seconds: (30 * num))),
        selectedDays: selectedDays,
        firstNotId: firstNotId + (num * numSelectedDays),
        lastNotId: firstNotId + ((num + 1) * numSelectedDays) - 1,
      );
    }
  }

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
      print(i);
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
  }*/

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();
}