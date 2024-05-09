import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scmu_app/AddTerrariumDialog.dart';
import 'TerrariumPage.dart';
import 'TerrariumPageFirebase.dart';
import 'terrarium.dart';

class TerrariumsListPage extends StatefulWidget {
  const TerrariumsListPage({Key? key}) : super(key: key);

  @override
  _TerrariumsListPageState createState() => _TerrariumsListPageState();
}

class _TerrariumsListPageState extends State<TerrariumsListPage> {
  final databaseReference = FirebaseDatabase.instance.ref('Terrariums');
  final List<Terrarium> terrariums = [];

  @override
  void initState(){
    super.initState();


  }

  Stream<List<Terrarium>> getTerrariumsStream() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Terrariums');

    return ref.onValue.map((event) {
      List<Terrarium> terrariums = [];
      event.snapshot.children.forEach((child) {
        //print('Key: ${child.key}, Value: ${child.value}');
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
      ),
      body: StreamBuilder(
        stream: getTerrariumsStream(),
        builder: (context, AsyncSnapshot<List<Terrarium>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final terrariums = snapshot.data ?? [];
          return ListView.builder(
            itemCount: terrariums.length,
            itemBuilder: (context, index) {
              final terrarium = terrariums[index];
              return ListTile(
                title: Text(terrarium.name),
                subtitle: Text('Temperature: ${terrarium.minTemperature}°C - ${terrarium.maxTemperature}°C | Humidity: ${terrarium.minHumidity}% - ${terrarium.maxHumidity}%'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TerrariumPageFirebase()), // Ensure TerrariumPageFirebase can receive a terrarium object
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTerrariumDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTerrariumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTerrariumDialog(
          onTerrariumAdded: (newTerrarium) {
            setState(() {
              terrariums.add(newTerrarium);
            });
          },
        );
      },
    );
  }
}
