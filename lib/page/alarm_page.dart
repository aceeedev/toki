import 'package:flutter/material.dart';
import 'package:toki/page/settings_page.dart';
import 'package:toki/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/alarm_widget.dart';
import 'package:toki/page/create_alarm_page.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/backend/database_helpers.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();

  void refreshAlarms() {
    _AlarmPageState().refreshAlarms();
  }
}

class _AlarmPageState extends State<AlarmPage> {
  late List<Alarm> alarms = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshAlarms();
  }

  @override
  void dispose() {
    //TokiDatabase.instance.close();

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
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const PageTitle(
              title: 'Alarm',
              padding: true,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 85.0, 20.0, 0.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => const SettingsPage()
                      ));
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.settings,
                      size: 48.0,
                      color: Styles.selectedAccentColor,
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
              ? Center(
                  child: Text(
                    'No Alarms',
                    style: Styles.largeTextDefault,
                  ),
                )
              : buildAlarms(),
        ),
      ]
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Styles.selectedAccentColor,
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const StatefulAlarmPage()))
        .then((value) => refreshAlarms());
      },
      heroTag: 'createAlarm',
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );

  Widget buildAlarms() => ListView.builder(
    itemCount: alarms.length,
    itemBuilder: (context, index) {
      final alarm = alarms[index];

      return AlarmWidget(alarm: alarm, refreshFunc: refreshAlarms);
    },
  );
}
