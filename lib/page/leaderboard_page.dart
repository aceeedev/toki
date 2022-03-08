import 'package:flutter/material.dart';
import 'package:toki/database_helpers.dart';
import '../api/notification_api.dart';
import '../widget/page_title.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle('Leaderboard'),
          TextButton(
            child: const Text('Simple Notification'),
            onPressed: () => NotificationApi.showNotification(
              title: 'Hello',
              body: 'Test notification',
              payload: 'hello.test'
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            child: const Text('Scheduled Notification'),
            onPressed: () {
              NotificationApi.showSheduledNotification(
                title: 'Schedule test',
                body: 'today at whatever',
                payload: 'schedule',
                scheduledDateTime: DateTime.now().add(const Duration(seconds: 12)),
                selectedDays: {'Mo': true},
                firstNotId: 0,
                lastNotId: 0,
              );

              const snackBar = SnackBar(
                content: Text(
                  'Scheduled in 12 seconds',
                  style: TextStyle(fontSize: 24),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          ),
          const SizedBox(height: 24),
          TextButton(
            child: const Text('Cancel all alarms'),
            onPressed: () {
              NotificationApi.cancelAll();

              print('cancelled alarms');
            }
          ),
          const SizedBox(height: 24),
          TextButton(
            child: const Text('getLastId'),
            onPressed: () async {
              print(await TokiDatabase.instance.getLastId());
            }
          ),
          const Center(
            child: Text(
              'Coming Soon',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ]
      ),
    );
  }
}