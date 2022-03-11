import 'package:flutter/material.dart';
import 'package:toki/styles.dart';
import '../widget/page_title.dart';
import 'package:toki/widget/emergency_exit_button.dart';

class MatchingIcons extends StatefulWidget {
  const MatchingIcons({Key? key}) : super(key: key);
  
  @override
  State<MatchingIcons> createState() => _MatchingIconsState();
}

class _MatchingIconsState extends State<MatchingIcons> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle('Matching Icons'),
          EmergencyExitButton(),
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