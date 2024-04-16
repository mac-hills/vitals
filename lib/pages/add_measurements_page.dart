import 'package:flutter/material.dart';
import '../domain/vital_sign_class.dart';
import '../controller/vital_signs_controller.dart';

class AddMeasurementsPage extends StatefulWidget {
  @override
  _AddMeasurementsPageState createState() => _AddMeasurementsPageState();
}

class _AddMeasurementsPageState extends State<AddMeasurementsPage> {
  final _controller = VitalSignsController();
  final _formKey = GlobalKey<FormState>();

  int _systolicPressure = 0;
  int _diastolicPressure = 0;
  int _heartRate = 0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Use current date
      DateTime currentDate = DateTime.now();

      VitalSign vitalSign = VitalSign(
        date: currentDate,
        systolicPressure: _systolicPressure,
        diastolicPressure: _diastolicPressure,
        heartRate: _heartRate,
      );

      await _controller.addVitalSign(vitalSign);

      // Show success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vital sign added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Systolic Pressure'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter systolic pressure';
                  }
                  return null;
                },
                onSaved: (value) => _systolicPressure = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Diastolic Pressure'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter diastolic pressure';
                  }
                  return null;
                },
                onSaved: (value) => _diastolicPressure = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Heart Rate'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter heart rate';
                  }
                  return null;
                },
                onSaved: (value) => _heartRate = int.parse(value!),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Measurement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
