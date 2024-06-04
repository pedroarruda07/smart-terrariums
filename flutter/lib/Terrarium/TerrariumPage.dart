import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'EditTerrariumDialog.dart';
import 'Terrarium.dart';
import '../activity_graph_widget.dart';

class TerrariumPage extends StatefulWidget {
  final Terrarium terrarium;
  const TerrariumPage({Key? key, required this.terrarium}) : super(key: key);

  @override
  _TerrariumPageState createState() => _TerrariumPageState();
}

class _TerrariumPageState extends State<TerrariumPage> {
  final String espUrl = 'http://192.168.1.129'; // Replace with actual ESP32 IP address
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef =
        FirebaseDatabase.instance.ref("/Terrariums/${widget.terrarium.key}");
  }

  Future<void> toggleLed(String led, String command) async {
    var url = Uri.parse('$espUrl/$led/$command');
    const timeoutDuration = Duration(seconds: 2);

    try {
      final response = await http.get(url).timeout(timeoutDuration);

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Failed to execute LED command. Status code: ${response
            .statusCode}');
        await dbRef.child("${led}Status").set(command);
      }
    } catch (e) {
      if (e is TimeoutException) {
        print('Request to ESP32 timed out.');
      } else {
        print('Error executing LED command: $e');
      }
      await dbRef.child("${led}Status").set(command);
    }
  }

  Stream<Terrarium> getTerrarium() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child(
        'Terrariums').child(widget.terrarium.key);
    return ref.onValue.map((event) {
      return Terrarium.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terrarium ' + widget.terrarium.name,
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Image.asset(
          'assets/green.jpg',
          fit: BoxFit.cover,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditTerrariumDialog(terrarium: widget.terrarium);
                },
              );
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/leafbg2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Foreground content
          SingleChildScrollView(
            child: StreamBuilder<Terrarium>(
              stream: getTerrarium(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
                }

                final terrarium = snapshot.data!;

                return Padding(
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
                              child: Icon(Icons.image, size: 50,
                                  color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatusCard(
                                    'TEMPERATURE', terrarium.temperature),
                                _buildStatusCard(
                                    'HUMIDITY', terrarium.humidity),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSwitch('LIGHT  ', terrarium.ledStatus == 'ON', 'led'),
                      _buildSwitch(
                          'HEATER', terrarium.heaterStatus == 'ON', 'heater'),
                      const SizedBox(height: 32),
                      _buildIndicator('WATER LEVEL', terrarium.waterLevel),
                      _buildIndicator('FOOD LEVEL  ', terrarium.foodLevel),
                      const SizedBox(height: 32),
                      ActivityGraph(graphData: terrarium.activity),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, double value) {
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
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch(String title, bool value, String led) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: MediaQuery
              .of(context)
              .size
              .width * 0.15),
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
            onChanged: (bool newValue) {
              toggleLed(led, newValue ? 'ON' : 'OFF');
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(String title, double level) {
    String status;
    Color color;
    if (level <= 100) {
      status = 'LOW';
      color = Colors.red;
    } else if (level > 100 && level <= 500) {
      status = 'MEDIUM';
      color = Colors.yellow;
    } else {
      status = 'HIGH';
      color = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: MediaQuery
              .of(context)
              .size
              .width * 0.15),
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
