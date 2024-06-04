import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'AddTerrariumDialog.dart';
import 'TerrariumCard.dart';
import 'Terrarium.dart';

class TerrariumsListPage extends StatefulWidget {
  final List<String> userRoles;
  const TerrariumsListPage({Key? key, required this.userRoles})
      : super(key: key);

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
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('Terrariums');
    return ref.onValue.map((event) {
      List<Terrarium> terrariums = [];

      event.snapshot.children.forEach((child) {
        Terrarium terrarium = Terrarium.fromSnapshot(child);
        if (terrarium.hasAccess(widget.userRoles)) {
          terrariums.add(terrarium);
        }
      });
      return terrariums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terrariums',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Image.asset(
          'assets/green.jpg',
          fit: BoxFit.cover,
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/leafbg.png',
            fit: BoxFit.cover,
          ),
          StreamBuilder<List<Terrarium>>(
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
        ],
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
          userRoles: widget.userRoles,
        );
      },
    );
  }
}
