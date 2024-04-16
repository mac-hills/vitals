import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ImportedFilesProvider extends ChangeNotifier {
  late Database _database;
  List<String> _importedFiles = [];

  List<String> get importedFiles => _importedFiles;

  ImportedFilesProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'imported_files_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE imported_files(id INTEGER PRIMARY KEY, fileName TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> addImportedFile(String fileName) async {
    await _database.insert(
      'imported_files',
      {'fileName': fileName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _importedFiles.add(fileName);
    notifyListeners();
  }

  Future<void> removeImportedFile(String fileName) async {
    await _database.delete(
      'imported_files',
      where: 'fileName = ?',
      whereArgs: [fileName],
    );
    _importedFiles.remove(fileName);
    notifyListeners();
  }

  Future<List<String>> getImportedFiles() async {
    final List<Map<String, dynamic>> maps = await _database.query('imported_files');
    _importedFiles = List.generate(maps.length, (i) {
      return maps[i]['fileName'] as String;
    });
    return _importedFiles;
  }
}
