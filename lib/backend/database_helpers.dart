import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/model/puzzle.dart';

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
    const integerType = 'INTEGER NOT NULL';
    
    // create alarm table
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
  ${AlarmFields.alarmOn} $boolType,
  ${AlarmFields.currentAlarm} $boolType
  )
''');

    // create puzzle table
    await db.execute('''
CREATE TABLE $tablePuzzles (
  ${PuzzleFields.id} $idType,
  ${PuzzleFields.name} $textType,
  ${PuzzleFields.difficulty} $integerType,
  ${PuzzleFields.enabled} $boolType
  )
''');

    // initalize puzzles 
    List<String> puzzleNames = ['Matching Icons', 'Maze'];
    for (String name in puzzleNames) {
      Puzzle puzzle = Puzzle(
        name: name,
        difficulty: 2,
        enabled: true,
      );
      _createPuzzle(puzzle);
    }
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<Alarm> createAlarm(Alarm alarm) async {
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

  /// Returns a list of all the alarms in the database
  /// 
  /// [orderBySelector] can be ['TIME ASC'] or ['Id ASC]
  Future<List<Alarm>> readAllAlarms(String orderBySelector) async {
    final db = await instance.database;

    String orderBy = '${AlarmFields.time} ASC';
    switch (orderBySelector) {
      case 'Time ASC': {
        orderBy = '${AlarmFields.time} ASC';
      }
      break;

      case 'Id ASC': {
        orderBy = '${AlarmFields.id} ASC';
      }
    }
    orderBy = '${AlarmFields.time} ASC';

    final result = await db.query(tableAlarms, orderBy: orderBy);

    return result.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<int> updateAlarm(Alarm alarm) async {
    final db = await instance.database;

    return db.update(
      tableAlarms,
      alarm.toJson(),
      where: '${AlarmFields.id} = ?',
      whereArgs: [alarm.id],
    );  
  }

  Future<int> deleteAlarm(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableAlarms,
      where: '${AlarmFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Puzzle> _createPuzzle(Puzzle puzzle) async {
    final db = await instance.database;

    final id = await db.insert(tablePuzzles, puzzle.toJson());
    return puzzle.copy(id: id);
  }

  Future<Puzzle> readPuzzle(int? id, String? puzzleName) async {
    final db = await instance.database;

    if (id != null && puzzleName != null) {
      throw Exception('Only have one parameter, either id or puzzleName');
    } else if (id != null) {
      final maps = await db.query(
        tablePuzzles,
        columns: PuzzleFields.values,
        where: '${PuzzleFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Puzzle.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    } else if (puzzleName != null) {
      final maps = await db.query(
        tablePuzzles,
        columns: PuzzleFields.values,
        where: '${PuzzleFields.name} = ?',
        whereArgs: [puzzleName],
      );

      if (maps.isNotEmpty) {
        return Puzzle.fromJson(maps.first);
      } else {
        throw Exception('puzzleName $puzzleName not found');
      }
    } else {
      throw Exception('Both id and puzzleName are null');
    }
  }

  Future<List<Puzzle>> readAllPuzzles() async {
    final db = await instance.database;

    String orderBy = '${PuzzleFields.id} ASC';

    final result = await db.query(tablePuzzles, orderBy: orderBy);

    return result.map((json) => Puzzle.fromJson(json)).toList();
  }

  Future<int> updatePuzzle(Puzzle puzzle) async {
    final db = await instance.database;

    return db.update(
      tablePuzzles,
      puzzle.toJson(),
      where: '${PuzzleFields.id} = ?',
      whereArgs: [puzzle.id],
    );  
  }
}