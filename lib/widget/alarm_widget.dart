import 'package:flutter/material.dart';
import '../styles.dart';

class AlarmWidget extends StatefulWidget {
  const AlarmWidget({Key? key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<AlarmWidget> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Align( // you have to wrap in an align because it they are in another container, needed to change size
      child: SizedBox( 
        height: 100,
        width: 250,
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}