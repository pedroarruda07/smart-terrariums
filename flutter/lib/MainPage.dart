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

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      TerrariumsListPage(userRoles: widget.userRoles,),
      PrefabsPage(),
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
