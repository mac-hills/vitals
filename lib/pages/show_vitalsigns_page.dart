import 'dart:io';
import 'package:flutter/material.dart';
import '../databaseconfig/database_helper.dart';
import '../domain/vital_sign_class.dart';

class ShowVitalSignsPage extends StatefulWidget {
  @override
  _ShowVitalSignsPageState createState() => _ShowVitalSignsPageState();
}

class _ShowVitalSignsPageState extends State<ShowVitalSignsPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  late List<VitalSign> _vitalSigns;

  @override
  void initState() {
    super.initState();
    _fetchVitalSigns();
  }

  Future<void> _fetchVitalSigns() async {
    List<VitalSign> vitalSigns = await dbHelper.getAllVitalSigns();
    setState(() {
      _vitalSigns = vitalSigns.reversed.toList();
    });
  }

  Future<void> _deleteVitalSign(int? id) async {
    if (id != null) {
      await dbHelper.deleteVitalSign(id);
      _fetchVitalSigns();
    } else {
      print('Error: Attempted to delete a vital sign with null id.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vitalSigns == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _vitalSigns.length,
        itemBuilder: (context, index) {
          final VitalSign vitalSign = _vitalSigns[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${vitalSign.date.year}-${vitalSign.date
                            .month}-${vitalSign.date.day}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteVitalSign(vitalSign.id),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blood Pressure: ${vitalSign
                                  .systolicPressure}/${vitalSign
                                  .diastolicPressure}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Heart Rate: ${vitalSign.heartRate}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'ID: ${vitalSign.id}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}
  Future<List<String>> readDataFromDevice() async {
  final File file = File('Deze pc/OnePlus Nord2 5G/Internal shared storage/vitalsData/data.csv'); // Adjust the path accordingly
  List<String> contents = await file.readAsLines();
  return contents;
}