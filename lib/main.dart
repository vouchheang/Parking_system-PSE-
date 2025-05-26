import 'package:flutter/material.dart';
import 'package:parking_system/screens/dashboard_screen.dart';
import 'package:parking_system/screens/register._creen.dart';
import 'package:parking_system/screens/login_screen.dart';
import 'package:parking_system/screens/scan_screen.dart';
import 'package:parking_system/screens/securities_team.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home:  ParkingRegistrationScreen(),
    );
  }
}
