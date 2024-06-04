import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final List<String> userRoles;
  final String username;
  const ProfilePage({Key? key, required this.userRoles, required this.username})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 130),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 50),
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 15,
                    color: Colors.green,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 15,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 50),
                  const Text(
                    'Roles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.userRoles.join(', '),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 15,
                    color: Colors.green,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 15,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}