import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scmu_app/AddTerrariumDialog.dart';
import 'TerrariumPage.dart';
import 'TerrariumPageFirebase.dart';
import 'Terrarium.dart';

class TerrariumsListPage extends StatefulWidget {
  const TerrariumsListPage({Key? key}) : super(key: key);

  @override
  _TerrariumsListPageState createState() => _TerrariumsListPageState();
}

class _TerrariumsListPageState extends State<TerrariumsListPage> {
  final databaseReference = FirebaseDatabase.instance.ref('Terrariums');
  final List<Terrarium> terrariums = [];

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

class TerrariumCard extends StatelessWidget {
  final Terrarium terrarium;

  const TerrariumCard({Key? key, required this.terrarium}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text(terrarium.name),
        subtitle: Text('Temperature: ${terrarium.temperature}°C | Humidity: ${terrarium.humidity}%'),
        trailing: Icon(Icons.panorama_fish_eye, color: Colors.pink),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TerrariumPage(terrarium: terrarium)),
          );
        },
      ),
    );
  }
}
