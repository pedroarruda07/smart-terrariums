import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TerrariumPage extends StatefulWidget {
  const TerrariumPage({Key? key}) : super(key: key);

  @override
  _TerrariumPageState createState() => _TerrariumPageState();
}

class _TerrariumPageState extends State<TerrariumPage> {

  bool lightStatus = false;
  final String espUrl = 'http://192.168.1.129'; // Replace with actual ESP32 IP address

  void toggleLed(String command) async {
    var url = Uri.parse('$espUrl/led/$command');
    await http.get(url);
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
                  lightStatus ? toggleLed('on') : toggleLed('off');
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
