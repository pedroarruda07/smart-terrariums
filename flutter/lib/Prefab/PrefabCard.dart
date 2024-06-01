import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Prefab.dart';

class PrefabCard extends StatelessWidget {
  final Prefab prefab;

  const PrefabCard({Key? key, required this.prefab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                _showChangeNameDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                _deletePrefab(prefab.key);
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
          title: Text('Change Prefab Name'),
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
                String newName = nameController.text;
                _updatePrefabName(prefab.key, newName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePrefabName(String id, String newName) {
    final dbRef = FirebaseFirestore.instance.collection('prefabs');
    dbRef.doc(id).update({
      'name': newName,
    });
  }

  void _deletePrefab(String id) {
    final dbRef = FirebaseFirestore.instance.collection('prefabs');
    dbRef.doc(id).delete();
  }
}
