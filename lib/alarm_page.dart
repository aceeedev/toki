import 'package:flutter/material.dart';
import 'page_title.dart';
import 'alarm.dart';
import 'styles.dart';

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
              itemCount: 5,
              itemBuilder: _listViewItemBuilder,
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Styles.selectedAccentColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAlarmPage()));
        },
        heroTag: 'createAlarm',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    return Alarm();
  }

}

class CreateAlarmPage extends StatelessWidget {
  const CreateAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
    tag: 'createAlarm', 
    child: Scaffold(
      body: Column(
        children: [
          const Text('Hello'),
          const Text('Bye'),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.01, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'))  
                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}