import 'package:flutter/material.dart';
import 'package:parking_system/components/qrcode_screen.dart';
import 'package:parking_system/controllers/userprofile_controller.dart';
import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.userId, {super.key});
  final String userId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();

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

class _HomeScreenState extends State<HomeScreen> {
  final UserProfileController _userProfileController = UserProfileController();
  late Future<UserpModel> _userProfileData;

  @override
  void initState() {
    super.initState();
    print(widget.userId);
    _userProfileData = _userProfileController.getUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const ProfileScreen(''),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(
                                      tween,
                                    );
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF116692),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF116692,
                                        ).withAlpha(50),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      'assets/images/profile.png',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'JayyJenn!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF116692),
                                      ),
                                    ),
                                    Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                    // Parking Code Card
                    Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: const Color(0xFF116692).withAlpha(80),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Card Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF0D5D83), Color(0xFF116692)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'PARKING CODE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // QR Code
                          QRScreen(userId: widget.userId),
                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(
                              color: Colors.grey.withAlpha(80),
                              thickness: 1,
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: FutureBuilder<UserpModel>(
                              future: _userProfileData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Center(
                                    child: Text('No profile data found'),
                                  );
                                }

                                final profile = snapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HomeScreen.buildInfoRow(
                                      "Full Name",
                                      profile.fullname,
                                    ),
                                    HomeScreen.buildInfoRow(
                                      "ID Card",
                                      profile.idcard,
                                    ),
                                    HomeScreen.buildInfoRow(
                                      "Phone",
                                      profile.phonenumber,
                                    ),
                                    HomeScreen.buildInfoRow(
                                      "License Plate",
                                      profile.licenseplate,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          // Vehicle Image
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.directions_bike,
                                        color: Color(0xFF0B7295),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Vehicle Photo',
                                        style: TextStyle(
                                          color: Color(0xFF0B7295),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(8),
                                //   child: Image.asset(
                                //     'assets/images/motorcycle.png',
                                //     width: double.infinity,
                                //     height: 200,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
