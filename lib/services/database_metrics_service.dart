import '../databaseconfig/database_helper.dart';
import '../domain/vital_sign_class.dart';

class DatabaseMetricsService {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<Map<String, dynamic>> calculateMetrics() async {
    List<VitalSign> vitalSigns = await dbHelper.getAllVitalSigns();
    int totalRecords = vitalSigns.length;

    int totalSystolicPressure = 0;
    int totalDiastolicPressure = 0;
    int totalHeartRate = 0;
    int minHeartRate = 0;
    int maxHeartRate = 0;
    int minSystolicPressure = 0;
    int maxSystolicPressure = 0;
    int minDiastolicPressure = 0;
    int maxDiastolicPressure = 0;

    if (totalRecords > 0) {
      totalSystolicPressure = vitalSigns.map<int>((e) => e.systolicPressure).reduce((sum, item) => sum + item);
      totalDiastolicPressure = vitalSigns.map<int>((e) => e.diastolicPressure).reduce((sum, item) => sum + item);
      totalHeartRate = vitalSigns.map<int>((e) => e.heartRate).reduce((sum, item) => sum + item);
      minHeartRate = vitalSigns.map<int>((e) => e.heartRate).reduce((curr, next) => curr < next ? curr : next);
      maxHeartRate = vitalSigns.map<int>((e) => e.heartRate).reduce((curr, next) => curr > next ? curr : next);
      minSystolicPressure = vitalSigns.map<int>((e) => e.systolicPressure).reduce((curr, next) => curr < next ? curr : next);
      maxSystolicPressure = vitalSigns.map<int>((e) => e.systolicPressure).reduce((curr, next) => curr > next ? curr : next);
      minDiastolicPressure = vitalSigns.map<int>((e) => e.diastolicPressure).reduce((curr, next) => curr < next ? curr : next);
      maxDiastolicPressure = vitalSigns.map<int>((e) => e.diastolicPressure).reduce((curr, next) => curr > next ? curr : next);
    }

    return {
      'totalRecords': totalRecords,
      'totalSystolicPressure': totalSystolicPressure,
      'totalDiastolicPressure': totalDiastolicPressure,
      'totalHeartRate': totalHeartRate,
      'minHeartRate': minHeartRate,
      'maxHeartRate': maxHeartRate,
      'minSystolicPressure': minSystolicPressure,
      'maxSystolicPressure': maxSystolicPressure,
      'minDiastolicPressure': minDiastolicPressure,
      'maxDiastolicPressure': maxDiastolicPressure,
    };
  }
}
