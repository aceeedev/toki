import 'dart:math';
import 'matching_icons.dart';

class PuzzleHelper {
  final puzzleList = [const MatchingIcons()];

  randomPuzzle() {
    final _random = Random();
    return puzzleList[_random.nextInt(puzzleList.length)];
  }
}