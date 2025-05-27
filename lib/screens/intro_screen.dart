import 'package:flutter/material.dart';
import 'package:parking_system/screens/home_screen.dart';
import 'package:parking_system/screens/login_screen.dart';
import 'package:parking_system/screens/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking_system/screens/register._creen.dart';

enum UserRole { user, admin, securityGuard }

class WhoAreYouScreen extends StatefulWidget {
  const WhoAreYouScreen({super.key, required this.userId});

  final String userId;
  @override
  State<WhoAreYouScreen> createState() => _WhoAreYouScreenState();
}

class _WhoAreYouScreenState extends State<WhoAreYouScreen> {
  UserRole? _selectedRole;

  final List<Map<String, dynamic>> _roles = [
    {
      'role': UserRole.user,
      'title': 'User',
      'description': 'I want to find and book parking spaces',
      'icon': Icons.person,
    },
    {
      'role': UserRole.admin,
      'title': 'Admin',
      'description': 'I manage parking facilities and operations',
      'icon': Icons.admin_panel_settings,
    },
    {
      'role': UserRole.securityGuard,
      'title': 'Security Guard',
      'description': 'I monitor and secure parking areas',
      'icon': Icons.security,
    },
  ];

  String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'user';
      case UserRole.admin:
        return 'admin';
      case UserRole.securityGuard:
        return 'security_guard';
    }
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

              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/in.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Text(
                'Who are you?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Select your role to get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                flex: 4,
                child: ListView.builder(
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role['role'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedRole = role['role'];
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    role['icon'],
                                    color:
                                        isSelected ? mainColor : Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        role['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        role['description'],
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedRole != null
                          ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            final String? token = prefs.getString('authToken');

                            // Save selected role first
                            await prefs.setString(
                              'userRole',
                              _getRoleString(_selectedRole!),
                            );

                            if (token != null) {
                              // Already logged in - navigate based on role
                              switch (_selectedRole!) {
                                case UserRole.user:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              HomeScreen(widget.userId),
                                    ),
                                  );
                                  break;
                                case UserRole.admin:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => NavigationScreen(
                                            widget.userId,
                                            role: 'admin',
                                          ),
                                    ),
                                  );
                                  break;
                                case UserRole.securityGuard:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => NavigationScreen(
                                            widget.userId,
                                            role: 'security_guard',
                                          ),
                                    ),
                                  );
                                  break;
                              }
                            } else {
                              // First time - navigate to registration/login based on role
                              switch (_selectedRole!) {
                                case UserRole.user:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ParkingRegistrationScreen(
                                                userId: '',
                                              ),
                                    ),
                                  );
                                  break;
                                case UserRole.admin:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => NavigationScreen(
                                            widget.userId,
                                            role: 'admin',
                                          ),
                                    ),
                                  );
                                  break;
                                case UserRole.securityGuard:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => NavigationScreen(
                                            widget.userId,
                                            role: 'security_guard',
                                          ),
                                    ),
                                  );
                                  break;
                              }
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedRole != null ? Colors.orange : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _selectedRole != null
                        ? 'Continue as ${_roles.firstWhere((role) => role['role'] == _selectedRole)['title']}'
                        : 'Select a role to continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
