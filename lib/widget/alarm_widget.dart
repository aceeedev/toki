import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toki/api/notification_api.dart';
import '../styles.dart';
import '../database_helpers.dart';
import '../model/alarm.dart';

class AlarmWidget extends StatefulWidget {
  final Alarm alarm;
  final Function refreshFunc;
  const AlarmWidget({Key? key, required this.alarm, required this.refreshFunc}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<AlarmWidget> {
  late bool isSwitched;
  double columnPadding = 1.0;

  @override
  void initState() {
    isSwitched = widget.alarm.alarmOn;
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
                  Padding(
                    padding: EdgeInsets.all(columnPadding),
                    child: Text(
                      DateFormat('h:mm a').format(widget.alarm.time),
                      style: Styles.alarmTitle
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(columnPadding),
                    child: RichText(
                      text: TextSpan(
                        style: Styles.textDefault,
                        children: formatSelectedDays(widget.alarm),
                      ),
                    ),
                  ),
                  widget.alarm.alarmName != ""
                  ? Padding(
                      padding: EdgeInsets.all(columnPadding),
                      child: Text(
                        widget.alarm.alarmName,
                        style: Styles.textDefault
                      ),
                    )
                  : const SizedBox.shrink()
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Transform.scale(
                  scale: 1.3,
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        print('here');
                        isSwitched = value;

                        Map<String, dynamic> alarmJson = widget.alarm.toJson();
                        alarmJson['alarmOn'] = value ? 0 : 1;
                        Alarm updatedAlarm = Alarm.fromJson(alarmJson);
                        
                        TokiDatabase.instance.update(updatedAlarm);

                        // enable/disable alarm
                        final int firstNotId = widget.alarm.firstNotId;
                        final int lastNotId = widget.alarm.lastNotId;
                        if (isSwitched) {
                          final DateTime time = widget.alarm.time;
                          final selectedDays = {
                            'Su': widget.alarm.selectedSu,
                            'Mo': widget.alarm.selectedMo,
                            'Tu': widget.alarm.selectedTu,
                            'We': widget.alarm.selectedWe,
                            'Th': widget.alarm.selectedTh,
                            'Fr': widget.alarm.selectedFr,
                            'Sa': widget.alarm.selectedSa
                          };

                          NotificationApi.showSheduledNotification(
                            title: '${widget.alarm.alarmName == "" ? "" : widget.alarm.alarmName + ' - '}${DateFormat('hh:mm a').format(time)} Alarm',
                            body: 'Click this notification to turn off the alarm!',
                            payload: 'schedule',
                            scheduledDateTime: time,
                            selectedDays: selectedDays,
                            firstNotId: firstNotId,
                            lastNotId: lastNotId,
                          );
                        } else {
                          // delete (all) scheduled notifications
                          for (int id = firstNotId; id <= lastNotId; id++) {
                            NotificationApi.cancel(id);
                          }
                        }

                        widget.refreshFunc;
                      });
                    },
                    activeTrackColor: Styles.selectedAccentColor,
                    activeColor: Styles.selectedAccentColor[700],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: ThreeDotsButton(alarm: widget.alarm, refreshFunc: widget.refreshFunc),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> formatSelectedDays(Alarm alarm) {
    return <TextSpan>[
      alarm.selectedSu ? const TextSpan(text: 'Su ') : TextSpan(text: 'Su ', style: Styles.alarmDateUnselected),
      alarm.selectedMo ? const TextSpan(text: 'Mo ') : TextSpan(text: 'Mo ', style: Styles.alarmDateUnselected),
      alarm.selectedTu ? const TextSpan(text: 'Tu ') : TextSpan(text: 'Tu ', style: Styles.alarmDateUnselected),
      alarm.selectedWe ? const TextSpan(text: 'We ') : TextSpan(text: 'We ', style: Styles.alarmDateUnselected),
      alarm.selectedTh ? const TextSpan(text: 'Th ') : TextSpan(text: 'Th ', style: Styles.alarmDateUnselected),
      alarm.selectedFr ? const TextSpan(text: 'Fr ') : TextSpan(text: 'Fr ', style: Styles.alarmDateUnselected),
      alarm.selectedSa ? const TextSpan(text: 'Sa') : TextSpan(text: 'Sa', style: Styles.alarmDateUnselected),
    ];
  }
}

class ThreeDotsButton extends StatefulWidget {
  final Alarm alarm;
  final Function refreshFunc;
  const ThreeDotsButton ({Key? key, required this.alarm, required this.refreshFunc}) : super(key: key);

  @override
  State<ThreeDotsButton> createState() => _ThreeDotsButtonState();
}

class _ThreeDotsButtonState extends State<ThreeDotsButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      iconSize: 30.0,
      itemBuilder: (BuildContext context) => [
        /*PopupMenuItem(
          child: Row(
            children: [
              const Icon(Icons.edit),
              Text(
                ' Edit',
                style: Styles.textDefault,
              ),
            ],
          ),
          value: 'Edit',
        ),*/
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Styles.colorLogoRed,
                ),
              Text(
                ' Delete',
                style: Styles.textDefaultRed
              ),
            ],
          ),
          value: 'Delete',
        ),
      ],
      onSelected: handleClick,
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        // TODO edit alarm ability
        break;
      case 'Delete':
        showCupertinoDialog(
          context: context, 
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Delete ${widget.alarm.alarmName == "" ? DateFormat('h:mm a').format(widget.alarm.time) : widget.alarm.alarmName + ' (' + DateFormat('h:mm a').format(widget.alarm.time) + ')'} Alarm'),
            content: const Text('Are you sure you want to delete this alarm?'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                child: Text(
                  'Yes',
                  style: Styles.textDefaultRed
                ),
                onPressed: () {
                  // get alarm
                  Map alarmJson = widget.alarm.toJson();

                  // delete (all) scheduled notifications
                  for (int id = alarmJson['firstNotId']; id <= alarmJson['lastNotId']; id++) {
                    NotificationApi.cancel(id);
                  }

                  // delete from db
                  TokiDatabase.instance.delete(alarmJson['_id']);
                  // refresh alarm page
                  widget.refreshFunc();

                  // exit dialog
                  Navigator.pop(context);
                },
              ),
            ]
          ),
        );
    }
  }
}