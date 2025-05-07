import 'package:flutter/material.dart';
import 'package:parking_system/screens/dashboard_screen.dart';
import 'package:parking_system/screens/navigation.dart';
import 'package:parking_system/screens/security_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: MainScreen(),
    );
  }
}
