import 'package:flutter/material.dart';
import 'package:scmu_app/Prefab/AddPrefabDialog.dart';
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: prefabs.length,
              itemBuilder: (context, index) {
                final prefab = prefabs[index];
                return PrefabCard(prefab: prefab);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                _showAddPrefabDialog(context);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPrefabDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPrefabDialog();
      },
    );
  }
}
