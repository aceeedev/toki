import 'package:flutter/material.dart';
import 'package:toki/backend/database_helpers.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:games_services/games_services.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/backend/notification_api.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/emergency_exit_button.dart';
import 'package:toki/puzzles/matching_icons.dart';
import 'package:toki/puzzles/maze.dart';

class PuzzleHelper {
  static Stopwatch? stopwatch;

  Future<List<Map<String, Widget>>> createPuzzleList(BuildContext context) async {
    return [
      {'Matching Icons': MatchingIcons(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Matching Icons')).difficulty,
        test: false,
      )},
      {'Maze': MazePuzzle(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Maze')).difficulty,
        test: false,
      )}
    ];
  } 

  /// returns [Widget randomPuzzle, String randomPuzzleName]
  Future<List<dynamic>> randomPuzzle(BuildContext context) async {
    final _random = Random();
    final List<Map<String, Widget>> puzzleList = await createPuzzleList(context);
    Map<String, Widget> randomPuzzle = puzzleList[_random.nextInt(puzzleList.length)];

    while(!(await TokiDatabase.instance.readPuzzle(null, randomPuzzle.keys.toList()[0])).enabled) {
      randomPuzzle = puzzleList[_random.nextInt(puzzleList.length)];
    }

    return [randomPuzzle.values.first, randomPuzzle.keys.toList().first];
  }

  static void completePuzzle(BuildContext context, bool test) {
    if (!test) {
      NotificationApi.resetAlarm();
    }
    Navigator.pop(context);
  }

  static void openTestPuzzle(BuildContext context, String puzzleName, bool test) async {
    Widget? puzzleWidget;

    if (puzzleName == 'Matching Icons') {
      puzzleWidget = MatchingIcons(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Matching Icons')).difficulty,
        test: true,
      );
    } else if (puzzleName == 'Maze') {
      puzzleWidget = MazePuzzle(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Maze')).difficulty,
        test: true,
      );
    } else {
      throw Exception('Puzzle Name $puzzleName not found');
    }

    if (puzzleWidget != null) {
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => PuzzleTemplate(
          puzzleWidget: puzzleWidget!,
          puzzleName: puzzleName,
          completePuzzle: completePuzzle,
          test: true,
        )
      ));
    } else {
      throw Exception('The puzzleWidget is null'); 
    }
  }

  static void startStopwatch() {
    stopwatch = Stopwatch();
    stopwatch!.start();
  }

  static int stopStopwatch() {
    stopwatch!.stop();
    return (stopwatch!.elapsed.inMilliseconds / 10).round();
  }

  static void addScoreToLeaderboard(String iOSLeaderboardID, int score) {
    GamesServices.submitScore(
      score: Score(
        iOSLeaderboardID: iOSLeaderboardID,
        value: score,
      )
    );
  }
}

class PuzzleTemplate extends StatelessWidget {
  final Widget puzzleWidget;
  final Alarm? alarm;
  final String puzzleName;
  final Function completePuzzle;
  final bool test;
  const PuzzleTemplate({Key? key, required this.puzzleWidget, this.alarm, required this.puzzleName, required this.completePuzzle, required this.test}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: context.watch<Styles>().backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              PageTitle(
                title: puzzleName,
              ),
              EmergencyExitButton(
                alarm: alarm, 
                completePuzzle: completePuzzle,
                test: test
                ),
              Expanded(
                child: Center(
                  child: puzzleWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}