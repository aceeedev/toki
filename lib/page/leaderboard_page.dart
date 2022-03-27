import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/widget/page_title.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<Styles>().backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const PageTitle(
              title: 'Leaderboard',
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Coming Soon',
                  style: context.watch<Styles>().largeTextDefault,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}