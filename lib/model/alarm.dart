const String tableAlarms = 'alarms';

class AlarmFields {
  static final List<String> values = [
    id, 
    time, 
    selectedSu, 
    selectedMo, 
    selectedTu, 
    selectedWe, 
    selectedTh, 
    selectedFr, 
    selectedSa, 
    alarmName, 
    alarmRingtone, 
    alarmOn, 
    currentAlarm
  ];

  static const String id = '_id';
  static const String time = 'time';
  static const String selectedSu = 'selectedSu';
  static const String selectedMo = 'selectedMo';
  static const String selectedTu = 'selectedTu';
  static const String selectedWe = 'selectedWe';
  static const String selectedTh = 'selectedTh';
  static const String selectedFr = 'selectedFr';
  static const String selectedSa = 'selectedSa';
  static const String alarmName = 'alarmName';
  static const String alarmRingtone = 'alarmRingtone';
  static const String alarmOn = 'alarmOn';
  static const String currentAlarm = 'currentAlarm';
}

class Alarm {
  final int? id;
  final DateTime time;
  final bool selectedSu;
  final bool selectedMo;
  final bool selectedTu;
  final bool selectedWe;
  final bool selectedTh;
  final bool selectedFr;
  final bool selectedSa;
  final String alarmName;
  final String alarmRingtone;
  final bool alarmOn;
  final bool currentAlarm;

  const Alarm({
    this.id,
    required this.time,
    required this.selectedSu,
    required this.selectedMo,
    required this.selectedTu,
    required this.selectedWe,
    required this.selectedTh,
    required this.selectedFr,
    required this.selectedSa,
    required this.alarmName,
    required this.alarmRingtone,
    required this.alarmOn,
    required this.currentAlarm
  });

  Alarm copy({
    int? id,
    DateTime? time,
    bool? selectedSu,
    bool? selectedMo,
    bool? selectedTu,
    bool? selectedWe,
    bool? selectedTh,
    bool? selectedFr,
    bool? selectedSa,
    String? alarmName,
    String? alarmRingtone,
    bool? alarmOn,
    bool? currentAlarm,
  }) =>
    Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      selectedSu: selectedSu ?? this.selectedSu,
      selectedMo: selectedMo ?? this.selectedMo,
      selectedTu: selectedTu ?? this.selectedTu,
      selectedWe: selectedWe ?? this.selectedWe,
      selectedTh: selectedTh ?? this.selectedTh,
      selectedFr: selectedFr ?? this.selectedFr,
      selectedSa: selectedSa ?? this.selectedSa,
      alarmName: alarmName ?? this.alarmName,
      alarmRingtone: alarmRingtone ?? this.alarmRingtone,
      alarmOn: alarmOn ?? this.alarmOn,
      currentAlarm: currentAlarm ?? this.currentAlarm,
    );

    Map<String, Object?> toJson() => {
    AlarmFields.id: id,
    AlarmFields.time: time.toIso8601String(),
    AlarmFields.selectedSu: selectedSu ? 1 : 0,
    AlarmFields.selectedMo: selectedMo ? 1 : 0,
    AlarmFields.selectedTu: selectedTu ? 1 : 0,
    AlarmFields.selectedWe: selectedWe ? 1 : 0,
    AlarmFields.selectedTh: selectedTh ? 1 : 0,
    AlarmFields.selectedFr: selectedFr ? 1 : 0,
    AlarmFields.selectedSa: selectedSa ? 1 : 0,
    AlarmFields.alarmName: alarmName,
    AlarmFields.alarmRingtone: alarmRingtone,
    AlarmFields.alarmOn: alarmOn ? 1 : 0,
    AlarmFields.currentAlarm: currentAlarm ? 1 : 0,
  };

  static Alarm fromJson(Map<String, Object?> json) => Alarm(
    id: json[AlarmFields.id] as int?,
    time: DateTime.parse(json[AlarmFields.time] as String),
    selectedSu: json[AlarmFields.selectedSu] == 1,
    selectedMo: json[AlarmFields.selectedMo] == 1,
    selectedTu: json[AlarmFields.selectedTu] == 1,
    selectedWe: json[AlarmFields.selectedWe] == 1,
    selectedTh: json[AlarmFields.selectedTh] == 1,
    selectedFr: json[AlarmFields.selectedFr] == 1,
    selectedSa: json[AlarmFields.selectedSa] == 1,
    alarmName: json[AlarmFields.alarmName] as String,
    alarmRingtone: json[AlarmFields.alarmRingtone] as String,
    alarmOn: json[AlarmFields.alarmOn] == 1,
    currentAlarm: json[AlarmFields.currentAlarm] == 1,
  );
}