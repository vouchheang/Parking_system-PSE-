import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckinCheckoutScreen extends StatefulWidget {
  const CheckinCheckoutScreen({super.key});

  @override
  State<CheckinCheckoutScreen> createState() => _CheckinCheckoutScreenState();
}

class _CheckinCheckoutScreenState extends State<CheckinCheckoutScreen> {
  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color primaryGreen = Color(0xFF2E8B57);
  static const Color primaryRed = Color(0xFFE53E3E);
  static const Color lightBlue = Color(0xFFE6F0F9);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);

  static const String baseUrl = 'https://pse-parking.final25.psewmad.org/api';
  static const String apiToken = '37|qzVEdYKkHDzrFEygDCq0LR8C6NqSifKWc7Kanw6Sbff81141';

  int totalCheckins = 0;
  int totalCheckouts = 0;
  int currentlyParked = 0;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchParkingData();
  }

  Future<void> fetchParkingData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch parking records or transactions
      final response = await http.get(
        Uri.parse('$baseUrl/security'), // Adjust endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Process the data to count check-ins and check-outs
        // This is a mock calculation - adjust based on your actual API response
        setState(() {
          totalCheckins = 45; // Replace with actual count from API
          totalCheckouts = 38; // Replace with actual count from API
          currentlyParked = totalCheckins - totalCheckouts;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load parking data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue.withOpacity(0.3),
      body: RefreshIndicator(
        onRefresh: fetchParkingData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Parking Counter',
                style: TextStyle(
                  color: textDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Real-time check-in and check-out tracking',
                style: TextStyle(color: textLight, fontSize: 16),
              ),
              const SizedBox(height: 24),
              
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: primaryBlue),
                  ),
                )
              else if (errorMessage != null)
                _buildErrorCard()
              else
                Column(
                  children: [
                    _buildCounterGrid(),
                    const SizedBox(height: 24),
                    _buildCurrentStatusCard(),
                    const SizedBox(height: 24),
                    _buildQuickActionsCard(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 48),
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            style: TextStyle(color: Colors.red.shade700, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: fetchParkingData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterGrid() {
    return Row(
      children: [
        Expanded(child: _buildCounterCard('Check-ins Today', totalCheckins, primaryGreen, Icons.login)),
        const SizedBox(width: 16),
        Expanded(child: _buildCounterCard('Check-outs Today', totalCheckouts, primaryRed, Icons.logout)),
      ],
    );
  }

  Widget _buildCounterCard(String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_parking, color: primaryBlue, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Currently Parked',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentlyParked vehicles',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentlyParked > 50 ? primaryRed.withOpacity(0.1) : primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentlyParked > 50 ? 'High Occupancy' : 'Available Space',
                  style: TextStyle(
                    color: currentlyParked > 50 ? primaryRed : primaryGreen,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle manual check-in
                    _showManualEntryDialog('Check-in');
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Manual Check-in'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle manual check-out
                    _showManualEntryDialog('Check-out');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Manual Check-out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: fetchParkingData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Manual $action'),
          content: Text('Would you like to record a manual $action?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle the manual entry logic here
                _handleManualEntry(action);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _handleManualEntry(String action) {
    setState(() {
      if (action == 'Check-in') {
        totalCheckins++;
        currentlyParked++;
      } else {
        totalCheckouts++;
        currentlyParked--;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Manual $action recorded successfully'),
        backgroundColor: action == 'Check-in' ? primaryGreen : primaryRed,
      ),
    );
  }
}