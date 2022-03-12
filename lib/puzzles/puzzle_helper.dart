import 'package:flutter/material.dart';
import 'dart:math';
import 'package:toki/model/alarm.dart';
import 'package:toki/puzzles/matching_icons.dart';
import 'package:toki/puzzles/maze.dart';

class PuzzleHelper {
  Alarm alarm;

  PuzzleHelper(this.alarm);

  List<Widget> createPuzzleList() {
    return [
      //MatchingIcons(alarm: alarm),
      MazePuzzle(alarm: alarm)
    ];
  } 

  Widget randomPuzzle() {
    final _random = Random();
    final List<Widget> puzzleList = createPuzzleList();

    return puzzleList[_random.nextInt(puzzleList.length)];
  }
}