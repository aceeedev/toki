import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toki/api/notification_api.dart';
import 'package:toki/styles.dart';
import 'package:toki/widget/page_title.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 10.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: Icon(
                  Icons.arrow_back,
                  size: 48.0,
                  color: Styles.selectedAccentColor,
                )
              ),
            ),
          ),
          const PageTitle(
            title: 'Settings',
            padding: false,
          ),
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