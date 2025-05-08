import 'package:flutter/material.dart';

class SecuritiesTeam extends StatefulWidget {
  const SecuritiesTeam({super.key});

  @override
  State<SecuritiesTeam> createState() => _SecuritiesTeamState();
}

class _SecuritiesTeamState extends State<SecuritiesTeam> {
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

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _showAddSecurityForm() {
    // Reset form values
    _nameController.clear();
    _idController.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Add New Security',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: textLight),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      labelStyle: TextStyle(color: textLight),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: primaryOrange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Status will be set to Active',
                        style: TextStyle(
                          color: textLight,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: textLight)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _idController.text.isNotEmpty) {
                    setState(() {
                      attendanceRecords.add({
                        'name': _nameController.text,
                        'date': _idController.text,
                        'status': 'Active',
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                  ), 
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Securities Team',
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
        onPressed: _showAddSecurityForm,
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
