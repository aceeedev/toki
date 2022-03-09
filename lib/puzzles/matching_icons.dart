import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toki/styles.dart';
import '../widget/page_title.dart';

class MatchingIcons extends StatefulWidget {
  const MatchingIcons({Key? key}) : super(key: key);
  
  @override
  State<MatchingIcons> createState() => _MatchingIconsState();
}

class _MatchingIconsState extends State<MatchingIcons> {
  bool clickedOff = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle('Matching Icons'),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                child: Icon(
                  Icons.warning,
                  size: 48.0,
                  color: Styles.colorLogoRed[900],
                ),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8.0),
                  primary: Styles.colorLogoRed,
                ),
                onPressed: () async {
                  clickedOff = false;

                  await Future.delayed(const Duration(seconds: 3));

                  if (!clickedOff) {
                    print('exited puzzle');
                  }
                },
                onFocusChange: (value) {
                  clickedOff = true;
                },
              ),
            ),
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