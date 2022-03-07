import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../database_helpers.dart';
import '../styles.dart';
import '../model/alarm.dart';
import '../widget/page_title.dart';

class StatefulAlarmPage extends StatefulWidget {
  const StatefulAlarmPage({Key? key}) : super(key: key);

  @override
  State<StatefulAlarmPage> createState() => _StatefulAlarmPageState();
}

class _StatefulAlarmPageState extends State<StatefulAlarmPage> {
  DateTime time = DateTime.now();
  late TextEditingController _controller;

  List<Text> ringtones = const [
    Text('ringtone 1'),
    Text('ringtone 2'),
    Text('ringtone 3'),
  ];
  List<DayButton> dayButtons = [
    DayButton('Su'),
    DayButton('Mo'),
    DayButton('Tu'),
    DayButton('We'),
    DayButton('Th'),
    DayButton('Fr'),                  
    DayButton('Sa'),
  ];

  String alarmName = "";
  String alarmRingtone = "";


  @override
  void initState() {
    alarmRingtone = ringtones[0].data.toString();

    _controller = TextEditingController();
    _controller.addListener(() { 
      alarmName = _controller.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                'Time: ${DateFormat('hh:mm a').format(time)}',
                style: Styles.selectTimeText
              ),
            ),
          ),
          _StyledCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: dayButtons,
            ),
          ),
          _StyledCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  controller: _controller,
                  placeholder: 'Optional: Alarm Name',
                ),
              ),
            ),
          ),
          _StyledCard(
            child: CupertinoButton(
              onPressed: () => _showDialog(
                CupertinoPicker(
                  children: ringtones,
                  itemExtent: 30.0,
                  onSelectedItemChanged: (value) {
                    setState(() => alarmRingtone = ringtones[value].data.toString());
                  },
                ),
              ),
              child: Text(
                'Ringtone: $alarmRingtone',
                style: Styles.selectTimeText
              ),
            ),
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
                        _addAlarm();
                        Navigator.pop(context);
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

  void _addAlarm() async {
    var selectedDays = {};
    for (var element in dayButtons) {
      selectedDays[element.day] = element.selected;
    }

    final alarm = Alarm(
      time: time,
      selectedSu: selectedDays['Su'],
      selectedMo: selectedDays['Mo'],
      selectedTu: selectedDays['Tu'],
      selectedWe: selectedDays['We'],
      selectedTh: selectedDays['Th'],
      selectedFr: selectedDays['Fr'],
      selectedSa: selectedDays['Sa'],
      alarmName: alarmName,
      alarmRingtone: alarmRingtone,
      alarmOn: true,
    );

    await TokiDatabase.instance.create(alarm);
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
  // default to being selected
  bool selected = true;

  DayButton(this.day, {Key? key}) : super(key: key);

  @override
  State<DayButton> createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            widget.selected = !widget.selected;
          });
        },
        child: Text(widget.day),
        style: widget.selected ? Styles.dayButtonStyleSelected : Styles.dayButtonStyleNotSelected,
      ),
    );
  }
}