import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Terrarium.dart';

class TerrariumPage extends StatefulWidget {
  final Terrarium terrarium;
  const TerrariumPage({Key? key, required this.terrarium}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Terrarium ' + widget.terrarium.name),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusCard('TEMPERATURE', '31°C'),
                      _buildStatusCard('HUMIDITY', '43%'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSwitch('LIGHT 1', false),
            _buildSwitch('LIGHT 2', true),
            _buildSwitch('HEATER', true),
            const SizedBox(height: 32),
            _buildIndicator('WATER LEVEL', 'OK', Colors.green),
            _buildIndicator('FOOD LEVEL', 'LOW', Colors.red),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(Size(275, 60)),
                backgroundColor: MaterialStateProperty.all(Colors.green.shade300),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.green.shade200;
                    }
                    return Colors.green.shade300;
                  },
                ),
              ),
              onPressed:(){},
              child: const Text(
                'Edit Terrarium',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black, // Set text color to black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 40),
          Switch(
            value: value,
            onChanged: (bool newValue) {},
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 40),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
