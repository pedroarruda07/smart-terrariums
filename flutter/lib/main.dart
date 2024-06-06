import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'LoginPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /* FirebaseMessaging messaging = FirebaseMessaging.instance; only works for android(?)
  await messaging.subscribeToTopic("temperature")
      .then((value) => print("Inscrito no tópico 'temperature'"))
      .catchError((error) => print("Falha na inscrição: $error"));

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Recebeu uma mensagem enquanto estava em primeiro plano!');
    if (message.notification != null) {
      print('Título: ${message.notification?.title}');
      print('Corpo: ${message.notification?.body}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Uma nova mensagem foi aberta!');
    if (message.notification != null) {
      print('Título: ${message.notification?.title}');
      print('Corpo: ${message.notification?.body}');
    }
  });*/


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terrarium App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}




