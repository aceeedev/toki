import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toki/model/alarm.dart';

class TokiDatabase {
  static final TokiDatabase instance = TokiDatabase._init();

  static Database? _database;

  TokiDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('toki.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _createDB
    );
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    //final integerType = 'INTEGER NOT NULL';
    
    await db.execute('''
CREATE TABLE $tableAlarms (
  ${AlarmFields.id} $idType,
  ${AlarmFields.time} $textType,
  ${AlarmFields.selectedSu} $boolType,
  ${AlarmFields.selectedMo} $boolType,
  ${AlarmFields.selectedTu} $boolType,
  ${AlarmFields.selectedWe} $boolType,
  ${AlarmFields.selectedTh} $boolType,
  ${AlarmFields.selectedFr} $boolType,
  ${AlarmFields.selectedSa} $boolType,
  ${AlarmFields.alarmName} $textType,
  ${AlarmFields.alarmRingtone} $textType
)
''');
  }

  /*Future<Alarm> create(Alarm alarm) async {
    // left off here
  }*/

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}