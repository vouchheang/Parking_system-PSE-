import 'package:flutter/material.dart';
import 'package:parking_system/screens/home_screen.dart';
import 'package:parking_system/screens/select_screen.dart';
import 'package:parking_system/screens/users_list_screen.dart';
import 'package:parking_system/screens/dashboard_screen.dart';
import 'package:parking_system/screens/scan_screen.dart';
import 'package:parking_system/services/storage_service.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  final StorageService _storageService = StorageService();
  String role = "user";
  String userId = "";
  bool _isLoggingOut = false; // Add loading state

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  Future<void> getInitData() async {
    final currentRole = await _storageService.getRole() ?? "user";
    final currentId = await _storageService.getID() ?? "";
    setState(() {
      role = currentRole;
      userId = currentId;
    });
  }

  List<Widget> get _widgetOptions {
    switch (role) {
      case 'admin':
        return [DashboardScreen(), SecurityScreen(), UserListScreen()];
      case 'security_guard':
        return [SecurityScreen(), UserListScreen()];
      default:
        return []; // Invalid role
    }
  }

  List<BottomNavigationBarItem> get _navItems {
    switch (role) {
      case 'admin':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.face_retouching_natural),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Users',
          ),
        ];
      case 'security_guard':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.face_retouching_natural),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Users',
          ),
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

  // Enhanced logout function with better UI
  Future<void> _showLogoutDialog() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 222, 14, 45),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Confirm Logout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 214, 61, 61),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _performLogout();
    }
  }

  Future<void> _performLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Show loading snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Logging out...'),
            ],
          ),
          backgroundColor: const Color(0xFF116692),
          duration: const Duration(seconds: 2),
        ),
      );

      // Clear storage
      await _storageService.clearToken();
      await _storageService.clearUserProfile();
      await _storageService.clearRole();
      await _storageService.clearId();

      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate to auth screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthSelectionScreen()),
        (Route<dynamic> route) => false,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Text('Successfully logged out'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle error
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Text('Logout failed. Please try again.'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 39, 39),
        title: const Text('Logout'),
        actions: [
          // Enhanced logout button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child:
                _isLoggingOut
                    ? Container(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                    : IconButton(
                      onPressed: _showLogoutDialog,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.logout_rounded, size: 20),
                      ),
                      tooltip: 'Logout',
                      splashRadius: 24,
                    ),
          ),
        ],
      ),
      body: Stack(
        children: List.generate(_widgetOptions.length, (index) {
          return Offstage(
            offstage: _selectedIndex != index,
            child: _widgetOptions[index],
          );
        }),
      ),
      bottomNavigationBar:
          role == "user"
              ? HomeScreen()
              : BottomNavigationBar(
                backgroundColor: const Color(0xFF116692),
                unselectedItemColor: Colors.white,
                selectedItemColor: Colors.orange,
                selectedIconTheme: const IconThemeData(size: 32.0),
                unselectedIconTheme: const IconThemeData(size: 28.0),
                selectedLabelStyle: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 14.0),
                items: _navItems,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
    );
  }
}
