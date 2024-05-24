import 'package:firebase_database/firebase_database.dart';

class Terrarium {
  String key;
  String name;
  double foodLevel;
  double waterLevel;
  double temperature;
  double humidity;
  String ledStatus;
  String heaterStatus;
  double minTemperature;
  double maxTemperature;
  double minHumidity;
  double maxHumidity;
  int minLightHours;
  int maxLightHours;
  int minHeaterHours;
  int maxHeaterHours;
  int minFeedingHours;
  int maxFeedingHours;
  Map<String, dynamic> activity;

  Terrarium({
    required this.key,
    required this.name,
    required this.foodLevel,
    required this.waterLevel,
    required this.temperature,
    required this.humidity,
    required this.ledStatus,
    required this.heaterStatus,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minHumidity,
    required this.maxHumidity,
    required this.minLightHours,
    required this.maxLightHours,
    required this.minHeaterHours,
    required this.maxHeaterHours,
    required this.minFeedingHours,
    required this.maxFeedingHours,
    required this.activity,
  });

  factory Terrarium.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Terrarium(
      key: snapshot.key ?? '',
      name: data['name'] as String? ?? '',
      foodLevel: (data['foodLevel'] as num?)?.toDouble() ?? 0.0,
      waterLevel: (data['waterLevel'] as num?)?.toDouble() ?? 0.0,
      temperature: (data['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (data['humidity'] as num?)?.toDouble() ?? 0.0,
      ledStatus: data['ledStatus'] as String? ?? 'OFF',
      heaterStatus: data['heaterStatus'] as String? ?? 'OFF',
      minTemperature: (data['minTemperature'] as num?)?.toDouble() ?? 0.0,
      maxTemperature: (data['maxTemperature'] as num?)?.toDouble() ?? 0.0,
      minHumidity: (data['minHumidity'] as num?)?.toDouble() ?? 0.0,
      maxHumidity: (data['maxHumidity'] as num?)?.toDouble() ?? 0.0,
      minLightHours: (data['minLightHours'] as num?)?.toInt() ?? 0,
      maxLightHours: (data['maxLightHours'] as num?)?.toInt() ?? 0,
      minHeaterHours: (data['minHeaterHours'] as num?)?.toInt() ?? 0,
      maxHeaterHours: (data['maxHeaterHours'] as num?)?.toInt() ?? 0,
      minFeedingHours: (data['minFeedingHours'] as num?)?.toInt() ?? 0,
      maxFeedingHours: (data['maxFeedingHours'] as num?)?.toInt() ?? 0,
      activity: Map<String, dynamic>.from(data['activity'] as Map<dynamic, dynamic>? ?? {}),
    );
  }
}
