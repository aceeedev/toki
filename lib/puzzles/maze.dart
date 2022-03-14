import 'package:flutter/material.dart';
import 'package:maze/maze.dart';
import 'package:toki/api/notification_api.dart';
import 'package:toki/styles.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/emergency_exit_button.dart';

class MazePuzzle extends StatelessWidget { 
  final Alarm alarm;

  const MazePuzzle({Key? key, required this.alarm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle('Matching Icons'),
          EmergencyExitButton(alarm: alarm),
          Expanded(
            child: Center(
              child: Maze(
                player: MazeItem('assets/images/smile.png', ImageType.asset),
                finish: MazeItem('assets/images/finish_flag.png', ImageType.asset),
                columns: 7,
                rows: 7,
                wallColor: Styles.selectedAccentColor,
                onFinish: () {
                  NotificationApi.resetAlarm();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}