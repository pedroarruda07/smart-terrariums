import 'package:firebase_database/firebase_database.dart';

class Terrarium {
  final String key;
  final String name;
  final double minTemperature;
  final double maxTemperature;
  final double minHumidity;
  final double maxHumidity;
  final int? minLightHours;
  final int? maxLightHours;
  final int? minHeaterHours;
  final int? maxHeaterHours;
  final int? minFeedingHours;
  final int? maxFeedingHours;

  Terrarium({
    required this.key,
    required this.name,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minHumidity,
    required this.maxHumidity,
    this.minLightHours,
    this.maxLightHours,
    this.minHeaterHours,
    this.maxHeaterHours,
    this.minFeedingHours,
    this.maxFeedingHours,
  });

  factory Terrarium.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> value = snapshot.value as Map<String, dynamic>;
    return Terrarium(
      key: snapshot.key!,
      name: value['name'],
      minTemperature: (value['minTemp'] as num).toDouble(),
      maxTemperature: (value['maxTemp'] as num).toDouble(),
      minHumidity: (value['minHumidity'] as num).toDouble(),
      maxHumidity: (value['maxHumidity'] as num).toDouble(),
      minLightHours: value['minLight'],
      maxLightHours: value['maxLight'],
      minHeaterHours: value['minHeaterHours'],
      maxHeaterHours: value['maxHeaterHours'],
      minFeedingHours: value['minFeedingHours'],
      maxFeedingHours: value['maxFeedingHours'],
    );
  }
}
