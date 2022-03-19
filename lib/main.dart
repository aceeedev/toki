import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Styles()),
      ],
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}