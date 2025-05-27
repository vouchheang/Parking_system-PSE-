import 'package:flutter/material.dart';
import 'package:parking_system/screens/intro_screen.dart';
import 'package:parking_system/screens/navigation.dart';
import 'package:parking_system/screens/register._creen.dart';
import 'package:provider/provider.dart';
import 'package:parking_system/controllers/login_controller.dart';
import 'package:parking_system/services/api_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(ApiService()),
        ),
        // Add other providers here
      ],
      child: MaterialApp(
        title: 'Parking System',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home:ParkingRegistrationScreen()
    );
  }
}
