import 'package:flutter/material.dart';
import '../styles.dart';
import '../widget/page_title.dart';
import '../widget/alarm_widget.dart';
import 'create_alarm_page.dart';
import '../model/alarm.dart';
import 'package:toki/database_helpers.dart';

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

    List<Alarm> preAlarms = await TokiDatabase.instance.readAllAlarms();

    setState(() {
      alarms = preAlarms;
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const PageTitle('Alarm'),
        Expanded(
          child: isLoading
            ? const Center(
              child: CircularProgressIndicator()
              )
            : alarms.isEmpty
              ? const Center(
                  child: Text(
                    'No Alarms',
                    style: TextStyle(fontSize: 24),
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
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const StatefulAlarmPage()));
        
        refreshAlarms();
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
