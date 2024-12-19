import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/admin/admin_home.dart';
import 'package:hackathon/firebase_options.dart';
import 'package:hackathon/screens/donate.dart';
import 'package:hackathon/screens/home_screen.dart';
import 'package:hackathon/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReliefLink',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
