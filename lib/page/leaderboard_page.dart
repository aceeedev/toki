import 'package:flutter/material.dart';
import 'package:toki/styles.dart';
import '../widget/page_title.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle(
            title: 'Leaderboard',
            padding: true,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Coming Soon',
                style: Styles.largeTextDefault,
              ),
            ),
          ),
        ]
      ),
    );
  }
}