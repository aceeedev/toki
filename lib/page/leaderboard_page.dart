import 'package:flutter/material.dart';
import '../widget/page_title.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          PageTitle('Leaderboard'),
        ]
      ),
    );
  }
}