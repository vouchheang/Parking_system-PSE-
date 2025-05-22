import 'package:flutter/material.dart';
import 'package:parking_system/screens/navigation.dart';
import 'package:parking_system/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: ProfileScreen('ab270d68-3dda-48f7-b9a2-cd2ade9f342d'),
    );
  }
}
