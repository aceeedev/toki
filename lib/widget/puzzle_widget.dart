import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/puzzle.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/puzzles/puzzle_helper.dart';
import 'package:toki/widget/card_widget.dart';

class PuzzleWidget extends StatefulWidget {
  final Puzzle puzzle;
  final Function refreshFunc;
  const PuzzleWidget({Key? key, required this.puzzle, required this.refreshFunc}) : super(key: key);

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<PuzzleWidget> {
  late bool isSwitched;
  late String dropDownValue;
  double columnPadding = 1.0;

  @override
  void initState() {
    isSwitched = widget.puzzle.enabled;

    int difficulty = widget.puzzle.difficulty;
    if (difficulty == 1) {
      dropDownValue = 'Easy';
    } else if (difficulty == 2) {
      dropDownValue = 'Medium';
    } else if (difficulty == 3) {
      dropDownValue = 'Hard';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.puzzle.name.contains(' ') ? widget.puzzle.name.split(' ').join('\n') : widget.puzzle.name,
                style: context.watch<Styles>().alarmTitle,
              ),
              Theme(
                data: ThemeData(
                  canvasColor: context.watch<Styles>().secondBackgroundColor
                ),
                child: DropdownButton(
                  value: dropDownValue,
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        'Easy',
                        style: context.watch<Styles>().textDefault,
                      ),
                      value: 'Easy',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Medium',
                        style: context.watch<Styles>().textDefault,
                      ),
                      value: 'Medium',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Hard',
                        style: context.watch<Styles>().textDefault,
                      ),
                      value: 'Hard',
                    ),
                  ],
                  onChanged: (pressedValue) {
                    setState(() {
                      dropDownValue = pressedValue.toString();
                    });
              
                    int newDifficulty = 0;
                    if (pressedValue == 'Easy') {
                      newDifficulty = 1;
                    } else if (pressedValue == 'Medium') {
                      newDifficulty = 2;
                    } else if (pressedValue == 'Hard') {
                      newDifficulty = 3;
                    } else {
                      Exception('pressedValue $pressedValue is not Easy, Medium, or Hard');
                    }
                              
              
                    Puzzle updatedPuzzle = Puzzle(
                      id: widget.puzzle.id,
                      name: widget.puzzle.name,
                      difficulty: newDifficulty,
                      enabled: widget.puzzle.enabled,
                    );
                    TokiDatabase.instance.updatePuzzle(updatedPuzzle);
              
                    widget.refreshFunc;
                  },
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              onPressed: () {
                PuzzleHelper.openTestPuzzle(context, widget.puzzle.name, true);
              }, 
              icon: Icon(
                Icons.play_circle_fill,
                size: 48.0,
                color: context.watch<Styles>().selectedAccentColor,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(left: 20.0),
            child: Transform.scale(
              scale: 1.3,
              child: Switch(
                value: isSwitched,
                onChanged: (value) async {
                  List<Puzzle> puzzles = await TokiDatabase.instance.readAllPuzzles();

                  List<Puzzle> enabledPuzzles = [];
                  for (Puzzle puzzle in puzzles) {
                    if (puzzle.enabled) {
                      enabledPuzzles.add(puzzle);
                    }
                  }

                  // make sure at least 1 puzzle is enabled
                  if (enabledPuzzles.length == 1 && !value) {
                    showCupertinoDialog(
                      context: context, 
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('All puzzles are disabled'),
                        content: const Text('There has to be at least one puzzle enabled or else there won\'t be a fun puzzle to complete when the alarm goes off.'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: const Text('Ok'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]
                      ),
                    );
                  } else {
                    setState(() {
                      isSwitched = value;

                      Puzzle updatedPuzzle = Puzzle(
                        id: widget.puzzle.id,
                        name: widget.puzzle.name,
                        difficulty: widget.puzzle.difficulty,
                        enabled: value,
                      );

                      TokiDatabase.instance.updatePuzzle(updatedPuzzle);

                      widget.refreshFunc;
                    });
                  }
                },
                activeTrackColor: context.watch<Styles>().selectedAccentColor,
                activeColor: context.watch<Styles>().selectedAccentColor[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
