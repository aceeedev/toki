const String tableSettings = 'settings';

class SettingFields {
  static final List<String> values = [
    id,
    name,
    settingData,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String settingData = 'settingData';
}

class Setting {
  final int? id;
  final String name;
  final String settingData;

  const Setting({
    this.id,
    required this.name,
    required this.settingData,
  });

  Setting copy({
    int? id,
    String? name,
    String? settingData,
  }) =>
    Setting(
      id: id ?? this.id,
      name: name ?? this.name,
      settingData: settingData ?? this.settingData,
    );

    Map<String, Object?> toJson() => {
      SettingFields.id: id,
      SettingFields.name: name,
      SettingFields.settingData: settingData,
  };

  static Setting fromJson(Map<String, Object?> json) => Setting(
    id: json[SettingFields.id] as int?,
    name: json[SettingFields.name] as String,
    settingData: json[SettingFields.settingData] as String,
  );
}