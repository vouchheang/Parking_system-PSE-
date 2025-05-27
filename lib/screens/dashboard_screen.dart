import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/controllers/usercount_controller.dart';
import 'package:parking_system/screens/securities_team.dart';
import 'package:parking_system/services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color lightBlue = Color(0xFFE6F0F9);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);

  final UserCountController _userController = UserCountController();
  // Add controller for today's actions
  final UserCountController _todayActionController = UserCountController();

  // User count variables
  int totalUsers = 0;
  bool isLoadingUsers = true;
  String? userCountError;

  // Today's action variables
  int todayCheckins = 0;
  int todayCheckouts = 0;
  bool isLoadingActions = true;
  String? actionCountError;

  @override
  void initState() {
    super.initState();
    _fetchUserCount();
    _fetchTodayActions(); // Add this line
  }

  Future<void> _fetchUserCount() async {
    setState(() {
      isLoadingUsers = true;
      userCountError = null;
    });

    try {
      final userCount = await _userController.fetchUserCount();
      if (userCount != null && userCount.success) {
        setState(() {
          totalUsers = userCount.totalUsers;
          isLoadingUsers = false;
        });
      } else {
        setState(() {
          userCountError = 'Failed to fetch user count';
          isLoadingUsers = false;
        });
      }
    } catch (e) {
      setState(() {
        userCountError = 'Error: $e';
        isLoadingUsers = false;
      });
    }
  }

  // Add this new method to fetch today's actions
  Future<void> _fetchTodayActions() async {
    setState(() {
      isLoadingActions = true;
      actionCountError = null;
    });

    try {
      final todayActions = await _todayActionController.fetchTodayActionCount();
      if (todayActions != null) {
        setState(() {
          todayCheckins = todayActions.checkins;
          todayCheckouts = todayActions.checkouts;
          isLoadingActions = false;
        });
      } else {
        setState(() {
          actionCountError = 'Failed to fetch today\'s actions';
          isLoadingActions = false;
        });
      }
    } catch (e) {
      setState(() {
        actionCountError = 'Error: $e';
        isLoadingActions = false;
      });
    }
  }

  // Add refresh method for both data sources
  Future<void> _refreshAllData() async {
    await Future.wait([_fetchUserCount(), _fetchTodayActions()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue.withValues(alpha: 0.3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Admin!',
              style: TextStyle(
                color: textDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your parking in easy way!',
              style: TextStyle(color: textLight, fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildTotalUsersCard(),
            const SizedBox(height: 24),
            _buildSecurityListHeader(context),
            const SizedBox(height: 10),
            const SecurityTeamWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalUsersCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Users row with dynamic data
          Row(
            children: [
              const Icon(Icons.people, color: primaryBlue, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Total Users:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(width: 8),
              if (isLoadingUsers)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryOrange,
                  ),
                )
              else if (userCountError != null)
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                )
              else
                Text(
                  '$totalUsers',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryOrange,
                  ),
                ),
              if (!isLoadingUsers && userCountError == null)
                IconButton(
                  icon: const Icon(Icons.refresh, color: primaryBlue, size: 20),
                  onPressed: _refreshAllData, // Changed to refresh all data
                  tooltip: 'Refresh data',
                ),
            ],
          ),
          if (userCountError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                userCountError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 20),
          // Updated check-in/check-out cards with dynamic data
          Row(
            children: [
              // Check-ins Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.login, color: Colors.green, size: 24),
                      const SizedBox(height: 12),
                      if (isLoadingActions)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.green,
                          ),
                        )
                      else if (actionCountError != null)
                        const Text(
                          '--',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                      else
                        Text(
                          '$todayCheckins',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Check-ins Today',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Check-outs Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.logout, color: Colors.red, size: 24),
                      const SizedBox(height: 12),
                      if (isLoadingActions)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      else if (actionCountError != null)
                        const Text(
                          '--',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                      else
                        Text(
                          '$todayCheckouts',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Check-outs Today',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Add error message for actions if needed
          if (actionCountError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                actionCountError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSecurityListHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Security Team',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecuritiesTeam()),
            );
          },
          child: const Text(
            'View All',
            style: TextStyle(color: primaryOrange, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// Keep all your existing classes below (SecurityModel, SecurityTeamWidget, etc.)
class SecurityModel {
  final String id;
  final String fullname;
  final String status;
  final String? idcard;

  SecurityModel({
    required this.id,
    required this.fullname,
    this.idcard,
    required this.status,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    final securityData = json['security'] as Map<String, dynamic>?;

    return SecurityModel(
      id: json['id'].toString(),
      fullname: json['fullname'] ?? '',
      idcard: json['idcard']?.toString(),
      status: securityData?['status'] ?? json['status'] ?? 'active',
    );
  }
}

class SecurityTeamWidget extends StatefulWidget {
  const SecurityTeamWidget({super.key});

  @override
  State<SecurityTeamWidget> createState() => _SecurityTeamWidgetState();
}

class _SecurityTeamWidgetState extends State<SecurityTeamWidget> {
  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color primaryGreen = Color(0xFF2E8B57);
  static const Color textDark = Color(0xFF333333);

  static const String baseUrl = 'https://pse-parking.final25.psewmad.org/api';
  final StorageService _storageService = StorageService();

  List<SecurityModel> securities = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSecurities();
  }

  void _handleApiError(dynamic error) {
    setState(() {
      if (error is http.ClientException) {
        errorMessage = 'Network error: ${error.message}';
      } else {
        errorMessage = 'Error: $error';
      }
      isLoading = false;
    });

    debugPrint('API Error: $error');
  }

  Future<void> fetchSecurities() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/security'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('API Response: ${response.body}');

        final dynamic responseData = json.decode(response.body);
        List<dynamic> data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          data = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          data = responseData;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }

        setState(() {
          securities =
              data
                  .map(
                    (item) =>
                        SecurityModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
          if (securities.length > 4) {
            securities = securities.sublist(0, 4);
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load securities. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      _handleApiError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const Divider(height: 30, thickness: 1),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: primaryBlue),
              ),
            )
          else if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (securities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('No security team members found')),
            )
          else
            ...securities.map((security) => _buildSecurityItem(security)),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: textDark,
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Text('Employee', style: headerStyle)),
          Expanded(child: Text('Status', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(SecurityModel security) {
    final bool isActive = security.status.toLowerCase() == 'active';
    final Color statusColor = isActive ? primaryOrange : primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                security.fullname.isNotEmpty ? security.fullname[0] : '?',
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  security.fullname,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                Text(
                  security.idcard ?? 'ID: Not available',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              security.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
