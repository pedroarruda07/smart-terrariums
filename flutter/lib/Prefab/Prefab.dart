import 'package:cloud_firestore/cloud_firestore.dart';

class Prefab {
  final String name;
  final double minTemperature;
  final double maxTemperature;
  final double minHumidity;
  final double maxHumidity;
  final int minLightHours;
  final int maxLightHours;
  final int minHeaterHours;
  final int maxHeaterHours;
  final int minFeedingHours;
  final int maxFeedingHours;

  Prefab({
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

  // Method to add a new Prefab document to Firestore
  Future<void> addPrefabToFirestore() async {
    try {
      // Reference to the prefabs collection
      CollectionReference prefabs = FirebaseFirestore.instance.collection('prefabs');

      // Add the Prefab data to Firestore
      await prefabs.add({
        'name': name,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature,
        'minHumidity': minHumidity,
        'maxHumidity': maxHumidity,
        'minLightHours': minLightHours,
        'maxLightHours': maxLightHours,
        'minHeaterHours': minHeaterHours,
        'maxHeaterHours': maxHeaterHours,
        'minFeedingHours': minFeedingHours,
        'maxFeedingHours': maxFeedingHours,
      });
    } catch (e) {
      print('Error adding prefab to Firestore: $e');
    }
  }
}
