import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Prefab.dart';

class EditPrefabDialog extends StatefulWidget {
  final Prefab? prefab;

  const EditPrefabDialog({Key? key, this.prefab}) : super(key: key);

  @override
  _EditPrefabDialogState createState() => _EditPrefabDialogState();
}

class _EditPrefabDialogState extends State<EditPrefabDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController minTemperatureController =
      TextEditingController();
  final TextEditingController maxTemperatureController =
      TextEditingController();
  final TextEditingController minHumidityController = TextEditingController();
  final TextEditingController maxHumidityController = TextEditingController();
  final TextEditingController minLightHoursController = TextEditingController();
  final TextEditingController maxLightHoursController = TextEditingController();
  final TextEditingController minHeaterHoursController =
      TextEditingController();
  final TextEditingController maxHeaterHoursController =
      TextEditingController();
  final TextEditingController minFeedingHoursController =
      TextEditingController();
  final TextEditingController maxFeedingHoursController =
      TextEditingController();

  final dbRef = FirebaseDatabase.instance.ref('Prefabs');

  @override
  void initState() {
    super.initState();
    if (widget.prefab != null) {
      final prefab = widget.prefab!;
      nameController.text = prefab.name;
      minTemperatureController.text = prefab.minTemperature.toString();
      maxTemperatureController.text = prefab.maxTemperature.toString();
      minHumidityController.text = prefab.minHumidity.toString();
      maxHumidityController.text = prefab.maxHumidity.toString();
      minLightHoursController.text = prefab.minLightHours.toString();
      maxLightHoursController.text = prefab.maxLightHours.toString();
      minHeaterHoursController.text = prefab.minHeaterHours.toString();
      maxHeaterHoursController.text = prefab.maxHeaterHours.toString();
      minFeedingHoursController.text = prefab.minFeedingHours.toString();
      maxFeedingHoursController.text = prefab.maxFeedingHours.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Prefab', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Container(
          width: 400,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Name'),
                  SizedBox(height: 10),
                  _buildRow([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Temperature',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        _buildRow([
                          _buildTextField(minTemperatureController, 'Min',
                              keyboardType: TextInputType.number),
                          _buildTextField(maxTemperatureController, 'Max',
                              keyboardType: TextInputType.number),
                        ]),
                      ],
                    ),
                  ]),
                  _buildRow([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Humidity',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        _buildRow([
                          _buildTextField(minHumidityController, 'Min',
                              keyboardType: TextInputType.number),
                          _buildTextField(maxHumidityController, 'Max',
                              keyboardType: TextInputType.number),
                        ]),
                      ],
                    ),
                  ]),
                  _buildRow([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Light Hours',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        _buildRow([
                          _buildTextField(minLightHoursController, 'On',
                              keyboardType: TextInputType.number),
                          _buildTextField(maxLightHoursController, 'Off',
                              keyboardType: TextInputType.number),
                        ]),
                      ],
                    ),
                  ]),
                  _buildRow([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Heater Hours',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        _buildRow([
                          _buildTextField(minHeaterHoursController, 'On',
                              keyboardType: TextInputType.number),
                          _buildTextField(maxHeaterHoursController, 'Off',
                              keyboardType: TextInputType.number),
                        ]),
                      ],
                    ),
                  ]),
                  _buildRow([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Feeding Hours',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        _buildRow([
                          _buildTextField(minFeedingHoursController, 'Feed 1',
                              keyboardType: TextInputType.number),
                          _buildTextField(maxFeedingHoursController, 'Feed 2',
                              keyboardType: TextInputType.number),
                        ]),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Validate and save form data
            final newPrefab = Prefab(
              key: widget.prefab!.key,
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

            dbRef.child(widget.prefab!.key).update({
              'name': newPrefab.name,
              'minTemp': newPrefab.minTemperature,
              'maxTemp': newPrefab.maxTemperature,
              'minHumidity': newPrefab.minHumidity,
              'maxHumidity': newPrefab.maxHumidity,
              'minLight': newPrefab.minLightHours,
              'maxLight': newPrefab.maxLightHours,
            });

            Navigator.of(context).pop();
          },
          child: Text('Edit'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children
          .map((child) => Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: child,
              )))
          .toList(),
    );
  }
}
