import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scmu_app/Prefab/EditPrefabDialog.dart';
import 'Prefab.dart';
import 'PrefabsPage.dart';

class PrefabCard extends StatelessWidget {
  final Prefab prefab;

  const PrefabCard({Key? key, required this.prefab}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    void _deletePrefab(BuildContext context) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('Prefabs');
      dbRef.child(prefab.key).remove().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prefab deleted successfully')),
        );
      }).catchError((error) {
        // Error occurred while deleting
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete prefab: $error')),
        );
      });
    }


    void _showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Prefab'),
            content: Text('Are you sure you want to delete this prefab?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the confirmation dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _deletePrefab(context);
                  Navigator.of(context).pop(); // Close the confirmation dialog
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );
    }
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade700, width: 1),
      ),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      color: Colors.green.shade50,
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
              icon: Icon(Icons.edit, color: Colors.green.shade700),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPrefabDialog(prefab: prefab)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrefabsPage()),
          );
        },
      ),
    );
  }
  
}
