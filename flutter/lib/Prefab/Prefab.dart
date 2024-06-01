import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Prefab {
  String key;
  String name;
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

  Prefab({
    required this.key,
    required this.name,
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
  });


  factory Prefab.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Prefab(
      key: snapshot.key ?? '',
      name: data['name'] as String? ?? '',
      minTemperature: (data['minTemp'] as num?)?.toDouble() ?? 0.0,
      maxTemperature: (data['maxTemp'] as num?)?.toDouble() ?? 0.0,
      minHumidity: (data['minHumidity'] as num?)?.toDouble() ?? 0.0,
      maxHumidity: (data['maxHumidity'] as num?)?.toDouble() ?? 0.0,
      minLightHours: (data['minLight'] as num?)?.toInt() ?? 0,
      maxLightHours: (data['maxLight'] as num?)?.toInt() ?? 0,
      minHeaterHours: (data['minHeater'] as num?)?.toInt() ?? 0,
      maxHeaterHours: (data['maxHeater'] as num?)?.toInt() ?? 0,
      minFeedingHours: (data['minFeeding'] as num?)?.toInt() ?? 0,
      maxFeedingHours: (data['maxFeeding'] as num?)?.toInt() ?? 0,
    );
  }
}
