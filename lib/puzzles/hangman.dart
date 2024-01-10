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
  late List<List<CustomTextButton>> listOfListOfLetterButtons;

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lives: $numOfLives',
              style: context.watch<Styles>().largeTextDefault,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          maskedWord,
          style: context.watch<Styles>().largeTextDefault,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        lettersRow(listOfListOfLetterButtons[0]),
        lettersRow(listOfListOfLetterButtons[1]),
        lettersRow(listOfListOfLetterButtons[2]),
      ],
    );
  }

  int _getNumOfLives() {
    if (widget.difficulty == 1) {
      diff = 'Easy';
      return 15;
    } else if (widget.difficulty == 2) {
      diff = 'Medium';
      return 10;
    } else if (widget.difficulty == 3) {
      diff = 'Hard';
      return 6;
    }

    throw Exception('difficulty ${widget.difficulty} is not 1, 2, or 3');
  }

  void _initWord() {
    word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];

    while (usedWords.contains(word)) {
      word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];
    }

    usedWords.add(word);

    maskedWord = ' _ ' * word.length;
    maskedWord = maskedWord.substring(1, maskedWord.length - 1);

    listOfListOfLetterButtons = _createLetterButtons();
  }

  void checkLetter(String letter) {
    if (!usedLetters.contains(letter)) {
      usedLetters.add(letter);

      if (word.contains(letter)) {
        for (int i = 0; i < word.length; i++) {
          if (word[i] == letter) {
            setState(() {
              maskedWord = maskedWord.substring(0, i * 3) + letter + maskedWord.substring((i * 3) + 1);
            });
          }
        }

        if (!maskedWord.contains('_')) {
          // if (!widget.test) {
          int elapsedTime = PuzzleHelper.stopStopwatch();
          // print(elapsedTime);
          PuzzleHelper.addScoreToLeaderboard('hangman$diff', elapsedTime);
          // }

          widget.completePuzzle(context, widget.test);
        }
      } else {
        setState(() => numOfLives--);

        // reset game if ran out of lives
        if (numOfLives <= 0) {
          setState(() {
            _initWord();
            numOfLives = _getNumOfLives();
            listOfListOfLetterButtons = _createLetterButtons();
            usedLetters = [];
          });
        }
      }
    }
  }

  List<List<CustomTextButton>> _createLetterButtons() {
    List<List<CustomTextButton>> listOfLetterButtons = [[], [], []];

    const List<List<String>> keyboardLetters = [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'], 
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['z', 'x', 'c', 'v', 'b', 'n', 'm']];
    
    for (int row = 0; row < keyboardLetters.length; row++) {
      for (int letter = 0; letter < keyboardLetters[row].length; letter++) {
        listOfLetterButtons[row].add(CustomTextButton(
          value: keyboardLetters[row][letter],
          checkLetter: checkLetter,
        ));
      }
    }

    return listOfLetterButtons;
  }

  Row lettersRow(List<CustomTextButton> listOfButtons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: listOfButtons,
    );
  }
}

class CustomTextButton extends StatefulWidget {
  final String value;
  final Function checkLetter;
  bool selected = false;

  CustomTextButton({Key? key, required this.value, required this.checkLetter}) : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() {
          if (!widget.selected) {
            widget.checkLetter(widget.value);
            widget.selected = true;
          }
        }), 
        child: Text(
          widget.value,
          style: context.read<Styles>().largeTextDefault,
        ),
        style: widget.selected ? 
          context.read<Styles>().dayButtonStyleNotSelected :
          context.read<Styles>().dayButtonStyleSelected,
      ),
    );
  }
}