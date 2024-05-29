import 'package:flutter/material.dart';
import 'PrefabTerrarium.dart';

class AddPrefabDialog extends StatefulWidget {
  @override
  _AddPrefabDialogState createState() => _AddPrefabDialogState();
}

class _AddPrefabDialogState extends State<AddPrefabDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController minTemperatureController = TextEditingController();
  final TextEditingController maxTemperatureController = TextEditingController();
  final TextEditingController minHumidityController = TextEditingController();
  final TextEditingController maxHumidityController = TextEditingController();
  final TextEditingController minLightHoursController = TextEditingController();
  final TextEditingController maxLightHoursController = TextEditingController();
  final TextEditingController minHeaterHoursController = TextEditingController();
  final TextEditingController maxHeaterHoursController = TextEditingController();
  final TextEditingController minFeedingHoursController = TextEditingController();
  final TextEditingController maxFeedingHoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Prefab', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                SizedBox(height: 10),
                _buildRow([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temperature', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      _buildRow([
                        _buildTextField(minTemperatureController, 'Min', keyboardType: TextInputType.number),
                        _buildTextField(maxTemperatureController, 'Max', keyboardType: TextInputType.number),
                      ]),
                    ],
                  ),
                ]),
                _buildRow([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Humidity', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      _buildRow([
                        _buildTextField(minHumidityController, 'Min', keyboardType: TextInputType.number),
                        _buildTextField(maxHumidityController, 'Max', keyboardType: TextInputType.number),
                      ]),
                    ],
                  ),
                ]),
                _buildRow([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Light Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      _buildRow([
                        _buildTextField(minLightHoursController, 'Min', keyboardType: TextInputType.number),
                        _buildTextField(maxLightHoursController, 'Max', keyboardType: TextInputType.number),
                      ]),
                    ],
                  ),
                ]),
                _buildRow([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Heater Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      _buildRow([
                        _buildTextField(minHeaterHoursController, 'Min', keyboardType: TextInputType.number),
                        _buildTextField(maxHeaterHoursController, 'Max', keyboardType: TextInputType.number),
                      ]),
                    ],
                  ),
                ]),
                _buildRow([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Feeding Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      _buildRow([
                        _buildTextField(minFeedingHoursController, 'Min', keyboardType: TextInputType.number),
                        _buildTextField(maxFeedingHoursController, 'Max', keyboardType: TextInputType.number),
                      ]),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Validate and save form data
              final newPrefab = PrefabTerrarium(
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

              // TODO: Handle saving the new prefab
              // You can add your Firebase database logic here

              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children.map((child) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: child,
      ))).toList(),
    );
  }
}
