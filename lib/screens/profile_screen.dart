import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header with more height
                Container(
                  color: const Color(0xFF116692),
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 80, bottom: 50),
                  child: Column(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30, // Title font size updated to 30
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Increased size for profile picture
                      CircleAvatar(
                        radius: 80, // Increased profile picture size
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'JayyJenn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25, // "JayyJenn" font size updated to 20
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Info Card
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 9, 97, 179)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, , 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'Name', value: 'Jack Sullivan'),
                        const SizedBox(height: 12),
                        InfoRow(label: 'Phone', value: '+855 989 025 37'),
                        const SizedBox(height: 12),
                        InfoRow(label: 'Vehicle Type', value: 'Beat 025'),
                        const SizedBox(height: 12),
                        InfoRow(label: 'License Plate', value: '1BK-5678'),
                        const SizedBox(height: 12),
                        InfoRow(label: 'ID Card', value: '21192-1'),
                        const SizedBox(height: 12),
                        InfoRow(label: 'Parking Code', value: 'P-202504301234'),
                        const SizedBox(height: 24),
                        const Text(
                          'Vehicle Photo',
                         
                          style: TextStyle(
                            color: Color(0xFF0B7295),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Added some space above the vehicle image
                        const SizedBox(height: 16),
                        const VehiclePhotoBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating back button
          Positioned(
            top: 20,
            left: 20,
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(137, 0, 0, 0),
              radius: 22,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            '$label :',
            style: const TextStyle(
              color: Color(0xFF116692), // Label color set to 0xFF116692
              fontWeight: FontWeight.bold,
              fontSize: 15, // Label font size updated to 15
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class VehiclePhotoBox extends StatelessWidget {
  const VehiclePhotoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),  // Applying border radius of 8
      child: Container(
        height: 200,
        width: double.infinity,
        child: Image.asset(
          'assets/images/motorcycle.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
