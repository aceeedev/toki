import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';

class WordSearchGame extends StatefulWidget { 
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const WordSearchGame({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);

  @override
  State<WordSearchGame> createState() => _WordSearchState();
}
class _WordSearchState extends State<WordSearchGame> {
  late String diff;
  late String word;
  late int length;

  List<CustomTextButton> listOfLetterButtons = [];
  
  @override
  void initState() {
    super.initState();
    PuzzleHelper.startStopwatch();

    _initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select the letters below to find the word: $word',
          style: context.watch<Styles>().largeTextDefault,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: length,
            children: listOfLetterButtons,
          ),
        ),
      ],
    );
  }

  int _getGridLength() {
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

  void _initGame() {
    word = word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];
    length = _getGridLength();

    while (word.length > length) {
      word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];
    }

    const String chars = 'abcdefghijklmnopqrstuvwxyz';
    // init the list of letters without the word
    for (int i = 0; i < pow(length, 2); i++) {
      listOfLetterButtons.add(CustomTextButton(
        letter: String.fromCharCodes(Iterable.generate(
          1, (_) => chars.codeUnitAt(Random().nextInt(chars.length)))), 
        isWord: false, 
        checkWord: checkWord
      ));
    }

    // determine if the word will be horizontal or vertical
    final bool randHorVer = Random().nextBool();
    // determine if the word will be backwards
    final bool randDir = Random().nextBool();

    int wordIndex;

    if (randHorVer) {
      // horizontal word
      wordIndex = ((Random().nextInt(length) * length) + (word.length == length ? 0 : Random().nextInt(length - word.length)));

      if (randDir) {
        // not backwards
        for (int i = 0; i < word.length; i++) {
          listOfLetterButtons[wordIndex + i] = CustomTextButton(
            letter: word[i], 
            isWord: true, 
            checkWord: checkWord
          );
        }
      } else {
        // backwards
        for (int i = word.length - 1; i >= 0; i--) {
          listOfLetterButtons[wordIndex + (word.length - 1- i)] = CustomTextButton(
            letter: word[i], 
            isWord: true, 
            checkWord: checkWord
          );
        }
      }
    } else {
      // vertical word
      wordIndex = (((word.length == length ? 0 : Random().nextInt(length - word.length)) * length) + Random().nextInt(length));

      if (randDir) {
        // not backwards
        for (int i = 0; i < word.length; i++) {
          listOfLetterButtons[wordIndex + (i * length)] = CustomTextButton(
            letter: word[i], 
            isWord: true, 
            checkWord: checkWord
          );
        }
      } else {
        // backwards
        for (int i = word.length - 1; i >= 0; i--) {
          listOfLetterButtons[wordIndex + ((word.length - 1 - i) * length)] = CustomTextButton(
            letter: word[i], 
            isWord: true, 
            checkWord: checkWord
          );
        }
      }
    }
  }

  bool checkWord() {
    for (CustomTextButton button in listOfLetterButtons) {
      // player did not win yet
      if ((button.isWord && !button.pressed) || (!button.isWord && button.pressed)) {
        return false;
      }
    }

    if (!widget.test) {
      int elapsedTime = PuzzleHelper.stopStopwatch();
      PuzzleHelper.addScoreToLeaderboard('wordSearch$diff', elapsedTime);
    }

    widget.completePuzzle(context, widget.test);

    return true;
  }
}

class CustomTextButton extends StatefulWidget {
  final String letter;
  final bool isWord;
  final Function checkWord;

  bool pressed = false;

  CustomTextButton({Key? key, required this.letter, required this.isWord, required this.checkWord}) : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() => widget.pressed = !widget.pressed);

        widget.checkWord();
      },
      child: Text(
        widget.letter,
        style: context.read<Styles>().largeTextDefault,
      ),
      style: TextButton.styleFrom(
        elevation: 0.0,
        backgroundColor: context.watch<Styles>().secondBackgroundColor,
        side: BorderSide(
          width: 5.0,
          color: widget.pressed ? context.watch<Styles>().selectedAccentColor : context.watch<Styles>().secondBackgroundColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        
        padding: EdgeInsets.zero,
      ),
    );
  }
}