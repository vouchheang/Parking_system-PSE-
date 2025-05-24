import 'package:flutter/material.dart';

class AfterscanScreen extends StatelessWidget {
  const AfterscanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
                        color: const Color(0xFF116692).withValues(alpha: 0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D5D83), Color(0xFF116692)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF116692,
                                ).withValues(alpha: 0.3),
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

                        // Success Message and Check-in Status
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
                              color: Colors.grey.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Success Icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0D9E5A,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF0D9E5A),
                                  size: 50,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Success Text
                              const Text(
                                'SUCCESS',
                                style: TextStyle(
                                  color: Color(0xFF0D9E5A),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Status Text
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0D9E5A,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF0D9E5A),
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  'CHECKED IN',
                                  style: TextStyle(
                                    color: Color(0xFF0D9E5A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Ticket Number

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
                                              color: Colors.grey.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Check-in Time
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Check-in Time',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    '10:30 AM, May 23, 2025',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF116692),
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
                            color: Colors.grey.withValues(alpha: 0.3),
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
                              buildInfoRow('Name', 'Jack Sullivan'),
                              const SizedBox(height: 12),
                              buildInfoRow('Phone', '+855 989 025 37'),
                              const SizedBox(height: 12),
                              buildInfoRow('Vehicle Type', 'Beat 025'),
                              const SizedBox(height: 12),
                              buildInfoRow('License Plate', '1BK-5678'),
                              const SizedBox(height: 12),
                              buildInfoRow('ID Card', '21192-1'),
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
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF116692),
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
