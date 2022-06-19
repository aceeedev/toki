import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';

class CompleteWord extends StatefulWidget { 
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const CompleteWord({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);

  @override
  State<CompleteWord> createState() => _CompleteWordState();
}
class _CompleteWordState extends State<CompleteWord> {
  late String diff;

  late int numOfRounds;
  int currentRound = 1;
  late String word;
  List<String> usedWords = [];
  late String missingLetterWord;
  late int indexOfMissingLetter;
  late List<TextButton> listOfLetterButtons;

  @override
  void initState() {
    super.initState();
    PuzzleHelper.startStopwatch();

    numOfRounds = _getNumOfRounds();
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

  int _getNumOfRounds() {
    if (widget.difficulty == 1) {
      diff = 'Easy';
      return 2;
    } else if (widget.difficulty == 2) {
      diff = 'Medium';
      return 3;
    } else if (widget.difficulty == 3) {
      diff = 'Hard';
      return 5;
    }

    throw Exception('difficulty ${widget.difficulty} is not 1, 2, or 3');
  }

  void _initWord() {
    word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];

    while (usedWords.contains(word)) {
      word = PuzzleHelper.getWords()[Random().nextInt(PuzzleHelper.getWords().length)];
    }

    usedWords.add(word);

    indexOfMissingLetter = Random().nextInt(word.length);
    missingLetterWord = word.substring(0, indexOfMissingLetter) + '_' + word.substring(indexOfMissingLetter + 1);
    listOfLetterButtons = _createLetterButtons(word[indexOfMissingLetter]);
  }

  void _nextRound() {
    currentRound += 1;

    if (currentRound > numOfRounds) {
      if (!widget.test) {
        int elapsedTime = PuzzleHelper.stopStopwatch();
        PuzzleHelper.addScoreToLeaderboard('completeWord$diff', elapsedTime);
      }

      widget.completePuzzle(context, widget.test);
    }

    setState(() => _initWord());
  }

  List<TextButton> _createLetterButtons(String missingLetter) {
    List<TextButton> listOfLetterButtons = [];
    
    // add correct letter
    listOfLetterButtons.add(
        TextButton(
          onPressed: () => _nextRound(), 
          child: Text(
            missingLetter,
            style: context.read<Styles>().largeTextDefault,
          ),
          style: context.read<Styles>().leaderboardButton,
        )
    );

    // add incorrect letters
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    for (int i = 0; i < 4; i++) {
      String randomLetter = String.fromCharCodes(Iterable.generate(
        1, (_) => chars.codeUnitAt(Random().nextInt(chars.length))
      ));
      // make sure randomLetter is not the missingLetter
      while (randomLetter == missingLetter) {
        randomLetter = String.fromCharCodes(Iterable.generate(
          1, (_) => chars.codeUnitAt(Random().nextInt(chars.length))
        ));
      }

      listOfLetterButtons.add(
        TextButton(
          onPressed: () => setState(() {
            currentRound = 1;
            _initWord();
          }), 
          child: Text(
            randomLetter,
            style: context.read<Styles>().largeTextDefault,
          ),
          style: context.read<Styles>().leaderboardButton,
        ),
      );
    }

    listOfLetterButtons.shuffle();

    return listOfLetterButtons;
  }
}