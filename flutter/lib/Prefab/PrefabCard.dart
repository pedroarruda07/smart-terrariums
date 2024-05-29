import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Terrarium/Terrarium.dart';
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

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showChangeNameDialog(context); //change to be able to edit everything, not just name
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Handle delete action
              },
            ),
          ],
        ),
        onTap: () {
          // Handle onTap action if needed
        },
      ),
    );
  }


  Future<void> _showChangeNameDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Terrarium Name'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'New Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                // Save the new name here
                String newName = nameController.text;
                // Post the new terrarium to Firebase
                _postNewTerrarium(newName, prefab);
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _postNewTerrarium(String newName, PrefabTerrarium prefab) {
    final dbRef = FirebaseDatabase.instance.ref('Terrariums');

    final newTerrarium = Terrarium(
      key: newName, // Assuming the name is used as the key
      name: newName,
      foodLevel: 0,
      waterLevel: 0,
      temperature: 0.0,
      humidity: 0.0,
      ledStatus: "OFF",
      heaterStatus: "OFF",
      minTemperature: prefab.minTemperature,
      maxTemperature: prefab.maxTemperature,
      minHumidity: prefab.minHumidity,
      maxHumidity: prefab.maxHumidity,
      minLightHours: prefab.minLightHours,
      maxLightHours: prefab.maxLightHours,
      minHeaterHours: prefab.minHeaterHours,
      maxHeaterHours: prefab.maxHeaterHours,
      minFeedingHours: prefab.minFeedingHours,
      maxFeedingHours: prefab.maxFeedingHours,
      activity: {},
      category: ''
    );

    dbRef.push().set({
      'foodLevel': newTerrarium.foodLevel,
      'heaterStatus': newTerrarium.heaterStatus,
      'humidity': newTerrarium.humidity,
      'ledStatus': newTerrarium.ledStatus,
      'temperature': newTerrarium.temperature,
      'waterLevel': newTerrarium.waterLevel,
      'name': newTerrarium.name,
      'minTemp': newTerrarium.minTemperature,
      'maxTemp': newTerrarium.maxTemperature,
      'minHumidity': newTerrarium.minHumidity,
      'maxHumidity': newTerrarium.maxHumidity,
      'minLight': newTerrarium.minLightHours,
      'maxLight': newTerrarium.maxLightHours,
      'activity': newTerrarium.activity,
      'category': newTerrarium.category
    });
  }


}
