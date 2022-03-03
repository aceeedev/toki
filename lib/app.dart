import 'package:flutter/material.dart';
import 'alarm_page.dart';
import 'leaderboard_page.dart';
import 'settings_page.dart';
import 'styles.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedPage = 1;
  final _pageOptions = const [
    LeaderboardPage(),
    AlarmPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment_outlined), 
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Styles.selectedAccentColor[100],
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.assessment_rounded),
              ), 
            ),
            label: 'Leaderboard'
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.alarm_outlined), 
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Styles.selectedAccentColor[100],
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.alarm_rounded),
              ), 
            ),
            label: 'Alarms'
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined), 
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Styles.selectedAccentColor[100],
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.settings_rounded),
              ), 
            ), 
            label: 'Settings'
          ),
        ],
        selectedItemColor: Styles.selectedAccentColor[700],
        iconSize: 35.0,
        elevation: 0.0,
        selectedFontSize: 0.0,
        unselectedItemColor: Styles.selectedAccentColor, /*Colors.grey[400],*/
        currentIndex: selectedPage,
        onTap: (index){
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  } 
}