import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maze/maze.dart';
import 'package:toki/providers/styles.dart';

class MazePuzzle extends StatelessWidget { 
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const MazePuzzle({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);

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
              completePuzzle(context, test);
            },
          ),
        ),
      ],
    );
  }

  int _getNumOfColumns() {
    if (difficulty == 1) {
      return 5;
    } else if (difficulty == 2) {
      return 7;
    } else if (difficulty == 3) {
      return 10;
    }

    throw Exception('difficulty $difficulty is not 1, 2, or 3');
  }
  int _getNumOfRows() {
    if (difficulty == 1) {
      return 5;
    } else if (difficulty == 2) {
      return 7;
    } else if (difficulty == 3) {
      return 10;
    }

    throw Exception('difficulty $difficulty is not 1, 2, or 3');
  }
}