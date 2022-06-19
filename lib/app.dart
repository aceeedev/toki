import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/model/setting.dart';
import 'package:toki/backend/notification_api.dart';
import 'package:toki/page/leaderboard_page.dart';
import 'package:toki/page/alarm_page.dart';
import 'package:toki/page/puzzle_page.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';
import 'package:toki/main.dart';
import 'package:toki/config.dart';
import 'package:toki/model/puzzle.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int selectedPage = 1;
  late List _pageOptions;

  final RateMyApp rateMyApp = RateMyApp(
    minDays: 5,
    minLaunches: 4,

    remindDays: 3,
    remindLaunches: 3,

    appStoreIdentifier: '1615680878',
  );

  @override
  void initState() {
    super.initState();

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateAppPopUp();
      }
    });

    _pageOptions = [
      const LeaderboardPage(),
      AlarmPage(rateAppPopUp: rateAppPopUp),
      const PuzzlePage(),
    ];

    checkForUpdate();
    asyncFunc();

    NotificationApi.init(initScheduled: true);
    listenNotifications();

    WidgetsBinding.instance.addObserver(this);
  }

  void rateAppPopUp() {
    rateMyApp.showStarRateDialog(
      context,
      title: 'Rate Toki Alarm?',
      message: 'Are you enjoying Toki Alarm? Please take a little bit of your time to leave a rating:',
      actionsBuilder: (context, stars) {
        return [
          TextButton(
            child: const Text('No'),
              onPressed: () async {
               Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.no);
              },
            ),
          TextButton(
            child: const Text('Ok'),
            style: TextButton.styleFrom(
              side: BorderSide(color: context.watch<Styles>().selectedAccentColor, width: 3.0),
            ),
            onPressed: () async {
              stars = stars ?? 0;

              if (stars! < 4) {
                Navigator.pop<RateMyAppDialog>(context);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async {
                        await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);

                        return true;
                      },
                      child: AlertDialog(
                        title: const Text('Feedback'),
                        content: const Text('Before you review please respond to the form below so we can improve Toki.'),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0),
                        )),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                              rateMyApp.launchStore();
                            }, 
                            child: const Text('Rate')
                          ),
                          TextButton(
                            onPressed: () async {
                              await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
                              Navigator.pop(context);
                            }, 
                            child: const Text('Cancel')
                          ),
                          TextButton(
                            onPressed: () async {
                              // google form feedback form
                              const url = 'https://forms.gle/Zxw7AuPjoBEvBJeX6';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }, 
                            child: const Text('Feedback Form'),
                            style: TextButton.styleFrom(
                              side: BorderSide(color: context.watch<Styles>().selectedAccentColor, width: 3.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                );
              } else {
                Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                if ((await rateMyApp.isNativeReviewDialogSupported) ?? false) {
                  await rateMyApp.launchNativeReviewDialog();
                }

                rateMyApp.launchStore();
              }                
            },
          ),
        ];
      },
      ignoreNativeDialog: true,
      dialogStyle: const DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20.0),
        dialogShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
        )),
      ),
      starRatingOptions: const StarRatingOptions(),
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),

    );
  }

  void asyncFunc() async {
    final dir = await getApplicationDocumentsDirectory();
    print(dir.path);
  }

  /// Function runs when there has been an update to the app
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
      // uncomment when memory is ready to be releaased
      /*const Puzzle puzzle = Puzzle(
        name: 'Memory',
        difficulty: 2,
        enabled: true,
      );
      TokiDatabase.instance.createPuzzle(puzzle);*/
      const Puzzle puzzle = Puzzle(
        name: 'Complete the Word',
        difficulty: 2,
        enabled: true,
      );
      TokiDatabase.instance.createPuzzle(puzzle);
    }

    context.read<Styles>().setStyles();
  }

  void listenNotifications() =>
    NotificationApi.onNotifications.stream.listen((onClickedNotification));

  void onClickedNotification(String? payload) async {
    // get alarm from db
    Alarm alarm = await TokiDatabase.instance.readAlarm(int.parse(payload!));

    List<dynamic> randomPuzzle = await PuzzleHelper().randomPuzzle(context);

    main();

    await Navigator.of(context).push(MaterialPageRoute<void>(
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