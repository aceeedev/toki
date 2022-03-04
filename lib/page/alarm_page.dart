import 'package:flutter/material.dart';
import '../styles.dart';
import '../widget/page_title.dart';
import '../widget/alarm_widget.dart';
import 'create_alarm_page.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const PageTitle('Alarm'),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: _listViewItemBuilder,
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Styles.selectedAccentColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StatelessAlarmPage()));
        },
        heroTag: 'createAlarm',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    return const AlarmWidget();
  }
}
