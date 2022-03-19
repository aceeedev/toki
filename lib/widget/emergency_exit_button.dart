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
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          child: Container(
            height: 60.0,
            width: 60.0,
            child: Icon(
              Icons.warning,
              size: 48.0,
              color: context.watch<Styles>().colorLogoRed[900],
            ),
            decoration: BoxDecoration(
              color: context.watch<Styles>().colorLogoRed,
              shape: BoxShape.circle
            ),
          ),
          onTapUp: (_) => {
            _timer!.cancel()
          },
          onTapDown: (_) => {
            _timer = Timer(const Duration(seconds: 10), () {
              widget.completePuzzle(context, widget.test);
            })
          },
        ),
      ),
    );
  }
}