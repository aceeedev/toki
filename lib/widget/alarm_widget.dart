import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toki/backend/notification_api.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/widget/card_widget.dart';
import 'package:toki/page/create_alarm_page.dart';

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
    return CardWidget(
      backgroundColor: isSwitched ? context.watch<Styles>().secondBackgroundColor : context.watch<Styles>().disabledColor,
      elevation: isSwitched ? 2.0 : 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.alarm.alarmName != ""
              ? [
                Padding(
                  padding: EdgeInsets.all(columnPadding),
                  child: Text(
                      widget.alarm.alarmName.length >= 9 ? '${widget.alarm.alarmName.substring(0, 9)}...' : widget.alarm.alarmName,
                      style: context.watch<Styles>().alarmTitle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(columnPadding),
                  child: Text(
                    DateFormat('h:mm a').format(widget.alarm.time),
                    style: context.watch<Styles>().largeTextDefault
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(columnPadding),
                  child: RichText(
                    text: TextSpan(
                      style: context.watch<Styles>().textDefault,
                      children: formatSelectedDays(widget.alarm),
                    ),
                  ),
                ),
              ]
            : [
              Padding(
                padding: EdgeInsets.all(columnPadding),
                child: Text(
                  DateFormat('h:mm a').format(widget.alarm.time),
                  style: context.watch<Styles>().alarmTitle
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(columnPadding),
                  child: RichText(
                    text: TextSpan(
                      style: context.watch<Styles>().textDefault,
                      children: formatSelectedDays(widget.alarm),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Transform.scale(
              scale: 1.3,
              child: Switch(
                value: isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    isSwitched = value;
                    if (value) {
                      Alarm updatedAlarm = NotificationApi.updateCurrentAlarm(widget.alarm, widget.alarm.currentAlarm, true);
                      TokiDatabase.instance.updateAlarm(updatedAlarm);

                      NotificationApi.scheduleNotification();
                    } else {
                      NotificationApi.cancelAlarm(widget.alarm);
                    }

                    widget.refreshFunc();
                  });
                },
                activeTrackColor: context.watch<Styles>().selectedAccentColor,
                activeColor: context.watch<Styles>().selectedAccentColor[700],
                inactiveTrackColor: context.watch<Styles>().inactiveTrackColor,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: ThreeDotsButton(alarm: widget.alarm, refreshFunc: widget.refreshFunc),
          ), 
        ],
      ),
    );
  }

  List<TextSpan> formatSelectedDays(Alarm alarm) {
    return <TextSpan>[
      alarm.selectedSu ? TextSpan(text: 'Su ', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'Su '),
      alarm.selectedMo ? TextSpan(text: 'Mo ', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'Mo '),
      alarm.selectedTu ? TextSpan(text: 'Tu ', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'Tu '),
      alarm.selectedWe ? TextSpan(text: 'We ', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'We '),
      alarm.selectedTh ? TextSpan(text: 'Th ', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'Th '),
      alarm.selectedFr ? TextSpan(text: 'Fr ', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'Fr '),
      alarm.selectedSa ? TextSpan(text: 'Sa', style: context.watch<Styles>().alarmDateSelected) : const TextSpan(text: 'Sa'),
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
      color: context.watch<Styles>().secondBackgroundColor,
      icon: Icon(
        Icons.more_vert,
        color: context.watch<Styles>().selectedAccentColor,
      ),
      iconSize: 30.0,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: context.read<Styles>().textColorDefault,
              ),
              Text(
                ' Edit',
                style: context.read<Styles>().textDefault,
              ),
            ],
          ),
          value: 'Edit',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: context.read<Styles>().colorLogoRed,
              ),
              Text(
                ' Delete',
                style: context.read<Styles>().textDefaultRed
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAlarmPage(edit: true, alarm: widget.alarm, refreshFunc: widget.refreshFunc)));
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
                isDestructiveAction: true,
                child: const Text('Yes'),
                onPressed: () async {
                  // delete from db
                  TokiDatabase.instance.deleteAlarm(widget.alarm.id!);
                  // delete and schedule next alarm if exists
                  NotificationApi.resetAlarm();
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