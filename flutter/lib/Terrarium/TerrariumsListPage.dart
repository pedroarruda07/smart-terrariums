import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'AddTerrariumDialog.dart';
import 'TerrariumCard.dart';
import 'Terrarium.dart';

class TerrariumsListPage extends StatefulWidget {
  const TerrariumsListPage({Key? key}) : super(key: key);

  @override
  _TerrariumsListPageState createState() => _TerrariumsListPageState();
}

class _TerrariumsListPageState extends State<TerrariumsListPage> {
  final databaseReference = FirebaseDatabase.instance.ref('Terrariums');

  @override
  void initState() {
    super.initState();
  }

  Stream<List<Terrarium>> getTerrariumsStream() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Terrariums');
    return ref.onValue.map((event) {
      List<Terrarium> terrariums = [];

      event.snapshot.children.forEach((child) {
        terrariums.add(Terrarium.fromSnapshot(child));
      });
      return terrariums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terrariums'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Terrarium>>(
        stream: getTerrariumsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final terrariums = snapshot.data ?? [];
          return ListView.builder(
            itemCount: terrariums.length,
            itemBuilder: (context, index) {
              Terrarium terrarium = terrariums[index];
              return TerrariumCard(terrarium: terrarium);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTerrariumDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddTerrariumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddTerrariumDialog();
      },
    );
  }
}
