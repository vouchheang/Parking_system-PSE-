import 'package:flutter/material.dart';
import 'package:parking_system/controllers/activity_controller.dart';
import 'package:parking_system/models/activity_model.dart';

// Import your existing model classes and fetchActivity function
// Make sure to import the file where your User, Activity models and fetchActivity function are defined

class AfterscanScreen extends StatefulWidget {
  final String activityId; // Pass the activity ID to fetch

  const AfterscanScreen({super.key, required this.activityId});

  @override
  State<AfterscanScreen> createState() => _AfterscanScreenState();
}

class _AfterscanScreenState extends State<AfterscanScreen> {
  Activity? activity;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchActivityData();
  }

  Future<void> _fetchActivityData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Using your existing fetchActivity function
      // If your function is named fetchActivities (plural)
      final fetchedActivity = await ActivityController().fetchActivity(
        widget.activityId,
      );
      setState(() {
        activity = fetchedActivity;
        isLoading = false;
        if (fetchedActivity == null) {
          errorMessage = 'Failed to load activity data';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: $e';
      });
    }
  }

  // Helper method to get colors based on action type
  Map<String, dynamic> _getActionColors(String action) {
    final actionLower = action.toLowerCase();

    if (actionLower.contains('check-in') ||
        actionLower.contains('checkin') ||
        actionLower == 'in') {
      return {
        'primary': const Color(0xFF0D9E5A), // Green for check-in
        'secondary': const Color(0xFF0A7C47),
        'background': const Color(0xFF0D9E5A).withOpacity(0.1),
        'icon': Icons.login,
        'gradient': [const Color(0xFF0A7C47), const Color(0xFF0D9E5A)],
      };
    } else if (actionLower.contains('check-out') ||
        actionLower.contains('checkout') ||
        actionLower == 'out') {
      return {
        'primary': const Color(0xFFE74C3C), // Red for check-out
        'secondary': const Color(0xFFC0392B),
        'background': const Color(0xFFE74C3C).withOpacity(0.1),
        'icon': Icons.logout,
        'gradient': [const Color(0xFFC0392B), const Color(0xFFE74C3C)],
      };
    } else {
      // Default blue color for other actions
      return {
        'primary': const Color(0xFF116692),
        'secondary': const Color(0xFF0D5D83),
        'background': const Color(0xFF116692).withOpacity(0.1),
        'icon': Icons.check_circle,
        'gradient': [const Color(0xFF0D5D83), const Color(0xFF116692)],
      };
    }
  }

  // Helper method to get action display text
  String _getActionDisplayText(String action) {
    final actionLower = action.toLowerCase();

    if (actionLower.contains('check-in') ||
        actionLower.contains('checkin') ||
        actionLower == 'in') {
      return 'CHECKED IN';
    } else if (actionLower.contains('check-out') ||
        actionLower.contains('checkout') ||
        actionLower == 'out') {
      return 'CHECKED OUT';
    } else {
      return action.toUpperCase();
    }
  }

  // Helper method to get time label
  String _getTimeLabel(String action) {
    final actionLower = action.toLowerCase();

    if (actionLower.contains('check-in') ||
        actionLower.contains('checkin') ||
        actionLower == 'in') {
      return 'Check-in Time';
    } else if (actionLower.contains('check-out') ||
        actionLower.contains('checkout') ||
        actionLower == 'out') {
      return 'Check-out Time';
    } else {
      return 'Activity Time';
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      final String formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      final String formattedDate =
          '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
      return '$formattedTime, $formattedDate';
    } catch (e) {
      return dateTimeString; // Return original string if parsing fails
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final actionColors =
        activity != null ? _getActionColors(activity!.action) : null;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF116692)),
                    SizedBox(height: 16),
                    Text(
                      'Loading activity data...',
                      style: TextStyle(color: Color(0xFF116692), fontSize: 16),
                    ),
                  ],
                ),
              )
            else if (errorMessage != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[400], size: 60),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red[400], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchActivityData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF116692),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (activity != null && actionColors != null)
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),

                    Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: actionColors['primary'].withValues(alpha: 0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Header - Dynamic gradient based on action
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: actionColors['gradient'],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: actionColors['primary'].withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'PARKING TICKET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),

                          // Success Message and Check-in/Check-out Status
                          Container(
                            margin: const EdgeInsets.all(24),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: actionColors['primary'].withValues(
                                  alpha: 0.2,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Success Icon - Dynamic based on action
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: actionColors['background'],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    actionColors['icon'],
                                    color: actionColors['primary'],
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Success Text
                                const Text(
                                  'SUCCESS',
                                  style: TextStyle(
                                    color: Color(0xFF2C3E50),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Status Text - Dynamic color based on action
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: actionColors['background'],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: actionColors['primary'],
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _getActionDisplayText(activity!.action),
                                    style: TextStyle(
                                      color: actionColors['primary'],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Dotted Line
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: List.generate(
                                          (constraints.constrainWidth() / 10)
                                              .floor(),
                                          (index) => SizedBox(
                                            width: 5,
                                            height: 1,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: actionColors['primary']
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Check-in/Check-out Time - Dynamic label and color
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getTimeLabel(activity!.action),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      _formatDateTime(activity!.createdAt),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: actionColors['primary'],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(
                              color: actionColors['primary'].withValues(
                                alpha: 0.3,
                              ),
                              thickness: 1,
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                buildInfoRow(
                                  'Name',
                                  activity!.user.fullname,
                                  actionColors['primary'],
                                ),
                                const SizedBox(height: 12),
                                buildInfoRow(
                                  'Email',
                                  activity!.user.email,
                                  actionColors['primary'],
                                ),
                                const SizedBox(height: 12),
                                buildInfoRow(
                                  'User ID',
                                  activity!.user.id,
                                  actionColors['primary'],
                                ),
                                const SizedBox(height: 12),
                                // You can add more fields here if your API returns vehicle info
                                // buildInfoRow('Vehicle Type', 'Beat 025', actionColors['primary']),
                                // const SizedBox(height: 12),
                                // buildInfoRow('License Plate', '1BK-5678', actionColors['primary']),
                                // const SizedBox(height: 12),
                                // buildInfoRow('ID Card', '21192-1', actionColors['primary']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget buildInfoRow(String label, String value, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            ':',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
