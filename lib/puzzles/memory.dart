import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';

// TODO: never finished

class MemoryGame extends StatefulWidget {
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const MemoryGame({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);
  
  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<Button> listofButtons;
  late List<List<dynamic>> listOfRoundIcons;
  late int numOfRounds;
  late String diff;

  int currentRound = 0;

  @override
  void initState() {
    super.initState();

    if (widget.difficulty == 1) {
      numOfRounds = 3;
      diff = 'Easy';
    } else if (widget.difficulty == 2) {
      numOfRounds = 5;
      diff = 'Medium';
    } else if (widget.difficulty == 3) {
      numOfRounds = 7;
      diff = 'Hard';
    }
    listofButtons = createListOfButtons();
    listOfRoundIcons = createListOfRoundIcons();
    PuzzleHelper.startStopwatch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          'Click the buttons in the right order',
          style: context.watch<Styles>().largeTextDefault,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: createChildrenRowOfIcons(listOfRoundIcons, numOfRounds),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: GridView.count(
                children: listofButtons,
                primary: true,
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2,
              ),
            ),
          ),
        ),
      ]
    );
  }

  List<Button> createListOfButtons() {
    List<Button> listOfSpecialIconButtons = [];

    // add the 9 buttons
    for (int i = 0; i < 9; i++) {
      listOfSpecialIconButtons.add(Button(
        checkAllIconsFunc: checkAllIcons,
        completePuzzle: widget.completePuzzle,
        test: widget.test,
        diff: diff,
        id: i,
      ));
    }

    return listOfSpecialIconButtons;
  }

  List<List<dynamic>> createListOfRoundIcons() {
    return List.filled(numOfRounds, [Icons.square_rounded, context.read<Styles>().secondBackgroundColor]);
  }

  List<Widget> createChildrenRowOfIcons(List<List<dynamic>> listOfIconData, int length) {
    return List<Widget>.generate(length, (int index) => Icon(
      listOfIconData[index][0],
      size: 48.0,
      color: listOfIconData[index][1],
    ));
  }

  bool checkAllIcons() {
    /*for (Button button in listofButtons) {
      if ((button.isCorrectIcon && !button.pressed) || (!button.isCorrectIcon && button.pressed)) {
        return false;
      }
    }*/

    return /*true*/ false;
  }
}

class Button extends StatefulWidget {
  final Function checkAllIconsFunc;
  final Function completePuzzle;
  final bool test;
  final String diff;
  final int id;
  Button({Key? key, required this.checkAllIconsFunc, required this.completePuzzle, required this.test, required this.diff, required this.id}) : super(key: key);
  
  bool pressed = false;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 100,
        height: 100,
        child: IconButton(
          onPressed: () {
            setState(() => widget.pressed = !widget.pressed);

            if (widget.checkAllIconsFunc()) {
              // if (!widget.test) {
              int elapsedTime = PuzzleHelper.stopStopwatch();
              // print(elapsedTime);
              PuzzleHelper.addScoreToLeaderboard(
                  'memory${widget.diff}', elapsedTime);
              // }

              widget.completePuzzle(context, widget.test);
            }
          }, 
          icon: Icon(
            widget.pressed ? Icons.square_rounded : Icons.crop_square_rounded,
            size: 48.0, 
            color: context.watch<Styles>().selectedAccentColor,
          ),
        ),
      ),
    );
  }
}