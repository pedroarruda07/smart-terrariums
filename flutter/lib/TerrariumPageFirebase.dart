import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class TerrariumPageFirebase extends StatefulWidget {
  const TerrariumPageFirebase({Key? key}) : super(key: key);

  @override
  _TerrariumPageFirebaseState createState() => _TerrariumPageFirebaseState();
}

class _TerrariumPageFirebaseState extends State<TerrariumPageFirebase> {
  final dbRef = FirebaseDatabase.instance.ref('LEDStatus');
  bool lightStatus = false;

  void toggleLed(String status) async {
    await dbRef.set(status);
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
