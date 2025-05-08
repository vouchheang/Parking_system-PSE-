import 'package:flutter/material.dart';
import 'package:parking_system/screens/login_screen.dart';
import 'package:parking_system/screens/register._creen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _descriptionController = PageController();
  int _currentDescriptionPage = 0;

  final List<String> _descriptions = [
    'We created this app to make your vehicle experience easier, smarter, and more connected whether you\'re managing maintenance, exploring new roads, or just staying informed.',
    'Keep your vehicle in top shape with easy-to-use maintenance tracking and timely reminders for service appointments.',
    'Find the best routes, avoid traffic, and discover new places with our smart navigation features.',
    'Monitor your vehicle\'s performance, fuel efficiency, and get real-time diagnostics right from your phone.',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF116692);
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Image placeholder section
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/in.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Text content
              const Text(
                'Ready to upgrade your driving experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 80,
                child: PageView.builder(
                  controller: _descriptionController,
                  itemCount: _descriptions.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentDescriptionPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _descriptions[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _descriptions.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          index == _currentDescriptionPage
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParkingRegistrationScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Login text
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'already have account? Login',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
