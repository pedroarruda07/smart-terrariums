// PrefabCard.dart
import 'package:flutter/material.dart';
import 'PrefabTerrarium.dart';

class PrefabCard extends StatelessWidget {
  final PrefabTerrarium prefab;

  const PrefabCard({Key? key, required this.prefab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text(prefab.name),
        subtitle: Text(
          'Temp: ${prefab.minTemperature}°C - ${prefab.maxTemperature}°C\n'
              'Humidity: ${prefab.minHumidity}% - ${prefab.maxHumidity}%\n'
              'Light: ${prefab.minLightHours}h - ${prefab.maxLightHours}h\n'
              'Heater: ${prefab.minHeaterHours}h - ${prefab.maxHeaterHours}h\n'
              'Feeding: ${prefab.minFeedingHours}h - ${prefab.maxFeedingHours}h',
        ),
        trailing: Icon(Icons.add, color: Colors.green),
        onTap: () {
          // Handle onTap action if needed
        },
      ),
    );
  }
}
