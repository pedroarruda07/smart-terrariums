import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Terrarium.dart';
import 'TerrariumPage.dart';
import 'EditTerrariumDialog.dart';

class TerrariumCard extends StatelessWidget {
  final Terrarium terrarium;

  const TerrariumCard({Key? key, required this.terrarium}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _deleteTerrarium(BuildContext context) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      dbRef.child('Terrariums').child(terrarium.key).remove().then((_) {
        // Successful deletion, you can perform any UI updates or other actions here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terrarium deleted successfully')),
        );
      }).catchError((error) {
        // Error occurred while deleting
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete terrarium: $error')),
        );
      });
    }

    void _showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Terrarium'),
            content: Text('Are you sure you want to delete this terrarium?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the confirmation dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteTerrarium(context);
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
      ),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(terrarium.name + "      - " + terrarium.category),
        subtitle: Text('Temperature: ${terrarium.minTemperature}°C | Humidity: ${terrarium.humidity}%'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context)
                    {
                      return EditTerrariumDialog(terrarium: terrarium);
                    });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TerrariumPage(terrarium: terrarium)),
          );
        },
      ),
    );
  }
}
