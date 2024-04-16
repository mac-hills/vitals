import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vitals/controller/vital_signs_controller.dart';
import 'package:vitals/domain/vital_sign_class.dart';

class ImportDataPage extends StatefulWidget {
  @override
  _ImportDataPageState createState() => _ImportDataPageState();
}

class _ImportDataPageState extends State<ImportDataPage> {

  Future<void> _importCSVFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      await _processAndImportData(context, file);
    }
  }

  Future<void> _processAndImportData(BuildContext context,File file) async {
    VitalSignsController _controller = VitalSignsController();
    String data = await file.readAsString();
    List<List<dynamic>> rowsAsListOfValues = LineSplitter().convert(data)
        .map((line) => line.split(' '))
        .toList();
    int recordsAdded = 0;
    List<String> errorMessages = [];
    for (List<dynamic> row in rowsAsListOfValues) {
      try {
        String dateStr = row[0];
        String timeStr = row[1];
        int systolicPressure = int.parse(row[2]);
        int diastolicPressure = int.parse(row[3]);
        int heartRate = int.parse(row[4]);

        DateTime date = DateTime.parse('$dateStr $timeStr');

        VitalSign vitalSign = VitalSign(
          date: date,
          systolicPressure: systolicPressure,
          diastolicPressure: diastolicPressure,
          heartRate: heartRate,
        );

        await _controller.addVitalSign(vitalSign);
        recordsAdded++;
      } catch (e) {
        print('Error parsing data: $e');
        errorMessages.add('Error parsing data: $e');
      }
    }
    if (recordsAdded > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$recordsAdded records were added successfully')),
      );
    }

    if (errorMessages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during import. See details below:\n${errorMessages.join('\n')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _importCSVFile(context),
                child: Text('Import CSV File'),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Format for CSV File (space separated)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'yyyy-mm-dd hh:mm SystolicPressure DiastolicPressure HeartRate',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Example for 1 row:',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '2024-04-16 10:42 121 78 65',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
