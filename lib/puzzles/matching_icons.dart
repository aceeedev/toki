import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';

class MatchingIcons extends StatefulWidget {
  final Function completePuzzle;
  final int difficulty;
  final bool test;

  const MatchingIcons({Key? key, required this.completePuzzle, required this.difficulty, required this.test}) : super(key: key);
  
  @override
  State<MatchingIcons> createState() => _MatchingIconsState();
}

class _MatchingIconsState extends State<MatchingIcons> {
  List<IconData> listOfIcons = [
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied, 
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_neutral,
    Icons.mood_bad
  ];

  late IconData correctIcon;
  late List<SpecialIconButton> listofSpecialIconButtons;
  late int numOfButtons;
  late int minCorrectIcons;
  late int crossAxisCount;
  late String diff;

  @override
  void initState() {
    super.initState();

    if (widget.difficulty == 1) {
      numOfButtons = 9;
      minCorrectIcons = 2;
      diff = 'Easy';
    } else if (widget.difficulty == 2) {
      numOfButtons = 15;
      minCorrectIcons = 3;
      diff = 'Medium';
    } else if (widget.difficulty == 3) {
      numOfButtons = 20;
      minCorrectIcons = 5;
      diff = 'Hard';
    }

    crossAxisCount = numOfButtons == 20 ? 4 : 3;
    correctIcon = getRandomIcon();
    listofSpecialIconButtons = createListOfSpecialIconButtons(numOfButtons);
    PuzzleHelper.startStopwatch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Click all the ',
              style: context.watch<Styles>().largeTextDefault,
            ),
            Icon(
              correctIcon,
              size: 48.0,
              color: context.watch<Styles>().selectedAccentColor,
            ),
            Text(
              ' icons',
              style: context.watch<Styles>().largeTextDefault,
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: GridView.count(
                children: listofSpecialIconButtons,
                primary: true,
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: numOfButtons == 15 ? 2 : 1.5,
              ),
            ),
          ),
        ),
      ]
    );
  }

  IconData getRandomIcon() {
    final _random = Random();

    return listOfIcons[_random.nextInt(listOfIcons.length)];
  }

  List<SpecialIconButton> createListOfSpecialIconButtons(int listLength) {
    List<SpecialIconButton> listOfSpecialIconButtons = [];
    int numOfCorrectIcons = minCorrectIcons + Random().nextInt((listLength ~/ 2) - minCorrectIcons);

    // add the correct icons
    for (int i = 0; i < numOfCorrectIcons; i++) {
      listOfSpecialIconButtons.add(SpecialIconButton(
        correctIcon: correctIcon, 
        isCorrectIcon: true, 
        listOfIcons: listOfIcons, 
        checkAllIconsFunc: checkAllIcons,
        completePuzzle: widget.completePuzzle,
        test: widget.test,
        diff: diff,
      ));
    }

    // add random icons to the remaining space in the list
    for (int i = 0; i < listLength - numOfCorrectIcons; i++) {
      listOfSpecialIconButtons.add(SpecialIconButton(
        correctIcon: correctIcon, 
        isCorrectIcon: false, 
        listOfIcons: listOfIcons, 
        checkAllIconsFunc: checkAllIcons,
        completePuzzle: widget.completePuzzle,
        test: widget.test,
        diff: diff,
      ));
    }

    listOfSpecialIconButtons.shuffle();
    return listOfSpecialIconButtons;
  }

  bool checkAllIcons() {
    for (SpecialIconButton button in listofSpecialIconButtons) {
      if ((button.isCorrectIcon && !button.pressed) || (!button.isCorrectIcon && button.pressed)) {
        return false;
      }
    }

    return true;
  }
}

class SpecialIconButton extends StatefulWidget {
  final IconData correctIcon;
  final bool isCorrectIcon;
  final List<IconData> listOfIcons;
  final Function checkAllIconsFunc;
  final Function completePuzzle;
  final bool test;
  final String diff;
  SpecialIconButton({Key? key, required this.correctIcon, required this.isCorrectIcon, required this.listOfIcons, required this.checkAllIconsFunc, required this.completePuzzle, required this.test, required this.diff}) : super(key: key);
  
  bool pressed = false;

  @override
  State<SpecialIconButton> createState() => _SpecialIconButtonState();
}

class _SpecialIconButtonState extends State<SpecialIconButton> {
  late IconData randomNotCorrectIcon = getRandomIcon(widget.correctIcon);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 100,
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            setState(() => widget.pressed = !widget.pressed);

            if (widget.checkAllIconsFunc()) {
              if (!widget.test) {
                int elapsedTime = PuzzleHelper.stopStopwatch();
                PuzzleHelper.addScoreToLeaderboard('matchingIcons${widget.diff}', elapsedTime);
              }

              widget.completePuzzle(context, widget.test);
            }
          }, 
          child: widget.isCorrectIcon 
            ? Icon(
              widget.correctIcon, 
              size: 48.0, 
              color: context.watch<Styles>().selectedAccentColor
            ) 
            : Icon(
              randomNotCorrectIcon, 
              size: 48.0, 
              color: context.watch<Styles>().selectedAccentColor
          ),
          style: ElevatedButton.styleFrom(
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
        ),
      ),
    );
  }

  IconData getRandomIcon(IconData correctIcon) {
    widget.listOfIcons.remove(correctIcon);
    final _random = Random();

    return widget.listOfIcons[_random.nextInt(widget.listOfIcons.length)];
  }
}