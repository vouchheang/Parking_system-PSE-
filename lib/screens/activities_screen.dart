import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recentActivity;

  const HistoryScreen({super.key, required this.recentActivity});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> _recentActivity = [
    {"name": "Mom Vouchheang", "action": "New register", "time": "7:00 PM"},
    {"name": "Thorn Thearith", "action": "Checkout", "time": "7:00 PM"},
    {"name": "Vann Tiang", "action": "New register", "time": "7:00 PM"},
    {"name": "Sang In", "action": "New register", "time": "7:00 PM"},
    {"name": "Mom Vouchheang", "action": "New register", "time": "7:00 PM"},
    {"name": "Mom Vouchheang", "action": "New register", "time": "7:00 PM"},
    {"name": "Thorn Thearith", "action": "Checkout", "time": "7:00 PM"},
    {"name": "Vann Tiang", "action": "New register", "time": "7:00 PM"},
    {"name": "Sang In", "action": "Checked in", "time": "6:55 PM"},
    {"name": "Sok Dara", "action": "Modified user", "time": "6:45 PM"},
    {"name": "Chan Sothea", "action": "Checked in", "time": "6:30 PM"},
    {"name": "Keo Nimol", "action": "New register", "time": "6:15 PM"},
    {"name": "Heng Bunrith", "action": "Checkout", "time": "6:00 PM"},
    {"name": "Sim Sovann", "action": "System update", "time": "5:45 PM"},
    {"name": "Try Kunthea", "action": "Checked in", "time": "5:30 PM"},
    {"name": "Pich Sopheap", "action": "New register", "time": "5:15 PM"},
    {"name": "Meas Sokha", "action": "Checkout", "time": "5:00 PM"},
    {"name": "Thorn Thearith", "action": "Checkout", "time": "7:00 PM"},
    {"name": "Vann Tiang", "action": "New register", "time": "7:00 PM"},
    {"name": "Sang In", "action": "New register", "time": "7:00 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    final combinedActivity = [..._recentActivity, ...widget.recentActivity];

    return Scaffold(
      body: Column(
        children: [
          _buildHistoryTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: combinedActivity.length,
              itemBuilder:
                  (context, index) => _buildHistoryRow(combinedActivity[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTableHeader() {
    final headerStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFF424242),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('Name', style: headerStyle),
            ),
          ),
          Expanded(flex: 1, child: Text('Action', style: headerStyle)),
          Expanded(flex: 1, child: Text('Time', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(Map<String, dynamic> activity) {
    Color actionColor;
    switch (activity['action']) {
      case 'Checked in':
        actionColor = Colors.green;
        break;
      case 'Checkout':
        actionColor = Colors.red;
        break;
      case 'New register':
        actionColor = Colors.blue;
        break;
      default:
        actionColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  activity['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                activity['action'],
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                activity['time'],
                style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
