import 'package:flutter/material.dart';
import 'graph_widget.dart'; // Make sure to import your graph widget here

class ActivityGraph extends StatefulWidget {
  final Map<dynamic, dynamic> graphData;

  const ActivityGraph({Key? key, required this.graphData}) : super(key: key);

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

class _ActivityGraphState extends State<ActivityGraph> {
  bool _isGraphVisible = true;

  void _toggleGraphVisibility() {
    setState(() {
      _isGraphVisible = !_isGraphVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleGraphVisibility,
          child: Row(
            children: [
              SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
              Text(
                "ACTIVITY",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              Icon(
                _isGraphVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.grey[700],
              ),
            ],
          ),
        ),
        if (_isGraphVisible)
          LineChartSample5(
            graphData: widget.graphData,
          ),
      ],
    );
  }
}
