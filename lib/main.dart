import 'dart:async';
import 'package:bwstory/record-video/add_data.dart';
import 'package:bwstory/record-video/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'authentication/phone.dart';
import 'authentication/verify.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "bwstory",
      options: const FirebaseOptions(
          apiKey: "AIzaSyDOcl0yfMuE30l_kFCCLZKG5mtaWDoWMBM",
          authDomain: "bwstory.firebaseapp.com",
          projectId: "bwstory",
          storageBucket: "bwstory.appspot.com",
          messagingSenderId: "100332376572",
          appId: "1:100332376572:web:6ce633152a17d91ee02279",
          measurementId: "G-T1V8CV3XMY"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// check if user is signed (Open Chat page ) if user is not signed in (open welcome page)
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? 'phone' : 'home',

      ///key value pair
      routes: {
        'phone': (context) => const MyPhone(),
        'verify': (context) => const MyVerify(),
        'home': (context) => const Home(),
        'record': (context) => const CameraPage(),
      },
      home: const MyPhone(),
    );
  }
}
