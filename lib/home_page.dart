import 'package:flutter/material.dart';
import 'page_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    return const ListTile(
      contentPadding: EdgeInsets.all(10.0),
      title: Text('Hello'),
    );
  }

}