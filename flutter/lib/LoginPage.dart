import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.ref('Users');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  List<String> splitStringByComma(String input) {
    return input.split(',').map((s) => s.trim()).toList();
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      DatabaseEvent event = await databaseReference.child(username).once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null && data['password'] == password) {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          await messaging.subscribeToTopic("temperature")
              .then((value) => print("Inscrito no tópico 'temperature'"))
              .catchError((error) => print("Falha na inscrição: $error"));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage(userRoles: splitStringByComma(data['roles']), username: username)),
          );
        } else {
          _showErrorDialog('Invalid username or password.');
        }
      } else {
        _showErrorDialog('Invalid username or password.');
      }
    } catch (error) {
      _showErrorDialog('An error occurred while trying to log in. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.green.shade900,
      ),
    );
  }

  Widget _buildForegroundText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lizzard.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 25),
                      Image.asset(
                        'assets/leaf.png',
                        width: 80,
                        height: 80,
                      ),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: -145 + width * 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildOutlinedText('Login'),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildForegroundText('Login'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: -150 + width * 0.5),
                        child: SizedBox(
                          height: 60, // Set the height for the text field
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Username',
                            ),
                            controller: _usernameController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: -150 + width * 0.5),
                        child: SizedBox(
                          height: 60, // Set the height for the text field
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Password',
                            ),
                            controller: _passwordController,
                            obscureText: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(

                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(color: Colors.grey.shade600),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(275, 45)), // Set smaller height for the button
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
                        onPressed: _login,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
