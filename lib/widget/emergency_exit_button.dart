import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/model/alarm.dart';

class EmergencyExitButton extends StatefulWidget {
  final Alarm? alarm;
  final Function completePuzzle;
  final bool test;

  const EmergencyExitButton({Key? key, this.alarm, required this.completePuzzle, required this.test}) : super(key: key);

  @override
  State<EmergencyExitButton> createState() => _EmergencyExitButtonState();
}

class _EmergencyExitButtonState extends State<EmergencyExitButton> {
  Timer? _timer;
  String countDownText = '';
  bool clickedOff = true;

  @override
  void dispose() {
    var f = _timer;
    if (f != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            countDownText,
            style: context.watch<Styles>().mediumTextDefault,
          ),
          GestureDetector(
            child: Container(
              height: 60.0,
              width: 60.0,
              child: Icon(
                Icons.warning,
                size: 48.0,
                color: context.watch<Styles>().colorLogoRed[900],
              ),
              decoration: BoxDecoration(
                color: clickedOff ? context.watch<Styles>().colorLogoRed : context.watch<Styles>().colorLogoRed[700],
                shape: BoxShape.circle
              ),
            ),
            onTapUp: (_) {
              setState(() {
                clickedOff = true;
                countDownText = '';
              });
              
              _timer!.cancel();
            },
            onTapDown: (_) {
              setState(() => clickedOff = false);
              int i = 10;
              setState(() => countDownText = 'Emergency exit in $i seconds...');
          
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
                i--;
                setState(() => countDownText = i != 1 ? 'Emergency exit in $i seconds...' : 'Emergency exit in $i second...');

                if (i == 1) {
                  widget.completePuzzle(context, widget.test);
                  _timer!.cancel();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}