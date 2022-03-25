import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class CreateForm with ChangeNotifier{
  DateTime _time = DateTime.now();
  String _ringtoneName = '';
  String _ringtoneSound = '';
  AudioCache cache = AudioCache(prefix: 'assets/audios/');
  AudioPlayer? player;

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
  }

  void setRingtoneName(String newRingtoneName) {
    _ringtoneName = newRingtoneName;
    notifyListeners();
  }

  void setRingtoneSound(String newRingtoneSound) {
    _ringtoneSound = newRingtoneSound;
    notifyListeners();
  }

  void playSound(String sound) async {
    stopSound();

    player = await cache.play(sound);
    await Future.delayed(const Duration(seconds: 5));
    stopSound();

    //player = null;
  }

  void stopSound() {
    if (player != null) {
      player!.stop();
    }
  }
}