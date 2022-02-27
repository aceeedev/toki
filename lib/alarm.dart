import 'package:flutter/material.dart';
import 'styles.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const Text(
                  '7:30 AM',
                  style: Styles.alarmTitle
                ),
                RichText(
                  text: TextSpan(
                    style: Styles.textDefault,
                    children: <TextSpan>[
                      TextSpan(text: 'S ', style: Styles.alarmDateUnselected),
                      const TextSpan(text: 'M '),
                      const TextSpan(text: 'T '),
                      const TextSpan(text: 'W '),
                      const TextSpan(text: 'T '),
                      const TextSpan(text: 'F '),
                      TextSpan(text: 'S', style: Styles.alarmDateUnselected),
                    ],
                  ),
                ),
                Text(
                  'Alarm Name',
                  style: Styles.textDefault
                  )
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
                activeTrackColor: Styles.selectedAccentColor,
                activeColor: Styles.selectedAccentColor[700],
              ),
            ),   
          ],
        ),
      ),
    );
  }
}