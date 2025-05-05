import 'package:flutter/material.dart';

void main() {
  runApp(const ParkingPassApp());
}

class ParkingPassApp extends StatelessWidget {
  const ParkingPassApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Pass',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const ParkingPassScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ParkingPassScreen extends StatelessWidget {
  const ParkingPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content (pushed down by 60 pixels)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                child: Column(
                  children: [
                    // Parking Code Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF116692),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF116692),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'PARKING CODE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // QR Code
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Image.asset(
                              'assets/images/qr_code.png',
                              width: 180,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // User Information
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Column(
                              children: [
                                buildInfoRow('Name', 'Jack Sullivan'),
                                const SizedBox(height: 12),
                                buildInfoRow('Phone', '+855 989 025 37'),
                                const SizedBox(height: 12),
                                buildInfoRow('Vehicle Type', 'Beat 025'),
                                const SizedBox(height: 12),
                                buildInfoRow('License Plate', '1BK-5678'),
                                const SizedBox(height: 12),
                                buildInfoRow('ID Card', '21192-1'),
                                const SizedBox(height: 12),
                                buildInfoRow('Parking Code', 'P-202504301234'),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),

                          // Vehicle Photo Section
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Vehicle Photo',
                              style: TextStyle(
                                color: Color(0xFF0B7295),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Vehicle Photo
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/motorcycle.png',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 10,
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
            )
          ],
        ),
      ),
    );
  }

  static Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF116692),
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
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
