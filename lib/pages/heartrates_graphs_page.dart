import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../databaseconfig/database_helper.dart';
import '../domain/vital_sign_class.dart';

class HeartRatesGraphsPage extends StatefulWidget {
  @override
  _HeartRatesGraphsPageState createState() => _HeartRatesGraphsPageState();
}

class _HeartRatesGraphsPageState extends State<HeartRatesGraphsPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<VitalSign>? _vitalSigns;

  @override
  void initState() {
    super.initState();
    _fetchVitalSigns();
  }

  Future<void> _fetchVitalSigns() async {
    List<VitalSign> vitalSigns = await dbHelper.getAllVitalSigns();
    setState(() {
      _vitalSigns = vitalSigns;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart rates chart'),
      ),
      body: _vitalSigns == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            Expanded(
              child: LineChart(
                _createHeartRateChartData(),
                swapAnimationDuration: Duration(milliseconds: 500),
                swapAnimationCurve: Curves.linear,
              ),
            ),
          ],
        ),
      ),
    );
  }



  LineChartData _createHeartRateChartData() {
    List<Color> colors = [Colors.green];
    List<String> labels = ['Heart Rate'];
    List<List<double>> dataList = [
      _vitalSigns!.map((vitalSign) => vitalSign.heartRate.toDouble()).toList(),
    ];

    return _createChartData(colors, labels, dataList);
  }

  LineChartData _createChartData(List<Color> colors, List<String> labels, List<List<double>> dataList) {
    return LineChartData(
      lineBarsData: List.generate(colors.length, (index) {
        return _createLineData(
          color: colors[index],
          dataList: dataList[index],
        );
      }),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value % 10 == 0) {
              return value.toInt().toString();
            }
            return '';
          },
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitles: (value) {
            if (value == 50) {
              return '${_vitalSigns![0].date.day}-${_vitalSigns![0].date.month}-${_vitalSigns![0].date.year} -> today'; // Return the first date only
            }
            return '';
          },
          margin: 10,
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: (_vitalSigns!.length).toDouble(),
      minY: 40,
      maxY: _calculateMaxY(dataList) + 10, // Change the step size to 10
    );
  }

  double _calculateMaxY(List<List<double>> dataList) {
    double maxY = 0;
    for (var data in dataList) {
      for (var value in data) {
        if (value > maxY) {
          maxY = value;
        }
      }
    }
    return maxY;
  }

  LineChartBarData _createLineData({
    required Color color,
    required List<double> dataList,
  }) {
    return LineChartBarData(
      spots: dataList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
      isCurved: true,
      colors: [color],
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}
