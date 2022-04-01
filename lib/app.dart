import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/model/setting.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/backend/notification_api.dart';
import 'package:toki/page/leaderboard_page.dart';
import 'package:toki/page/alarm_page.dart';
import 'package:toki/page/puzzle_page.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';
import 'package:toki/main.dart';
import 'package:toki/config.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int selectedPage = 1;
  late List _pageOptions;

  @override
  void initState() {
    super.initState();

    _pageOptions = const [
      LeaderboardPage(),
      AlarmPage(),
      PuzzlePage(),
    ];

    checkForUpdate();
    asyncFunc();

    NotificationApi.init(initScheduled: true);
    listenNotifications();

    WidgetsBinding.instance?.addObserver(this);
  }

  void asyncFunc() async {
    final dir = await getApplicationDocumentsDirectory();
    print(dir.path);
  }

  /// function runs when there has been an update to the app
  Future checkForUpdate() async {
    await TokiDatabase.instance.initializeInsert();

    String newVersion = Config().version;
    Setting versionSetting = await TokiDatabase.instance.readSetting(null, 'Version');

    if (newVersion != versionSetting.settingData) {
      print('updated');
      Setting updatedSetting = Setting(
        id: versionSetting.id,
        name: versionSetting.name,
        settingData: newVersion,
      );
      TokiDatabase.instance.updateSetting(updatedSetting);

      // put functions to run if updated here
      Setting lightNightModeSetting = const Setting(
          name: 'Light/Night Mode',
          settingData: 'light',
      );
      await TokiDatabase.instance.createSetting(lightNightModeSetting);
    }

    context.read<Styles>().setStyles();
  }

  void listenNotifications() =>
    NotificationApi.onNotifications.stream.listen((onClickedNotification));

  void onClickedNotification(String? payload) async {
    // get alarm from db
    Alarm alarm = await TokiDatabase.instance.readAlarm(int.parse(payload!));

    List<dynamic> randomPuzzle = await PuzzleHelper().randomPuzzle(context);

    //build(context);
    main();

    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => PuzzleTemplate(
        puzzleWidget: randomPuzzle[0],
        alarm: alarm,
        puzzleName: randomPuzzle[1],
        test: false,
        completePuzzle: PuzzleHelper.completePuzzle,
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<Styles>().backgroundColor,
      body: _pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: context.watch<Styles>().backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment_outlined), 
            activeIcon: Container(
              decoration: BoxDecoration(
                color: context.watch<Styles>().selectedAccentColor[100],
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
                color: context.watch<Styles>().selectedAccentColor[100],
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
            icon: const Icon(Icons.extension_outlined), 
            activeIcon: Container(
              decoration: BoxDecoration(
                color: context.watch<Styles>().selectedAccentColor[100],
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.extension)
              ), 
            ), 
            label: 'Puzzles'
          ),
        ],
        selectedItemColor: context.watch<Styles>().selectedAccentColor[700],
        iconSize: 35.0,
        elevation: 0.0,
        selectedFontSize: 0.0,
        unselectedItemColor: context.watch<Styles>().selectedAccentColor,
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