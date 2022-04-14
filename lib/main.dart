import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/providers/create_form.dart';
import 'package:toki/providers/main_provider.dart';
import 'package:toki/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => Styles()),
        ChangeNotifierProvider(create: (_) => CreateForm()),
      ],
      child: const MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}