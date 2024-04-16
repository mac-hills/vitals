class VitalSign {
  final int? id;
  final DateTime date;
  final int systolicPressure;
  final int diastolicPressure;
  final int heartRate;

  VitalSign({
        this.id,
        required this.date,
        required this.systolicPressure,
        required this.diastolicPressure,
        required this.heartRate
  });
  // Method to convert a VitalSign object to a Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date.toIso8601String(),
      'systolicPressure': systolicPressure,
      'diastolicPressure': diastolicPressure,
      'heartRate': heartRate,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Factory method to create a VitalSign object from a Map
  factory VitalSign.fromMap(Map<String, dynamic> map) {
    return VitalSign(
      id: map['id'],
      date: DateTime.parse(map['date']),
      systolicPressure: map['systolicPressure'],
      diastolicPressure: map['diastolicPressure'],
      heartRate: map['heartRate'],
    );
  }
}
