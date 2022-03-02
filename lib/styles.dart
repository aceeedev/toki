import 'dart:ffi';

import 'package:flutter/material.dart';

class Styles {
  static const _textSizeLarge = 25.0;
  static const _textSizeDefault = 16.0;
  static const _textSizePageTitle = 50.0;
  static const _textSizeAlarmTitle = 20.0;

  static final Color _textColorStrong = _createMaterialColor(const Color(0xff000000));
  static final Color _textColorDefault = _createMaterialColor(const Color(0xff666666));
  static final MaterialColor colorLogoGreen = _createMaterialColor(const Color(0xffC6D57E));
  static final MaterialColor colorLogoRed = _createMaterialColor(const Color(0xffD57E7E));
  static final MaterialColor colorLogoBlue = _createMaterialColor(const Color(0xffA2CDCD));
  static final MaterialColor colorLogoTan = _createMaterialColor(const Color(0xffFFE1AF));

  static const String _fontNameDefault = 'M+ 1C';

  static const alarmFormCardHeight = 100.0;
  static const alarmFormCardWidth = 300.0;

  static final MaterialColor selectedAccentColor = colorLogoBlue;


  static const pageTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizePageTitle,
    fontWeight: FontWeight.w700,
  );

  static const alarmTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeAlarmTitle,
    fontWeight: FontWeight.w700,
  );

  static TextStyle alarmDateUnselected = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: Colors.grey[400],
  );

  static final selectTimeText = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: selectedAccentColor,
  );

  static final textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static final alarmFormButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size(110.0, 30.0), 
    primary: selectedAccentColor,
  );

  static final dayButtonStyle = TextButton.styleFrom(
    fixedSize: const Size(10,10),
    textStyle: TextStyle(
      color: selectedAccentColor,
    ),
  );


  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) { 
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - r)) * ds).round(),
        b + ((ds < 0 ? b : (255 - r)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}