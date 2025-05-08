import 'package:flutter/material.dart';
import 'package:parking_system/screens/activities_screen.dart';
import 'package:parking_system/screens/dashboard_screen.dart';
import 'package:parking_system/screens/security_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  
  static final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    SecurityScreen(),
    HistoryScreen(recentActivity: []),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(_widgetOptions.length, (index) {
          return Offstage(
            offstage: _selectedIndex != index,
            child: _widgetOptions[index],
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF116692),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: Colors.orange,
        // Increase icon size for better visibility
        selectedIconTheme: const IconThemeData(size: 32.0),
        unselectedIconTheme: const IconThemeData(size: 28.0),
        // Make the text labels larger
        selectedLabelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 14.0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Inspect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}