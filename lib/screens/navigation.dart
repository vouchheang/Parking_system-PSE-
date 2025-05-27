import 'package:flutter/material.dart';
import 'package:parking_system/screens/users_list_screen.dart';
import 'package:parking_system/screens/dashboard_screen.dart';
import 'package:parking_system/screens/scan_screen.dart';

class NavigationScreen extends StatefulWidget {
  final String role; 

  const NavigationScreen(String s, {super.key, required this.role});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> get _widgetOptions {
    switch (widget.role) {
      case 'admin':
        return [
          DashboardScreen(),
          SecurityScreen(),
          UserListScreen(),
        ];
      case 'security_guard':
        return [
          SecurityScreen(),
          UserListScreen(),
        ];
      default:
        return []; // Invalid role
    }
  }

  List<BottomNavigationBarItem> get _navItems {
    switch (widget.role) {
      case 'admin':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.face_retouching_natural), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Users'),
        ];
      case 'security_guard':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.face_retouching_natural), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Users'),
        ];
      default:
        return [];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Block access for unknown roles
    print("Role: ${widget.role}");
    if (_widgetOptions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text("Access Denied"),
        ),
      );
    }

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
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.orange,
        selectedIconTheme: const IconThemeData(size: 32.0),
        unselectedIconTheme: const IconThemeData(size: 28.0),
        selectedLabelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 14.0),
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
