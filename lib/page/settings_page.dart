import 'package:flutter/material.dart';

import 'package:toki/backend/database_helpers.dart';
import 'package:toki/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/model/setting.dart';

class SettingsPage extends StatefulWidget {
  final Function refreshAppearance;
  const SettingsPage({Key? key, required this.refreshAppearance}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String appVersion = '';
  late String themeColor = 'blue';

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
    if (mounted) {
      setState(() {
        themeColor = preThemeColor;
      });
    } else {
      print('not mounted');
    }
  }

  Future<String> getValue(String settingName) async {
    return (await TokiDatabase.instance.readSetting(null, settingName)).settingData;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 10.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: Icon(
                  Icons.arrow_back,
                  size: 48.0,
                  color: Styles.selectedAccentColor,
                )
              ),
            ),
          ),
          const PageTitle(
            title: 'Settings',
            padding: false,
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
                  dropdownOptions: const <DropdownMenuItem<String>> [
                    DropdownMenuItem(
                      child: Text('Blue'),
                      value: 'blue',
                    ),
                    DropdownMenuItem(
                      child: Text('Green'),
                      value: 'green',
                    ),
                    DropdownMenuItem(
                      child: Text('Red'),
                      value: 'red',
                    ),
                    DropdownMenuItem(
                      child: Text('Tan'),
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
                    setState(() {
                      Styles.setStyles();
                    });
                    widget.refreshAppearance();
                  }
                ),
                settingDivider(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Version: $appVersion',
                    style: Styles.mediumTextDefault,
                  ),
                ),
              ],
            )
          ),
        ]
      ),
    );
  }

  Widget settingTitle(String title) {
    return Text(
      title,
      style: Styles.largeTextDefault
    );
  }

  Widget settingDivider() {
    return const Divider(
      indent: 20.0,
      endIndent: 20.0,
      thickness: 2.0,
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
          color: Styles.selectedAccentColor,
        ),
        Text(
          titleName,
          style: Styles.mediumTextDefault,
        ),
        DropdownButton(
          items: dropdownOptions, 
          value: selectedValue,
          onChanged: (value) => onSelectDropDown(value),
        ),
      ]
    );
  }
}