import 'package:flutter/material.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/setting.dart';

class Styles {
  static const _textSizeLarge = 25.0;
  static const _textSizeMedium = 18.0;
  static const _textSizeDefault = 16.0;
  static const _textSizePageTitle = 50.0;

  static final Color _textColorStrong = _createMaterialColor(const Color(0xff000000));
  static final Color _textColorBlack = _createMaterialColor(const Color(0xff666666));
  static final MaterialColor colorLogoGreen = _createMaterialColor(const Color(0xffC6D57E));
  static final MaterialColor colorLogoRed = _createMaterialColor(const Color(0xffD57E7E));
  static final MaterialColor colorLogoBlue = _createMaterialColor(const Color(0xffA2CDCD));
  static final MaterialColor colorLogoTan = _createMaterialColor(const Color(0xffFFE1AF));
  static final MaterialColor whiteColor = _createMaterialColor(const Color(0xffFFFFFF));
  static final MaterialColor darkColor = _createMaterialColor(const Color(0xff121212));

  static const String _fontNameDefault = 'M+ 1C';

  static const alarmFormCardHeight = 100.0;
  static const alarmFormCardWidth = 300.0;

  static MaterialColor selectedAccentColor = colorLogoBlue;
  static Color _textColorDefault = _textColorBlack;
  static MaterialColor backgroundColor = whiteColor;


  static const pageTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizePageTitle,
    fontWeight: FontWeight.w700,
  );

  static const alarmTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
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

  static final largeTextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: _textColorDefault,
  );

  static final mediumTextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeMedium,
    color: _textColorDefault,
  );

  static final alarmFormButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size(110.0, 30.0), 
    primary: selectedAccentColor,
  );

  static final dayButtonStyleSelected = TextButton.styleFrom(
    minimumSize: const Size(3.0, 3.0),
    primary: selectedAccentColor[500],
    textStyle: const TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: _textSizeMedium,
    ),
    side: BorderSide(
      width: 2.0,
      color: selectedAccentColor,
    ),
  );

  static final dayButtonStyleNotSelected = TextButton.styleFrom(
    minimumSize: const Size(3.0, 3.0),
    primary: Colors.grey[400],
    textStyle: const TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: _textSizeMedium,
    ),
    side: BorderSide(
      width: 2.0,
      color: backgroundColor,
    )
  );

  static final textDefaultRed = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: colorLogoRed,
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

    static Future<void> setStyles() async {
    List<Setting> listOfSettings = await TokiDatabase.instance.readAllSettings();

    late Setting themeColor;
    late Setting nightmodeSetting;
    for (Setting setting in listOfSettings) {
      if (setting.name == 'Theme Color') {
        themeColor = setting;
      } else if (setting.name == 'Nightmode') {
        nightmodeSetting = setting;
      }
    }

    if (themeColor.settingData == 'blue') {
      selectedAccentColor = colorLogoBlue;
    } else if (themeColor.settingData == 'green') {
      selectedAccentColor = colorLogoGreen;
    } else if (themeColor.settingData == 'red') {
      selectedAccentColor = colorLogoRed;
    } else if (themeColor.settingData == 'tan') {
      selectedAccentColor = colorLogoTan;
    } else {
      Exception('Theme color ${themeColor.settingData} does not match logo colors');
    }

    if (nightmodeSetting.settingData == 'false') {
      backgroundColor = whiteColor;
    } else if (nightmodeSetting.settingData == 'true') {
      backgroundColor = darkColor;
    } else {
      Exception('Nightmode setting ${nightmodeSetting.settingData} does not match true or false');
    }
  }
}