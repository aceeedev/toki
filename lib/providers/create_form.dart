import 'package:flutter/material.dart';


class CreateForm with ChangeNotifier{
  DateTime _time = DateTime.now();
  String _ringtoneName = '';
  String _ringtoneSound = '';

  DateTime get time => _time;
  String get ringtoneName => _ringtoneName;
  String get ringtoneSound => _ringtoneSound;


  void resetTime() {
    _time = DateTime.now();
    notifyListeners();
  }

  void setTime(DateTime newTime) {
    _time = newTime;
    notifyListeners();
    print(_time);
  }

  void setRingtoneName(String newRingtoneName) {
    _ringtoneName = newRingtoneName;
    notifyListeners();
    print(_ringtoneName);
  }

  void setRingtoneSound(String newRingtoneSound) {
    _ringtoneSound = newRingtoneSound;
    notifyListeners();
    print(_ringtoneSound);
  }
}