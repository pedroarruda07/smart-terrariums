import 'package:flutter/material.dart';
import 'PrefabTerrarium.dart';

class PrefabSelectionPage extends StatelessWidget {
  final List<PrefabTerrarium> prefabs; // Define the list of prefabs

  PrefabSelectionPage({Key? key, required this.prefabs}) : super(key: key); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Prefab Terrarium'),
      ),
      body: ListView.builder(
        itemCount: prefabs.length,
        itemBuilder: (context, index) {
          final prefab = prefabs[index];
          return ListTile(
            title: Text(prefab.name),
            onTap: () {
              Navigator.of(context).pop(prefab);
            },
          );
        },
      ),
    );
  }
}
