import 'package:flutter/material.dart';
import 'package:parking_system/screens/afterscan_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home:AfterscanScreen(activityId: '1b6e506e-47a0-4e0b-8b6f-171d57ce636b',)
    );
  }
}
