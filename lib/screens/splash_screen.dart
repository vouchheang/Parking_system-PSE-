import 'package:flutter/material.dart';
import 'package:parking_system/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Color(0xFF116692);
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.contain,
              ),

              // ),
            ),
          ],
        ),
      ),
    );
  }
}
