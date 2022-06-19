import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';

class Hangman extends StatefulWidget { 
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const Hangman({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);

  @override
  State<Hangman> createState() => _HangmanState();
}
class _HangmanState extends State<Hangman> {
  late String diff;

  late int numOfLives;
  late String word;
  List<String> usedWords = [];
  List<String> usedLetters = [];
  late String maskedWord;
  late List<List<TextButton>> listOfListOfLetterButtons;

  @override
  void initState() {
    super.initState();
    PuzzleHelper.startStopwatch();

    numOfLives = _getNumOfLives();
    _initWord();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Complete the word',
          style: context.watch<Styles>().largeTextDefault,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Round $currentRound/$numOfRounds',
                style: context.watch<Styles>().largeTextDefault,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      missingLetterWord,
                      style: context.watch<Styles>().pageTitle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: listOfLetterButtons,
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getNumOfLives() {
    if (widget.difficulty == 1) {
      diff = 'Easy';
      return 9;
    } else if (widget.difficulty == 2) {
      diff = 'Medium';
      return 6;
    } else if (widget.difficulty == 3) {
      diff = 'Hard';
      return 4;
    }

    throw Exception('difficulty ${widget.difficulty} is not 1, 2, or 3');
  }

  void _initWord() {
    word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];

    while (usedWords.contains(word)) {
      word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];
    }

    usedWords.add(word);

    listOfListOfLetterButtons = _createLetterButtons();
  }

  /*if (!widget.test) {
    int elapsedTime = PuzzleHelper.stopStopwatch();
    PuzzleHelper.addScoreToLeaderboard('completeWord$diff', elapsedTime);
  }

  widget.completePuzzle(context, widget.test);*/

  List<TextButton> _createLetterButtons() {
    List<TextButton> listOfLetterButtons = [];

    const List<List<String>> keyboardLetters = [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'], 
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['z', 'x', 'c', 'v', 'b', 'n', 'm']];
    
    for (int row = 0; row < keyboardLetters.length; row++) {
      for (int letter = 0; letter < keyboardLetters[row].length; letter++) {
        // make button of letter index
      }
    }

    return listOfLetterButtons;
  }
}

class CustomTextButton extends StatefulWidget {
  final String value;
  const CustomTextButton({Key? key, required this.value})
      : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => setState(() {
        
      }), 
      child: Text(
        widget.value,
        style: context.read<Styles>().largeTextDefault,
      ),
      style: context.read<Styles>().leaderboardButton,
    );
  }
}