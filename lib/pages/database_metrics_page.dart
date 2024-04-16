import 'package:flutter/material.dart';
import '../services/database_metrics_service.dart';

class DatabaseMetricsPage extends StatefulWidget {
  @override
  _DatabaseMetricsPageState createState() => _DatabaseMetricsPageState();
}

class _DatabaseMetricsPageState extends State<DatabaseMetricsPage> {
  final DatabaseMetricsService _metricsService = DatabaseMetricsService();
  Map<String, dynamic>? _metrics;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    Map<String, dynamic> metrics = await _metricsService.calculateMetrics();
    setState(() {
      _metrics = metrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Metrics'),
      ),
      body: _metrics != null
          ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL RECORDS',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${_metrics!['totalRecords']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildMetricCard(
              title: 'Blood Pressure',
              min: '${_metrics!['minSystolicPressure']}/${_metrics!['minDiastolicPressure']}',
              max: '${_metrics!['maxSystolicPressure']}/${_metrics!['maxDiastolicPressure']}',
              average: '${(_metrics!['totalSystolicPressure'] / _metrics!['totalRecords']).toStringAsFixed(2)}/${(_metrics!['totalDiastolicPressure'] / _metrics!['totalRecords']).toStringAsFixed(2)}',
            ),
            SizedBox(height: 20),
            _buildMetricCard(
              title: 'Heart Rate',
              min: '${_metrics!['minHeartRate']}',
              max: '${_metrics!['maxHeartRate']}',
              average: '${(_metrics!['totalHeartRate'] / _metrics!['totalRecords']).toStringAsFixed(2)}',
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMetricCard({required String title, required String min, required String max, required String average}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Minimum: $min',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Maximum: $max',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Average: $average',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
