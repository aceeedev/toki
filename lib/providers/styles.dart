import 'package:flutter/material.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/model/setting.dart';

class Styles with ChangeNotifier{
  static const _textSizeLarge = 18.0;
  static const _textSizeMedium = 13.0;
  static const _textSizeDefault = 11.0;
  static const _textSizePageTitle = 40.0;

  static final MaterialColor _colorBlack = _createMaterialColor(const Color(0xff111111));
  static final MaterialColor _colorWhite = _createMaterialColor(const Color(0xffaaaaaa));
  static final MaterialColor _colorLogoGreen = _createMaterialColor(const Color(0xffC6D57E));
  static final MaterialColor _colorLogoRed = _createMaterialColor(const Color(0xffD57E7E));
  static final MaterialColor _colorLogoBlue = _createMaterialColor(const Color(0xffA2CDCD));
  static final MaterialColor _colorLogoTan = _createMaterialColor(const Color(0xffFFE1AF));
  static final MaterialColor _whiteColor = _createMaterialColor(const Color(0xffFFFFFF));
  static final MaterialColor _blackColor = _createMaterialColor(const Color(0xff000000));
  static final MaterialColor _lightColor = _createMaterialColor(const Color(0xffFAFAFA));
  static final MaterialColor _nightColor = _createMaterialColor(const Color(0xff121212));

  static const String _fontNameDefault = 'M+ 1C';

  static const double _alarmFormCardHeight = 100.0;
  static const double _alarmFormCardWidth = 350.0;
  static const Size _alarmFormButtonFixedSize = Size(125.0, 30.0);

  double get alarmFormCardHeight => _alarmFormCardHeight;
  double get alarmFormCardWidth => _alarmFormCardWidth;


  static MaterialColor _selectedAccentColor = _colorLogoBlue;
  static MaterialColor _textColorDefault = _colorBlack;
  static MaterialColor _secondBackgroundColor = _whiteColor;
  static MaterialColor _backgroundColor = _lightColor;

  MaterialColor get selectedAccentColor => _selectedAccentColor;
  MaterialColor get textColorDefault => _textColorDefault;
  MaterialColor get secondBackgroundColor => _secondBackgroundColor;
  MaterialColor get backgroundColor => _backgroundColor;

  MaterialColor get colorLogoGreen => _colorLogoGreen;
  MaterialColor get colorLogoRed => _colorLogoRed;
  MaterialColor get colorLogoBlue => _colorLogoBlue;
  MaterialColor get colorLogoTan => _colorLogoTan;


  TextStyle _pageTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizePageTitle,
    fontWeight: FontWeight.w700,
    color: _textColorDefault,
  );

  TextStyle _alarmTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    fontWeight: FontWeight.w700,
    color: _textColorDefault,
  );

  TextStyle _alarmDateUnselected = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault[200],
  );

  TextStyle _selectTimeText = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: _selectedAccentColor,
  );

  TextStyle _textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  TextStyle _largeTextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: _textColorDefault,
  );

  TextStyle _mediumTextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeMedium,
    color: _textColorDefault,
  );

  ButtonStyle _alarmFormButtonStyle = ElevatedButton.styleFrom(
    fixedSize: _alarmFormButtonFixedSize, 
    primary: _selectedAccentColor,
  );

  static final _dayButtonStyleSelected = TextButton.styleFrom(
    minimumSize: const Size(3.0, 3.0),
    primary: _selectedAccentColor[500],
    textStyle: const TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: _textSizeMedium,
    ),
    side: BorderSide(
      width: 2.0,
      color: _selectedAccentColor,
    ),
  );

  static final _dayButtonStyleNotSelected = TextButton.styleFrom(
    minimumSize: const Size(3.0, 3.0),
    primary: Colors.grey[400],
    textStyle: const TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: _textSizeDefault,
    ),
    side: BorderSide(
      width: 2.0,
      color: _backgroundColor,
    )
  );

  static final _textDefaultRed = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _colorLogoRed,
  );


  TextStyle get pageTitle => _pageTitle;
  TextStyle get alarmTitle => _alarmTitle;
  TextStyle get alarmDateUnselected => _alarmDateUnselected;
  TextStyle get selectTimeText => _selectTimeText;
  TextStyle get textDefault => _textDefault;
  TextStyle get largeTextDefault => _largeTextDefault;
  TextStyle get mediumTextDefault => _mediumTextDefault;
  ButtonStyle get alarmFormButtonStyle => _alarmFormButtonStyle;
  ButtonStyle get dayButtonStyleSelected => _dayButtonStyleSelected;
  ButtonStyle get dayButtonStyleNotSelected => _dayButtonStyleNotSelected;
  TextStyle get textDefaultRed => _textDefaultRed;



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

  Future<void> setStyles() async {
    List<Setting> listOfSettings = await TokiDatabase.instance.readAllSettings();

    if (listOfSettings.isNotEmpty) {
      late Setting themeColor;
      late Setting lightNightMode;

      for (Setting setting in listOfSettings) {
        if (setting.name == 'Theme Color') {
          themeColor = setting;
        } else if (setting.name == 'Light/Night Mode') {
          lightNightMode = setting;
        }
      }

      // change theme color
      if (themeColor.settingData == 'blue') {
        _selectedAccentColor = _colorLogoBlue;
      } else if (themeColor.settingData == 'green') {
        _selectedAccentColor = _colorLogoGreen;
      } else if (themeColor.settingData == 'red') {
        _selectedAccentColor = _colorLogoRed;
      } else if (themeColor.settingData == 'tan') {
        _selectedAccentColor = _colorLogoTan;
      } else {
        Exception('Theme color ${themeColor.settingData} does not match logo colors');
      }

      _selectTimeText = _selectTimeText.copyWith(color: _selectedAccentColor);
      _alarmFormButtonStyle = ElevatedButton.styleFrom(
        fixedSize: _alarmFormButtonFixedSize, 
        primary: _selectedAccentColor
      );

      // change light/night mode
      if (lightNightMode.settingData == 'light') {
        _backgroundColor = _lightColor;
        _secondBackgroundColor = _whiteColor;
        _textColorDefault = _colorBlack;

        _alarmDateUnselected = _alarmDateUnselected.copyWith(color: _textColorDefault[200]);
      } else if (lightNightMode.settingData == 'night') {
        _backgroundColor = _nightColor;
        _secondBackgroundColor = _blackColor;
        _textColorDefault = _colorWhite;

        _alarmDateUnselected = _alarmDateUnselected.copyWith(color: _textColorDefault[800]);
      } else {
        Exception('Light/Night Mode ${lightNightMode.settingData} does not match light or night');
      }

      _pageTitle = _pageTitle.copyWith(color: _textColorDefault);
      _alarmTitle = _alarmTitle.copyWith(color: _textColorDefault);
      _textDefault = _textDefault.copyWith(color: _textColorDefault);
      _largeTextDefault = _largeTextDefault.copyWith(color: _textColorDefault);
      _mediumTextDefault = _mediumTextDefault.copyWith(color: _textColorDefault);


      
       notifyListeners();
    }
  }
}