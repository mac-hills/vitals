import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../databaseconfig/database_helper.dart';
import '../domain/vital_sign_class.dart';

class VitalSignsController {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<VitalSign?> getVitalSignById(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.query('vital_signs', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return VitalSign.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<VitalSign>> getAllVitalSigns() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.query('vital_signs');
    return result.map((map) => VitalSign.fromMap(map)).toList();
  }

  Future<void> addVitalSign(VitalSign vitalSign) async {
    try {
      await dbHelper.insertVitalSign(vitalSign);
    } catch (e) {
      print('Error adding vital sign: $e');
      throw e;
    }
  }

  Future<void> updateVitalSign(VitalSign vitalSign) async {
    Database db = await dbHelper.database;
    await db.update('vital_signs', vitalSign.toMap(), where: 'id = ?', whereArgs: [vitalSign.id]);
  }

  Future<void> deleteVitalSign(int id) async {
    Database db = await dbHelper.database;
    await db.delete('vital_signs', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> addHistoricData() async {
    try {
      String data = await rootBundle.loadString('assets/data.csv');
      List<String> lines = LineSplitter().convert(data);
      lines.removeAt(0);
      for (String line in lines) {
        List<String> parts = line.split(',');
        String dateStr = parts[0];
        String timeStr = parts[1];
        int systolicPressure = int.parse(parts[2]);
        int diastolicPressure = int.parse(parts[3]);
        int heartRate = int.parse(parts[4]);
        DateTime date = DateTime.parse(dateStr + ' ' + timeStr);

        VitalSign vitalSign = VitalSign(
          date: date,
          systolicPressure: systolicPressure,
          diastolicPressure: diastolicPressure,
          heartRate: heartRate,
        );
        await dbHelper.insertVitalSign(vitalSign);
      }
    } catch (e) {
      print('Error adding historic data: $e');
    }
  }
}