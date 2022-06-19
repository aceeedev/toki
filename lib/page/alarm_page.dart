import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toki/page/settings_page.dart';
import 'package:toki/providers/main_provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/alarm_widget.dart';
import 'package:toki/page/create_alarm_page.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/backend/database_helpers.dart';

class AlarmPage extends StatefulWidget {
  final Function rateAppPopUp;
  const AlarmPage({Key? key, required this.rateAppPopUp}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late List<Alarm> alarms = [];
  bool isLoading = false;

  late Timer secondTimer;

  @override
  void initState() {
    super.initState();

    refreshAlarms();

    // refreshes the Next Alarm in ___ message every second
    secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) => context.read<MainProvider>().setNextAlarmString());
  }

  @override
  void dispose() {
    //TokiDatabase.instance.close();
    secondTimer.cancel();

    super.dispose();
  }

  Future refreshAlarms() async {
    setState(() => isLoading = true);

    List<Alarm> preAlarms = await TokiDatabase.instance.readAllAlarms('Time ASC');
    if (mounted) {
      setState(() {
        alarms = preAlarms;
      });
    }
    
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.read<Styles>().selectedAccentColor,
    body: SafeArea(
      child: Container(
        color: context.read<Styles>().backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const PageTitle(
                  title: 'Alarm',
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (context) => SettingsPage(rateAppPopUp: widget.rateAppPopUp)
                          ));
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.settings,
                          size: 48.0,
                          color: context.watch<Styles>().selectedAccentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: isLoading
                ? const Center(
                    child: CircularProgressIndicator()
                  )
                : alarms.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No Alarms',
                            style: context.watch<Styles>().largeTextDefault,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Toki works best when your phone is off and your ringer is on.',
                            style: context.watch<Styles>().mediumTextDefault,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                  )
                  : buildAlarms(),
            ),
          ]
        ),
      ),
    ),
    floatingActionButton: Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height >= 800 ? 40.0 : 0.0),
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: context.watch<Styles>().selectedAccentColor,
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAlarmPage(edit: false, alarm: null, refreshFunc: refreshAlarms)));
          });
        },
        heroTag: 'createAlarm',
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );

  Widget buildAlarms() => ListView.builder(
    itemCount: alarms.length + 2,
    itemBuilder: (context, index) {
      final DateTime now = DateTime.now();

      if (index == 0) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Text(
            'Today is ${DateFormat('EEEE, MMMM d').format(now)}',
            style: context.watch<Styles>().textToday,
            textAlign: TextAlign.center,
            ),
        );
      } else if (index == 1) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
          child: Text(
            context.watch<MainProvider>().nextAlarmString,
            style: context.watch<Styles>().textNextAlarm,
            textAlign: TextAlign.center,
            ),
        );
      }

      final alarm = alarms[index - 2];

      return AlarmWidget(alarm: alarm, refreshFunc: refreshAlarms);
    },
  );
}
