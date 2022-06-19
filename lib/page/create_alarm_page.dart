import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/backend/notification_api.dart';
import 'package:toki/providers/create_form.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/widget/page_title.dart';

class CreateAlarmPage extends StatefulWidget {
  final bool edit;
  final Alarm? alarm;
  final Function refreshFunc;
  const CreateAlarmPage({Key? key, required this.edit, required this.alarm, required this.refreshFunc}) : super(key: key);

  @override
  State<CreateAlarmPage> createState() => _CreateAlarmPageState();
}

class _CreateAlarmPageState extends State<CreateAlarmPage> {
  late TextEditingController _controller;

  late List<DayButton> dayButtons;

  late String alarmName;

  late List<RingToneListTile> ringtoneListTiles;
  late List<Widget> listOfListViewWidgets;

  String createAlarmName() {
    if (widget.edit) {
      return widget.alarm!.alarmName;
    }

    return "";
  }

  List<DayButton> createDayButtons() {
    return [
      DayButton(day: 'Su', selected: widget.edit ? widget.alarm!.selectedSu : false,),
      DayButton(day: 'Mo', selected: widget.edit ? widget.alarm!.selectedMo : false,),
      DayButton(day: 'Tu', selected: widget.edit ? widget.alarm!.selectedTu : false,),
      DayButton(day: 'We', selected: widget.edit ? widget.alarm!.selectedWe : false,),
      DayButton(day: 'Th', selected: widget.edit ? widget.alarm!.selectedTh : false,),
      DayButton(day: 'Fr', selected: widget.edit ? widget.alarm!.selectedFr : false,),
      DayButton(day: 'Sa', selected: widget.edit ? widget.alarm!.selectedSa : false,),
    ];
  }

  List<RingToneListTile> createRingtoneListTiles() {
    return const [
      RingToneListTile(
        title: 'Default Ringtone',
        sound: 'digital_alarm_sound.wav',
      ),
      RingToneListTile(
        title: 'Beeping Ringtone',
        sound: 'beeping_alarm.wav',
      ),
      RingToneListTile(
        title: 'Fast Beeping Ringtone',
        sound: 'fast_beeping.wav',
      ),
      RingToneListTile(
        title: 'Melody Ringtone',
        sound: 'alarm_melody.wav',
      ),
      RingToneListTile(
        title: 'Bell Ringtone',
        sound: 'bell_alarm.wav',
      ),
    ];
  }

  List<Widget> createListOfListViewWidgets() {
    return [
      _StyledCard(
        child: CupertinoButton(
          onPressed: () => _showDialog(
            CupertinoDatePicker(
              initialDateTime: widget.edit ? widget.alarm!.time : context.read<CreateForm>().time,
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              onDateTimeChanged: (DateTime newTime) =>
                  context.read<CreateForm>().setTime(newTime),
            ),
          ),
          child: Text(
              'Time: ${DateFormat('hh:mm a').format(context.watch<CreateForm>().time)}',
              style: context.watch<Styles>().selectTimeText),
        ),
      ),
      _StyledCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Days:',
                style: context.watch<Styles>().mediumTextDefault),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: dayButtons,
            ),
          ],
        ),
      ),
      _StyledCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoTextField(
              controller: widget.edit ? (_controller..text = widget.alarm!.alarmName) : _controller,
              placeholder: 'Optional: Alarm Name',
            ),
          ),
        ),
      ),
      _StyledCard(
        child: CupertinoButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return Card(
                    color: context.watch<Styles>().backgroundColor,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                            child: IconButton(
                                onPressed: () {
                                  context.read<CreateForm>().stopSound();
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 48.0,
                                  color: context
                                      .watch<Styles>()
                                      .selectedAccentColor,
                                )),
                          ),
                        ),
                        Text(
                          'Ringtones',
                          style: context.watch<Styles>().pageTitle,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: ringtoneListTiles.length,
                          itemBuilder: (context, index) {
                            return ringtoneListTiles[index];
                          },
                        )
                      ],
                    ));
              }),
          child: Text('Ringtone: ${context.read<CreateForm>().ringtoneName}',
              style: context.watch<Styles>().selectTimeText),
        ),
      ),
      Container(
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
              style: context.watch<Styles>().alarmFormButtonStyle,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _addAlarm();

                  Navigator.pop(context);
                },
                icon: Icon(widget.edit ? Icons.edit : Icons.check),
                label: Text(widget.edit ? 'Edit' : 'Create'),
                style: context.watch<Styles>().alarmFormButtonStyle,
              ),
            )
          ],
        ),
      ),
    ];
  }

  late Future<String> allowedNotificationsPerm;
  String skipNotifications = 'No';

  @override
  void initState() {
    if (widget.edit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<CreateForm>().setTime(widget.alarm!.time);

        Map<String?, String> ringtoneMap = {};
        for (RingToneListTile ringToneListTile in ringtoneListTiles) {
          ringtoneMap[ringToneListTile.sound] = ringToneListTile.title;
        }

        context.read<CreateForm>().setRingtoneName(ringtoneMap[widget.alarm!.alarmRingtone] ?? 'Error');
        context
            .read<CreateForm>()
            .setRingtoneSound(widget.alarm!.alarmRingtone);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<CreateForm>().resetTime();
        context.read<CreateForm>().setRingtoneName(ringtoneListTiles.first.title);
        context
            .read<CreateForm>()
            .setRingtoneSound(ringtoneListTiles.first.sound);
      });
    }
    

    dayButtons = createDayButtons();
    ringtoneListTiles = createRingtoneListTiles();

    _controller = TextEditingController();
    _controller.addListener(() {
      alarmName = _controller.text;
    });

    alarmName = createAlarmName();

    allowedNotificationsPerm = getAllowedNotificationsPerm();

    super.initState();
  }

  Future<String> getAllowedNotificationsPerm() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      if (status == PermissionStatus.granted) {
        return 'granted';
      } else {
        return 'not granted';
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        allowedNotificationsPerm = getAllowedNotificationsPerm();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listOfListViewWidgets = createListOfListViewWidgets();

    return Hero(
        tag: 'createAlarm',
        child: Scaffold(
          backgroundColor: context.read<Styles>().backgroundColor,
          body: SafeArea(
            child: skipNotifications == 'Yes' ? createAlarmPage() : FutureBuilder(
                future: allowedNotificationsPerm,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                        'error while retrieving status: ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data == 'granted') {
                      return createAlarmPage();
                    }

                    return Scaffold(
                      backgroundColor: context.read<Styles>().backgroundColor,
                      body: Center(
                        child: Column(children: [
                          const PageTitle(
                            title: 'Notifications Warning',
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Alarms on Toki Alarm will only work if push notifications are enabled',
                              style: context.watch<Styles>().largeTextDefault,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      skipNotifications = 'Yes';
                                    });
                                  },
                                  child: Text(
                                    'Make alarm anyways',
                                    style: context.watch<Styles>().textDefaultRed,
                                  ),
                                  style: TextButton.styleFrom(
                                      backgroundColor: context
                                          .watch<Styles>()
                                          .selectedAccentColor),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    NotificationPermissions
                                            .requestNotificationPermissions(
                                                iosSettings:
                                                    const NotificationSettingsIos(
                                                        sound: true,
                                                        badge: true,
                                                        alert: true))
                                        .then((value) =>
                                            allowedNotificationsPerm =
                                                getAllowedNotificationsPerm());
                                  },
                                  child: Text(
                                    'Go to notifications settings',
                                    style: context.watch<Styles>().textDefault,
                                  ),
                                  style: TextButton.styleFrom(
                                      backgroundColor: context
                                          .watch<Styles>()
                                          .selectedAccentColor)),
                            ],
                          ),
                        ]),
                      ),
                    );
                  }
                  return const Text('No permission status yet');
                }),
          ),
        ));
  }

  Widget createAlarmPage() {
    return Column(children: [
      PageTitle(
        title: '${widget.edit ? 'Edit' : 'Create'} Alarm',
      ),
      Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: listOfListViewWidgets[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 30);
            },
            itemCount: 5),
      )
    ]);
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

  Future _addAlarm() async {
    Map<String, bool> selectedDays = {};
    int numSelectedDays = 0;
    for (DayButton element in dayButtons) {
      selectedDays[element.day] = element.selected;
      if (element.selected) {
        numSelectedDays++;
      }
    }

    // make sure at least one day is selected
    if (numSelectedDays == 0) {
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('No weekdays are selected'),
            content: const Text(
                'There has to be at least one weekday selected or else what is the point in setting an alarm that never goes off.'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ]),
      );
    } else {
      Alarm alarm = Alarm(
        time: context.read<CreateForm>().time,
        selectedSu: selectedDays['Su']!,
        selectedMo: selectedDays['Mo']!,
        selectedTu: selectedDays['Tu']!,
        selectedWe: selectedDays['We']!,
        selectedTh: selectedDays['Th']!,
        selectedFr: selectedDays['Fr']!,
        selectedSa: selectedDays['Sa']!,
        alarmName: alarmName,
        alarmRingtone: context.read<CreateForm>().ringtoneSound,
        alarmOn: true,
        currentAlarm: false,
      );

      if (widget.edit) {
        Alarm alarmWithID = alarm.copy(
          id: widget.alarm!.id,
          alarmOn: widget.alarm!.alarmOn
        );

        await TokiDatabase.instance.updateAlarm(alarmWithID);
      } else {
        await TokiDatabase.instance.createAlarm(alarm);
      }
      NotificationApi.resetAlarm();
      
      widget.refreshFunc();
    }
  }
}

class _StyledCard extends StatelessWidget {
  const _StyledCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.watch<Styles>().alarmFormCardHeight,
      width: context.watch<Styles>().alarmFormCardWidth,
      child: Card(
        color: context.watch<Styles>().secondBackgroundColor,
        child: child,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}

class DayButton extends StatefulWidget {
  final String day;
  // default to being selected
  bool selected;

  DayButton({Key? key, required this.day, required this.selected}) : super(key: key);

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
        style: widget.selected
            ? context.watch<Styles>().dayButtonStyleSelected
            : context.watch<Styles>().dayButtonStyleNotSelected,
      ),
    );
  }
}

class RingToneListTile extends StatefulWidget {
  final String title;
  final String sound;

  const RingToneListTile({Key? key, required this.title, required this.sound})
      : super(key: key);

  @override
  State<RingToneListTile> createState() => _RingToneListTileState();
}

class _RingToneListTileState extends State<RingToneListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: TextButton(
          child: Text(
            widget.title,
            style: context.watch<Styles>().largeTextDefault,
          ),
          onPressed: () {
            context.read<CreateForm>().setRingtoneName(widget.title);
            context.read<CreateForm>().setRingtoneSound(widget.sound);
            Navigator.of(context).pop();
          },
        ),
        trailing: IconButton(
          iconSize: 48.0,
          icon: Icon(
            Icons.play_circle_fill,
            color: context.watch<Styles>().selectedAccentColor,
          ),
          onPressed: () async {
            context.read<CreateForm>().playSound(widget.sound);
          },
        ));
  }
}
