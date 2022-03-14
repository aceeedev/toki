import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toki/api/notification_api.dart';
import 'package:toki/widget/page_title.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle('Settings'),
          TextButton(
            child: const Text('Delete all notifications'),
            onPressed: () {
              NotificationApi.cancelAll();
              print('Deleted all notifications');
            },
          ),
          TextButton(
            child: const Text('All current Notifications'),
            onPressed: () async {
              List<PendingNotificationRequest> listOfPendingNotifications = await NotificationApi.retrievePendingNotifications();
              for (PendingNotificationRequest pendingNotification in listOfPendingNotifications) {
                print(pendingNotification.id);
                print(pendingNotification.title);
                print(pendingNotification.body);
                print(pendingNotification.payload);
                print('/n');
              }
            },
          ),
          TextButton(
            child: const Text('Notification test'),
            onPressed: () => NotificationApi().getNextAlarm()
          ),
        ]
      ),
    );
  }
}