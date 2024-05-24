// PrefabsPage.dart
import 'package:flutter/material.dart';
import 'PrefabTerrarium.dart';
import 'PrefabCard.dart';

class PrefabsPage extends StatelessWidget {
  final List<PrefabTerrarium> prefabs;

  const PrefabsPage({Key? key, required this.prefabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prefabs'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: prefabs.length,
        itemBuilder: (context, index) {
          final prefab = prefabs[index];
          return PrefabCard(prefab: prefab);
        },
      ),
    );
  }
}
