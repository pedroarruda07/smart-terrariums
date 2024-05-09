import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'terrarium.dart';

class AddTerrariumDialog extends StatefulWidget {
  final Function(Terrarium) onTerrariumAdded;

  const AddTerrariumDialog({Key? key, required this.onTerrariumAdded}) : super(key: key);

  @override
  _AddTerrariumDialogState createState() => _AddTerrariumDialogState();
}

class _AddTerrariumDialogState extends State<AddTerrariumDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController minTemperatureController = TextEditingController();
  TextEditingController maxTemperatureController = TextEditingController();
  TextEditingController minHumidityController = TextEditingController();
  TextEditingController maxHumidityController = TextEditingController();
  TextEditingController minLightHoursController = TextEditingController();
  TextEditingController maxLightHoursController = TextEditingController();
  TextEditingController minHeaterHoursController = TextEditingController();
  TextEditingController maxHeaterHoursController = TextEditingController();
  TextEditingController minFeedingHoursController = TextEditingController();
  TextEditingController maxFeedingHoursController = TextEditingController();

  final dbRef = FirebaseDatabase.instance.ref('Terrariums');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Terrarium'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minTemperatureController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Temperature'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: maxTemperatureController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Temperature'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minHumidityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Humidity'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: maxHumidityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Humidity'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minLightHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Light Hours'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: maxLightHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Light Hours'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minHeaterHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Heater Hours'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: maxHeaterHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Heater Hours'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minFeedingHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Feeding Hours'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: maxFeedingHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Feeding Hours'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Validate and save form data
            final newTerrarium = Terrarium(
              key: nameController.text+'1',
              name: nameController.text,
              minTemperature: double.parse(minTemperatureController.text),
              maxTemperature: double.parse(maxTemperatureController.text),
              minHumidity: double.parse(minHumidityController.text),
              maxHumidity: double.parse(maxHumidityController.text),
              minLightHours: int.parse(minLightHoursController.text),
              maxLightHours: int.parse(maxLightHoursController.text),
              minHeaterHours: int.parse(minHeaterHoursController.text),
              maxHeaterHours: int.parse(maxHeaterHoursController.text),
              minFeedingHours: int.parse(minFeedingHoursController.text),
              maxFeedingHours: int.parse(maxFeedingHoursController.text),
            );
            dbRef.push().set({
              'name': newTerrarium.name,
               'minTemp': newTerrarium.minTemperature,
               'maxTemp': newTerrarium.maxTemperature,
               'minHumidity': newTerrarium.minHumidity,
               'maxHumidity': newTerrarium.maxHumidity,
               'minLight': newTerrarium.minLightHours,
               'maxLight': newTerrarium.maxLightHours

            });
            widget.onTerrariumAdded(newTerrarium);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
