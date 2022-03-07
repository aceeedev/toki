import 'package:path/path.dart';
import 'dart:io';
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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const textType = 'TEXT NOT NULL';
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
  ${AlarmFields.alarmRingtone} $textType,
  ${AlarmFields.alarmOn} $boolType
  )
''');
  }

  Future<Alarm> create(Alarm alarm) async {
    final db = await instance.database;

    final id = await db.insert(tableAlarms, alarm.toJson());
    return alarm.copy(id: id);
  }

  Future<Alarm> readAlarm(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableAlarms,
      columns: AlarmFields.values,
      where: '${AlarmFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Alarm.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Alarm>> readAllAlarms() async {
    final db = await instance.database;

    final orderBy = '${AlarmFields.time} ASC';

    final result = await db.query(tableAlarms, orderBy: orderBy);

    return result.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<int> update(Alarm alarm) async {
    final db = await instance.database;

    return db.update(
      tableAlarms,
      alarm.toJson(),
      where: '${AlarmFields.id} = ?',
      whereArgs: [alarm.id],
    );  
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableAlarms,
      where: '${AlarmFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'toki.db');

    return await openDatabase(
      path, 
      version: 1, 
    );
  }
}