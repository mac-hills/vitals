import 'package:flutter/material.dart';
import 'package:vitals/pages/bloodpressures_graphs_page.dart';
import 'package:vitals/pages/heartrates_graphs_page.dart';

class VitalSignsGraphsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vital Signs Charts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 100, // Double the current height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BloodPressureGraphsPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Blood Pressure', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HeartRatesGraphsPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Heart Rates', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
