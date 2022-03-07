import 'package:flutter/material.dart';
import 'app.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(const MaterialApp(home: MyApp()));
}