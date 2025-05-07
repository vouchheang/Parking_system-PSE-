import 'package:flutter/material.dart';

class SecuritiesTeam extends StatelessWidget {
  SecuritiesTeam({super.key});

  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color primaryGreen = Color(0xFF2E8B57);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);

  final List<Map<String, dynamic>> attendanceRecords = [
    {'name': 'Nguon Chetsavyit', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Mom Vouchheang', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Thern Thavan', 'date': '21192-1', 'status': 'Inactive'},
    {'name': 'Vann Tseng', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Seng In', 'date': '21192-1', 'status': 'Inactive'},
    {'name': 'Nguon Chetsavyit', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Seng In', 'date': '21192-1', 'status': 'Inactive'},
    {'name': 'Nguon Chetsavyit', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Seng In', 'date': '21192-1', 'status': 'Inactive'},
    {'name': 'Nguon Chetsavyit', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Mom Vouchheang', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Thern Thavan', 'date': '21192-1', 'status': 'Inactive'},
    {'name': 'Vann Tseng', 'date': '21192-1', 'status': 'Active'},
    {'name': 'Seng In', 'date': '21192-1', 'status': 'Inactive'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Secutities Team',
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecuritiesTeamHeader(),
            Expanded(
              child: Container(
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
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children:
                      attendanceRecords
                          .map((record) => _buildAttendanceItem(record))
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSecuritiesTeamHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Text(
              'Employee',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textDark,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textDark,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> record) {
    final bool isActive = record['status'] == 'Active';
    final Color statusColor = isActive ? primaryOrange : primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      record['name'][0],
                      style: const TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      record['date'],
                      style: const TextStyle(fontSize: 12, color: textLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                record['status'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
