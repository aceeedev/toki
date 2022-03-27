import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/backend/database_helpers.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/model/setting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String appVersion = '';
  late String themeColor = 'blue';
  late String lightNightMode = 'light';

  @override
  void initState() {
    super.initState();

    getVersion();
    getValues();
  }

  Future getVersion() async {
    final String preAppVersion = await getValue('Version');
    if (mounted) {
      setState(() {
        appVersion = preAppVersion;
      });
    }
  }

  Future getValues() async {
    final String preThemeColor = await getValue('Theme Color');
    final String preLightNightMode = await getValue('Light/Night Mode');
    if (mounted) {
      setState(() {
        themeColor = preThemeColor;
        lightNightMode = preLightNightMode;
      });
    }
  }

  Future<String> getValue(String settingName) async {
    return (await TokiDatabase.instance.readSetting(null, settingName)).settingData;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<Styles>().backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: Icon(
                    Icons.arrow_back,
                    size: 48.0,
                    color: context.watch<Styles>().selectedAccentColor,
                  )
                ),
              ),
            ),
            const PageTitle(
              title: 'Settings',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  settingTitle('Appearance'),
                  settingRowDropdown(
                    titleName: 'Theme Color',
                    icon: Icons.color_lens,
                    selectedValue: themeColor,
                    dropdownOptions: <DropdownMenuItem<String>> [
                      DropdownMenuItem(
                        child: Text(
                          'Blue',
                          style: context.watch<Styles>().textDefault,
                        ),
                        value: 'blue',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Green',
                          style: context.watch<Styles>().textDefault,
                        ),
                        value: 'green',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Red',
                          style: context.watch<Styles>().textDefault,
                        ),
                        value: 'red',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Tan',
                          style: context.watch<Styles>().textDefault,
                        ),
                        value: 'tan',
                      ),
                    ],
                    onSelectDropDown: (String valueSelected) async {
                      setState(() {
                          themeColor = valueSelected;
                      });
                      Setting setting = await TokiDatabase.instance.readSetting(null, 'Theme Color');
                      Setting updatedSetting = Setting(
                        id: setting.id,
                        name: setting.name,
                        settingData: valueSelected,
                      );
      
                      TokiDatabase.instance.updateSetting(updatedSetting);
                      context.read<Styles>().setStyles();
                    }
                  ),
                  settingRowDropdown(
                    titleName: 'Light/Night Mode',
                    icon: lightNightMode == 'light' ? Icons.light_mode : Icons.dark_mode,
                    selectedValue: lightNightMode,
                    dropdownOptions: <DropdownMenuItem<String>> [
                      DropdownMenuItem(
                        child: Text(
                          'Light Mode',
                          style: context.watch<Styles>().textDefault,
                        ),
                        value: 'light',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Night Mode',
                          style: context.watch<Styles>().textDefault,
                        ),
                        value: 'night',
                      ),
                    ],
                    onSelectDropDown: (String valueSelected) async {
                      setState(() {
                          lightNightMode = valueSelected;
                      });
                      Setting setting = await TokiDatabase.instance.readSetting(null, 'Light/Night Mode');
                      Setting updatedSetting = Setting(
                        id: setting.id,
                        name: setting.name,
                        settingData: valueSelected,
                      );
      
                      TokiDatabase.instance.updateSetting(updatedSetting);
                      context.read<Styles>().setStyles();
                    }
                  ),
                  settingDivider(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Version: $appVersion',
                      style: context.watch<Styles>().mediumTextDefault,
                    ),
                  ),
                ],
              )
            ),
          ]
        ),
      ),
    );
  }

  Widget settingTitle(String title) {
    return Text(
      title,
      style: context.watch<Styles>().largeTextDefault
    );
  }

  /// creates a divider. type could be same or new (changes thickness)
  Widget settingDivider() {
    return const Divider(
      indent: 20.0,
      endIndent: 20.0,
      thickness:2.0,
    );
  }

  Widget settingRowDropdown({
    required String titleName, 
    required IconData icon, 
    required String selectedValue,
    required List<DropdownMenuItem<String>> dropdownOptions, 
    required Function onSelectDropDown}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 48.0,
          color: context.watch<Styles>().selectedAccentColor,
        ),
        Text(
          titleName,
          style: context.watch<Styles>().mediumTextDefault,
        ),
        Theme(
          data: ThemeData(
            canvasColor: context.watch<Styles>().secondBackgroundColor
          ),
          child: DropdownButton(
            items: dropdownOptions, 
            value: selectedValue,
            onChanged: (value) => onSelectDropDown(value),
          ),
        ),
      ]
    );
  }
}