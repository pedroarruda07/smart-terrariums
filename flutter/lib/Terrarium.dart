import 'package:firebase_database/firebase_database.dart';

class Terrarium {
  final String key;
  final String name;
  final String ledStatus;
  final double temperature;
  final double humidity;
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
    required this.ledStatus,
    required this.temperature,
    required this.humidity,
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
    final value = snapshot.value as Map<dynamic, dynamic>?;

    if (value == null) {
      throw StateError('Missing data for terrarium snapshot');
    }

    final Map<String, dynamic> terrariumData = value.map<String, dynamic>(
          (key, value) => MapEntry(key as String, value),
    );

    return Terrarium(
      key: snapshot.key!,
      name: terrariumData['name'],
      ledStatus: terrariumData['ledStatus'],
      temperature: (terrariumData['temperature'] as num).toDouble(),
      humidity: (terrariumData['humidity'] as num).toDouble(),
      minTemperature: (terrariumData['minTemp'] as num).toDouble(),
      maxTemperature: (terrariumData['maxTemp'] as num).toDouble(),
      minHumidity: (terrariumData['minHumidity'] as num).toDouble(),
      maxHumidity: (terrariumData['maxHumidity'] as num).toDouble(),
      minLightHours: terrariumData['minLight'],
      maxLightHours: terrariumData['maxLight'],
      minHeaterHours: terrariumData['minHeaterHours'],
      maxHeaterHours: terrariumData['maxHeaterHours'],
      minFeedingHours: terrariumData['minFeedingHours'],
      maxFeedingHours: terrariumData['maxFeedingHours'],
    );
  }
}
