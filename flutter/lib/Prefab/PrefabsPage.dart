import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'AddPrefabDialog.dart';
import 'PrefabCard.dart';
import 'Prefab.dart';

class PrefabsPage extends StatefulWidget {
  @override
  _PrefabsPageState createState() => _PrefabsPageState();
}

class _PrefabsPageState extends State<PrefabsPage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref('Prefabs');

  @override
  void initState() {
    super.initState();
  }

  Stream<List<Prefab>> getPrefabsStream() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Prefabs');
    return ref.onValue.map((event) {
      List<Prefab> prefabs = [];

      event.snapshot.children.forEach((child) {
        Prefab prefab = Prefab.fromSnapshot(child);
        prefabs.add(prefab);
      });
      return prefabs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prefabs',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Image.asset(
          'assets/green.jpg',
          fit: BoxFit.cover,
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true, // Extend background to the app bar
      body:  Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/leafbg.png',
            fit: BoxFit.cover,
          ),
          StreamBuilder<List<Prefab>>(
            stream: getPrefabsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final prefabs = snapshot.data ?? [];
              return ListView.builder(
                itemCount: prefabs.length,
                itemBuilder: (context, index) {
                  Prefab prefab = prefabs[index];
                  return PrefabCard(prefab: prefab);
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPrefabDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
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
