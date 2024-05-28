import 'package:flutter/material.dart';
import 'Prefab/PrefabTerrarium.dart'; // Import your PrefabTerrarium class
import 'Prefab/PrefabsPage.dart'; // Import your PrefabsPage class
import 'Terrarium/TerrariumsListPage.dart'; // Import your TerrariumsListPage class

class MainPage extends StatefulWidget {
  final List<String> userRoles;

  const MainPage({Key? key, required this.userRoles}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Mock list of prefabs
  final List<PrefabTerrarium> mockPrefabs = [
    PrefabTerrarium(
      name: 'Prefab 1',
      minTemperature: 20.0,
      maxTemperature: 30.0,
      minHumidity: 50.0,
      maxHumidity: 70.0,
      minLightHours: 6,
      maxLightHours: 12,
      minHeaterHours: 2,
      maxHeaterHours: 4,
      minFeedingHours: 1,
      maxFeedingHours: 2,
    ),
    PrefabTerrarium(
      name: 'Prefab 2',
      minTemperature: 22.0,
      maxTemperature: 28.0,
      minHumidity: 55.0,
      maxHumidity: 65.0,
      minLightHours: 7,
      maxLightHours: 11,
      minHeaterHours: 3,
      maxHeaterHours: 5,
      minFeedingHours: 1,
      maxFeedingHours: 3,
    ),
    // Add more prefabs as needed
  ];

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      TerrariumsListPage(userRoles: widget.userRoles,),
      PrefabsPage(prefabs: mockPrefabs),
      Text('Profile Page'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Terrariums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Prefabs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
