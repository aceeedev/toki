final String tableAlarms = 'alarms';

class AlarmFields {
  static final String id = '_id';
  static final String time = 'time';
  static final String selectedSu = 'selectedSu';
  static final String selectedMo = 'selectedMo';
  static final String selectedTu = 'selectedTu';
  static final String selectedWe = 'selectedWe';
  static final String selectedTh = 'selectedTh';
  static final String selectedFr = 'selectedFr';
  static final String selectedSa = 'selectedSa';
  static final String alarmName = 'alarmName';
  static final String alarmRingtone = 'alarmRingtone';
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
  });
}