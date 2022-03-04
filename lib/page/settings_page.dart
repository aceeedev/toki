import 'package:flutter/material.dart';
import '../widget/page_title.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          PageTitle('Settings'),
        ]
      ),
    );
  }
}