import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/vital_sign_class.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'vitals_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vital_signs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        systolicPressure INTEGER,
        diastolicPressure INTEGER,
        heartRate INTEGER
      )
    ''');
  }

  Future<int> insertVitalSign(VitalSign vitalSign) async {
    Database db = await database;
    return await db.insert('vital_signs', vitalSign.toMap());
  }

  Future<List<VitalSign>> getAllVitalSigns() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('vital_signs');
    return List.generate(maps.length, (i) {
      return VitalSign(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        systolicPressure: maps[i]['systolicPressure'],
        diastolicPressure: maps[i]['diastolicPressure'],
        heartRate: maps[i]['heartRate'],
      );
    });
  }

  Future<void> updateVitalSign(VitalSign vitalSign) async {
    Database db = await database;
    await db.update('vital_signs', vitalSign.toMap(), where: 'id = ?', whereArgs: [vitalSign.id]);
  }

  Future<void> deleteVitalSign(int id) async {
    Database db = await database;
    await db.delete('vital_signs', where: 'id = ?', whereArgs: [id]);
  }
}
