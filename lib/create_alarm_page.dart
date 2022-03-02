import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'styles.dart';
import 'page_title.dart';

class StatelessAlarmPage extends StatefulWidget {
  const StatelessAlarmPage({Key? key}) : super(key: key);

  @override
  State<StatelessAlarmPage> createState() => _StatelessAlarmPageState();
}

class _StatelessAlarmPageState extends State<StatelessAlarmPage> {
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Hero(
    tag: 'createAlarm', 
    child: Scaffold(
      body: Column(
        children: [
          const PageTitle('Create Alarm'),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StyledCard(
            child: CupertinoButton(
              onPressed: () => _showDialog(
                CupertinoDatePicker(
                  initialDateTime: time,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() => time = newTime);
                  },
                ),
              ),
              child: Text(
                DateFormat('hh:mm a').format(time),
                style: Styles.selectTimeText
              ),
            ),
          ),
          _StyledCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                DayButton('S'),
                DayButton('M'),
                DayButton('T'),
                DayButton('W'),
                DayButton('T'),
                DayButton('F'),
                DayButton('S'),
              ],
            ),
          ),
          const _StyledCard(
            child: Text('Alarm Name')
          ),
          const _StyledCard(
            child: Text('Alarm Sound')
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: Styles.alarmFormButtonStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _addAlarm();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Create'),
                      style: Styles.alarmFormButtonStyle,
                    ),
                  )
                  ],
                ),
              ),
            ),
              ],
            )
          ),
          ],
        ),
      ),
    );
  }


  void _showDialog(Widget child) { 
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _addAlarm() {
    // TODO adding alarm
    print('added alarm');
  }
}


class _StyledCard extends StatelessWidget {
  const _StyledCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Styles.alarmFormCardHeight,
      width: Styles.alarmFormCardWidth,
      child: Card(
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
      ),
    ); 
  }
}

class DayButton extends StatefulWidget {
  final String day;

  const DayButton(this.day, {Key? key}) : super(key: key);

  @override
  State<DayButton> createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(widget.day),
      // TODO fix sizing of days in form
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(5,5)),
      ),
    );
  }
}