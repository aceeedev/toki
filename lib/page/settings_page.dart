import 'package:flutter/material.dart';

import 'package:toki/backend/database_helpers.dart';
import 'package:toki/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/model/setting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String appVersion = '';

  @override
  void initState() {
    super.initState();

    getVersion();
  }

  Future getVersion() async {
    final String preAppVersion = (await TokiDatabase.instance.readSetting(null, 'Version')).settingData;
    if (mounted) {
      setState(() {
        appVersion = preAppVersion;
      });
    }
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
                  onSelectDropDown: (valueSelected) async {
                    Setting setting = await TokiDatabase.instance.readSetting(null, 'Theme Color');
                    Setting updatedSetting = Setting(
                      id: setting.id,
                      name: setting.name,
                      settingData: valueSelected,
                    );

                    TokiDatabase.instance.updateSetting(updatedSetting);
                    await Styles.setStyles();
                  }
                ),
                settingDivider(),
                settingRowDropdown(
                  titleName: 'Nightmode / Lightmode', 
                  icon: Icons.light_mode, 
                  dropdownOptions:  const <DropdownMenuItem<String>> [
                    DropdownMenuItem(
                      child: Text('Light Mode'),
                      value: 'false',
                    ),
                    DropdownMenuItem(
                      child: Text('Night mode'),
                      value: 'true',
                    ),
                  ],
                  onSelectDropDown: (valueSelected) async {
                    Setting setting = await TokiDatabase.instance.readSetting(null, 'Theme Color');
                    Setting updatedSetting = Setting(
                      id: setting.id,
                      name: setting.name,
                      settingData: valueSelected,
                    );

                    TokiDatabase.instance.updateSetting(updatedSetting);
                    await Styles.setStyles();
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
          onChanged: (value) => onSelectDropDown(value),
        ),
      ]
    );
  }
}