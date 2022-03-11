import 'package:flutter/material.dart';
import 'package:toki/styles.dart';
import 'package:toki/app.dart';

class EmergencyExitButton extends StatelessWidget {
  bool clickedOff = true;

  EmergencyExitButton({Key? key}) : super(key: key);
  
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
              Navigator.pop(context);
            }
          },
          onFocusChange: (value) {
            clickedOff = true;
          },
        ),
      ),
    );
  }
}