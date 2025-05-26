import 'package:flutter/material.dart';
import 'package:parking_system/screens/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home:OtpScreen()
    );
  }
}
