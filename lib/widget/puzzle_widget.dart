import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toki/api/notification_api.dart';
import 'package:toki/model/puzzle.dart';
import 'package:toki/styles.dart';
import 'package:toki/database_helpers.dart';
import 'package:toki/model/alarm.dart';

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
    dropDownValue = widget.puzzle.difficulty.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align( // you have to wrap in an align because it they are in another container, needed to change size
      child: SizedBox( 
        height: 150,
        width: 300,
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.puzzle.name.contains(' ') ? widget.puzzle.name.split(' ').join('\n') : widget.puzzle.name,
                    style: Styles.alarmTitle,
                  ),
                  DropdownButton(
                    value: dropDownValue,
                    items: const [
                      DropdownMenuItem(
                        child: Text('Easy'),
                        value: '1',
                      ),
                      DropdownMenuItem(
                        child: Text('Medium'),
                        value: '2',
                      ),
                      DropdownMenuItem(
                        child: Text('Hard'),
                        value: '3',
                      ),
                    ],
                    onChanged: (value) {
                      Puzzle updatedPuzzle = Puzzle(
                        id: widget.puzzle.id,
                        name: widget.puzzle.name,
                        difficulty: int.parse(value.toString()),
                        enabled: widget.puzzle.enabled,
                      );
                      TokiDatabase.instance.updatePuzzle(updatedPuzzle);

                      widget.refreshFunc();
                    },
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                  onPressed: () {

                  }, 
                  icon: Icon(
                    Icons.play_arrow,
                    size: 48.0,
                    color: Styles.selectedAccentColor,
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
                    onChanged: (value) {
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
                    },
                    activeTrackColor: Styles.selectedAccentColor,
                    activeColor: Styles.selectedAccentColor[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
