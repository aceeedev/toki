import 'package:flutter/material.dart';
import 'dart:math';
import 'package:toki/api/notification_api.dart';
import 'package:toki/styles.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/emergency_exit_button.dart';

class MatchingIcons extends StatefulWidget {
  final Alarm alarm;

  const MatchingIcons({Key? key, required this.alarm}) : super(key: key);
  
  @override
  State<MatchingIcons> createState() => _MatchingIconsState();
}

class _MatchingIconsState extends State<MatchingIcons> {
  List<IconData> listOfIcons = [
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied, 
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_neutral,
    Icons.mood_bad
  ];

  late IconData correctIcon = getRandomIcon();
  late List<SpecialIconButton> listofSpecialIconButtons = createListOfSpecialIconButtons(9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageTitle('Matching Icons'),
          EmergencyExitButton(alarm: widget.alarm),
          Row(
            children: [
              Text(
                'Click all the ',
                style: Styles.largeTextDefault,
              ),
              Icon(
                correctIcon,
                size: 48.0,
                color: Styles.selectedAccentColor,
              ),
              Text(
                ' icons',
                style: Styles.largeTextDefault,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: GridView.count(
                  children: listofSpecialIconButtons,
                  primary: true, 
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  IconData getRandomIcon() {
    final _random = Random();

    return listOfIcons[_random.nextInt(listOfIcons.length)];
  }

  List<SpecialIconButton> createListOfSpecialIconButtons(int listLength) {
    List<SpecialIconButton> listOfSpecialIconButtons = [];
    int numOfCorrectIcons = 2 + Random().nextInt(listLength-2);

    // add the correct icons
    for (int i = 0; i < numOfCorrectIcons; i++) {
      listOfSpecialIconButtons.add(SpecialIconButton(alarm: widget.alarm, correctIcon: correctIcon, isCorrectIcon: true, listOfIcons: listOfIcons, checkAllIconsFunc: checkAllIcons));
    }

    // add random icons to the remaining space in the list
    for (int i = 0; i < listLength - numOfCorrectIcons; i++) {
      listOfSpecialIconButtons.add(SpecialIconButton(alarm: widget.alarm, correctIcon: correctIcon, isCorrectIcon: false, listOfIcons: listOfIcons, checkAllIconsFunc: checkAllIcons));
    }

    listOfSpecialIconButtons.shuffle();
    return listOfSpecialIconButtons;
  }

  bool checkAllIcons() {
    for (SpecialIconButton button in listofSpecialIconButtons) {
      if ((button.isCorrectIcon && !button.pressed) || (!button.isCorrectIcon && button.pressed)) {
        return false;
      }
    }

    return true;
  }
}

class SpecialIconButton extends StatefulWidget {
  final Alarm alarm;
  final IconData correctIcon;
  final bool isCorrectIcon;
  final List<IconData> listOfIcons;
  final Function checkAllIconsFunc;
  SpecialIconButton({Key? key, required this.alarm, required this.correctIcon, required this.isCorrectIcon, required this.listOfIcons, required this.checkAllIconsFunc}) : super(key: key);
  
  bool pressed = false;

  @override
  State<SpecialIconButton> createState() => _SpecialIconButtonState();
}

class _SpecialIconButtonState extends State<SpecialIconButton> {
  late IconData randomNotCorrectIcon = getRandomIcon(widget.correctIcon);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() => widget.pressed = !widget.pressed);

        if (widget.checkAllIconsFunc()) {
          NotificationApi.resetAlarm();
          Navigator.pop(context);
        }
      }, 
      child: widget.isCorrectIcon ? Icon(widget.correctIcon, size: 48.0, color: Styles.selectedAccentColor) : Icon(randomNotCorrectIcon, size: 48.0, color: Styles.selectedAccentColor),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Styles.backgroundColor,
        side: BorderSide(
          width: 10.0,
          color: widget.pressed ? Styles.selectedAccentColor : Styles.backgroundColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );
  }

  IconData getRandomIcon(IconData correctIcon) {
    widget.listOfIcons.remove(correctIcon);
    final _random = Random();

    return widget.listOfIcons[_random.nextInt(widget.listOfIcons.length)];
  }
}