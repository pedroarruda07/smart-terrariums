import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Prefab/Prefab.dart';
import 'Terrarium.dart';

class AddTerrariumDialog extends StatefulWidget {
  final Terrarium? terrarium;
  final List<String> userRoles;

  const AddTerrariumDialog({Key? key, this.terrarium, required this.userRoles}) : super(key: key);

  @override
  _AddTerrariumDialogState createState() => _AddTerrariumDialogState();
}

class _AddTerrariumDialogState extends State<AddTerrariumDialog> {
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

  String? selectedRole;
  Prefab? selectedPrefab;
  List<Prefab> prefabs = [];
  final dbRef = FirebaseDatabase.instance.ref('Terrariums');

  @override
  void initState() {
    super.initState();
    getPrefabsStream();
  }

  void getPrefabsStream() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Prefabs');
    ref.onValue.listen((event) {
      List<Prefab> loadedPrefabs = [];

      event.snapshot.children.forEach((child) {
        Prefab prefab = Prefab.fromSnapshot(child);
        loadedPrefabs.add(prefab);
      });

      setState(() {
        prefabs = loadedPrefabs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Terrarium', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Name'),
                  SizedBox(height: 10),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      hint: Text('Select Category'),
                      items: widget.userRoles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedRole = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Role is required' : null,
                      decoration: InputDecoration.collapsed(hintText: ''),
                    ),
                  ),
                  SizedBox(height: 10),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    child: DropdownButtonFormField<Prefab>(
                      value: selectedPrefab,
                      hint: Text('Prefab'),
                      items: [
                        DropdownMenuItem<Prefab>(
                          child: Text('Select Prefab'),
                        ),
                        ...prefabs.map((Prefab prefab) {
                          return DropdownMenuItem<Prefab>(
                            value: prefab,
                            child: Text(prefab.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedPrefab = newValue;
                          if (selectedPrefab != null) {
                            minTemperatureController.text = selectedPrefab!.minTemperature.toString();
                            maxTemperatureController.text = selectedPrefab!.maxTemperature.toString();
                            minHumidityController.text = selectedPrefab!.minHumidity.toString();
                            maxHumidityController.text = selectedPrefab!.maxHumidity.toString();
                            minLightHoursController.text = selectedPrefab!.minLightHours.toString();
                            maxLightHoursController.text = selectedPrefab!.maxLightHours.toString();
                            minHeaterHoursController.text = selectedPrefab!.minHeaterHours.toString();
                            maxHeaterHoursController.text = selectedPrefab!.maxHeaterHours.toString();
                            minFeedingHoursController.text = selectedPrefab!.minFeedingHours.toString();
                            maxFeedingHoursController.text = selectedPrefab!.maxFeedingHours.toString();
                          } else {
                            minTemperatureController.clear();
                            maxTemperatureController.clear();
                            minHumidityController.clear();
                            maxHumidityController.clear();
                            minLightHoursController.clear();
                            maxLightHoursController.clear();
                            minHeaterHoursController.clear();
                            maxHeaterHoursController.clear();
                            minFeedingHoursController.clear();
                            maxFeedingHoursController.clear();
                          }
                        });
                      },
                      validator: (value) => value == null ? 'Prefab is required' : null,
                      decoration: InputDecoration.collapsed(hintText: ''),
                    ),
                  ),
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
                          _buildTextField(minLightHoursController, 'On', keyboardType: TextInputType.number),
                          _buildTextField(maxLightHoursController, 'Off', keyboardType: TextInputType.number),
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
                          _buildTextField(minHeaterHoursController, 'On', keyboardType: TextInputType.number),
                          _buildTextField(maxHeaterHoursController, 'Off', keyboardType: TextInputType.number),
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
                          _buildTextField(minFeedingHoursController, 'Feed 1', keyboardType: TextInputType.number),
                          _buildTextField(maxFeedingHoursController, 'Feed 2', keyboardType: TextInputType.number),
                        ]),
                      ],
                    ),
                  ]),
                  SizedBox(height: 10),
                ],
              ),
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
            if (_formKey.currentState?.validate() ?? false) {
              // Validate and save form data
              final newTerrarium = Terrarium(
                  key: nameController.text,
                  name: nameController.text,
                  foodLevel: 0,
                  waterLevel: 0,
                  temperature: 0.0,
                  humidity: 0.0,
                  ledStatus: "OFF",
                  heaterStatus: "OFF",
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
                  activity: {},
                  category: selectedRole ?? ''
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
                'maxHeater': newTerrarium.maxHeaterHours,
                'minHeater': newTerrarium.minHeaterHours,
                'maxFeeding': newTerrarium.maxFeedingHours,
                'minFeeding': newTerrarium.minFeedingHours,
                'activity': newTerrarium.activity,
                'category': newTerrarium.category,
                'manualOverride': false,
              });

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
