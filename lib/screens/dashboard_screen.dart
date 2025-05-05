import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: const Color(0xFFF5F7FA),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PSE PARKING SYSTEM',
          style: TextStyle(
            color: Color(0xFF0A6986),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Manage your parking in easy way!',
          style: TextStyle(
            color: Color(0xFF0A6986),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 24),
        _buildUserStatsCard(),
        const SizedBox(height: 24),
        _buildSectionWithHeader(
          title: 'Recent Activity',
          child: ActivityList(),
        ),
        const SizedBox(height: 24),
        _buildSecuritySection(),
      ],
    ),
  ),
);

  }

  Widget _buildSectionWithHeader({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0A6986),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Security Personnel',
              style: TextStyle(
                color: Color(0xFF0A6986),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildAddSecurityButton(),
          ],
        ),
        const SizedBox(height: 12),
        SecurityList(),
      ],
    );
  }

  Widget _buildUserStatsCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Users',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A6986),
            ),
          ),
         
          const SizedBox(height: 16),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0A6986).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '86',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A6986),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSecurityButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add_circle, color: Colors.white, size: 16),
      label: const Text(
        'Add new security',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A6986),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

class ActivityList extends StatelessWidget {
  ActivityList({super.key});

  final List<Map<String, String>> activities = [
    {'name': 'Nguon Chetsavyit', 'role': 'User', 'action': 'Checked in', 'time': '10:30 AM'},
    {'name': 'Mom Vouchheang', 'role': 'Security', 'action': 'New register', 'time': '09:45 AM'},
    {'name': 'Thern Thavan', 'role': 'User', 'action': 'Checkout', 'time': '09:15 AM'},
    {'name': 'Vann Tseng', 'role': 'Security', 'action': 'New register', 'time': '08:30 AM'},
    {'name': 'Seng In', 'role': 'User', 'action': 'New register', 'time': '08:00 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => _buildActivityItem(activities[index]),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, String> activity) {
    Color iconColor = activity['role'] == 'User' ? Colors.blue : Colors.teal;
    IconData iconData = activity['role'] == 'User' ? Icons.person : Icons.security;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activity['action']} • ${activity['role']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time']!,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SecurityList extends StatelessWidget {
  SecurityList({super.key});

  final List<Map<String, String>> securities = [
    {'name': 'Nguon Chetsavyit', 'id': '21192-1', 'status': 'Active'},
    {'name': 'Mom Vouchheang', 'id': '21192-2', 'status': 'Active'},
    {'name': 'Thern Thavan', 'id': '21192-3', 'status': 'Active'},
    {'name': 'Vann Tseng', 'id': '21192-4', 'status': 'Active'},
    {'name': 'Seng In', 'id': '21192-5', 'status': 'Active'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderRow(),
            const Divider(height: 24),
            ...securities.map((security) => _buildSecurityItem(security)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
      fontSize: 13,
    );

    return Row(
      children: [
        Expanded(flex: 2, child: Text('Name', style: headerStyle)),
        Expanded(child: Text('ID Card', style: headerStyle)),
        Expanded(child: Text('Status', style: headerStyle)),
      ],
    );
  }

  Widget _buildSecurityItem(Map<String, String> security) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              security['name']!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              security['id']!, 
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(child: _buildStatusBadge(security['status']!)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}