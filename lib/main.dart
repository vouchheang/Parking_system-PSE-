import 'package:flutter/material.dart';
import 'package:parking_system/screens/afterscan_screen.dart';
import 'package:parking_system/screens/camera_screen.dart';
import 'package:parking_system/screens/home_screen.dart';
import 'package:parking_system/screens/intro_screen.dart';
import 'package:parking_system/screens/navigation.dart';
import 'package:parking_system/screens/profile_screen.dart';
import 'package:parking_system/screens/register._creen.dart';
import 'package:parking_system/screens/select_screen.dart';
import 'package:parking_system/screens/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home:ProfileScreen('')
    );
  }
}