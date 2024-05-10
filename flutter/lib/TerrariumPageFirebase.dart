import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'Terrarium.dart';

class TerrariumPageFirebase extends StatefulWidget {
  final Terrarium terrarium;
  const TerrariumPageFirebase({Key? key, required this.terrarium}) : super(key: key);

  @override
  _TerrariumPageFirebaseState createState() => _TerrariumPageFirebaseState();
}

class _TerrariumPageFirebaseState extends State<TerrariumPageFirebase> {
  late DatabaseReference dbRef;
  bool lightStatus = false;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref("/Terrariums/${widget.terrarium.key}");
  }

  void toggleLed(String status) async {
    await dbRef.child("ledStatus").set(status);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('LED Controller'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Switch(
                // thumb color (round icon)
                activeColor: Colors.amber,
                activeTrackColor: Colors.cyan,
                inactiveThumbColor: Colors.blueGrey.shade600,
                inactiveTrackColor: Colors.grey.shade400,
                splashRadius: 50.0,
                // boolean variable value
                value: lightStatus,
                // changes the state of the switch
                onChanged: (value) => setState(()  {
                  lightStatus = value;
                  lightStatus ? toggleLed('ON') : toggleLed('OFF');
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
