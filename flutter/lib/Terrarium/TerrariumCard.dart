import 'package:flutter/material.dart';
import 'Terrarium.dart';
import 'TerrariumPage.dart';

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
        contentPadding: const EdgeInsets.all(8),
        title: Text(terrarium.name),
        subtitle: Text('Temperature: ${terrarium.temperature}°C | Humidity: ${terrarium.humidity}%'),
        trailing: const Icon(Icons.panorama_fish_eye, color: Colors.pink),
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
