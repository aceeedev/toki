import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maze/maze.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';

class MazePuzzle extends StatefulWidget { 
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const MazePuzzle({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);

  @override
  State<MazePuzzle> createState() => _MazePuzzleState();
}
class _MazePuzzleState extends State<MazePuzzle> {
  late String diff;

  @override
  void initState() {
    super.initState();
    PuzzleHelper.startStopwatch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Complete the maze',
          style: context.watch<Styles>().largeTextDefault,
        ),
        Expanded(
          child: Maze(
            player: MazeItem('assets/images/smile.png', ImageType.asset),
            finish: MazeItem('assets/images/finish_flag.png', ImageType.asset),
            columns: _getNumOfColumns(),
            rows: _getNumOfRows(),
            wallColor: context.watch<Styles>().selectedAccentColor,
            onFinish: () {
              // if (!widget.test) {
              int elapsedTime = PuzzleHelper.stopStopwatch();
              // print(elapsedTime);
              PuzzleHelper.addScoreToLeaderboard('maze$diff', elapsedTime);
              // }

              widget.completePuzzle(context, widget.test);
            },
          ),
        ),
      ],
    );
  }

  int _getNumOfColumns() {
    if (widget.difficulty == 1) {
      diff = 'Easy';
      return 5;
    } else if (widget.difficulty == 2) {
      diff = 'Medium';
      return 7;
    } else if (widget.difficulty == 3) {
      diff = 'Hard';
      return 10;
    }

    throw Exception('difficulty ${widget.difficulty} is not 1, 2, or 3');
  }
  int _getNumOfRows() {
    if (widget.difficulty == 1) {
      return 5;
    } else if (widget.difficulty == 2) {
      return 7;
    } else if (widget.difficulty == 3) {
      return 10;
    }

    throw Exception('difficulty ${widget.difficulty} is not 1, 2, or 3');
  }
}