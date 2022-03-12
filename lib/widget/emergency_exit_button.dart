import 'package:flutter/material.dart';
import 'package:toki/api/notification_api.dart';
import 'package:toki/styles.dart';
import 'package:toki/model/alarm.dart';

class EmergencyExitButton extends StatelessWidget {
  bool clickedOff = true;
  Alarm alarm;

  EmergencyExitButton({Key? key, required this.alarm}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: ElevatedButton(
          child: Icon(
            Icons.warning,
            size: 48.0,
            color: Styles.colorLogoRed[900],
          ),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8.0),
            primary: Styles.colorLogoRed,
          ),
          onPressed: () async {
            clickedOff = false;

            await Future.delayed(const Duration(seconds: 3));

            if (!clickedOff) {
              print('exited');
              NotificationApi.resetAlarm(alarm);
              Navigator.pop(context);
            }
          },
          onFocusChange: (value) {
            print(value);
            clickedOff = true;
          },
        ),
      ),
    );
  }
}