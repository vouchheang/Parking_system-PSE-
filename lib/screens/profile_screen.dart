import 'package:flutter/material.dart';
import 'package:parking_system/controllers/userprofile_controller.dart';
import 'package:parking_system/models/userprofile_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen(this.userId, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileController _userProfileController = UserProfileController();
  late Future<UserpModel> _userProfileData;


  @override
  void initState() {
    super.initState();
    _userProfileData = _userProfileController.fetchUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<UserpModel>(
            future: _userProfileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No profile data found'));
              }

              // Profile data is available
              UserpModel profile = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
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
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                profile.profile?.profilephoto != null
                                    ? NetworkImage(
                                          profile.profile!.profilephoto,
                                        )
                                        as ImageProvider
                                    : const AssetImage(
                                      'assets/images/profile.png',
                                    ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profile.fullname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
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
                          border: Border.all(
                            color: const Color.fromARGB(255, 9, 97, 179),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InfoRow(label: 'Name', value: profile.fullname),
                            const SizedBox(height: 12),
                            InfoRow(label: 'Phone', value: profile.id),
                            const SizedBox(height: 12),
                            InfoRow(
                              label: 'Vehicle Type',
                              value: profile.profile?.vehicletype ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            InfoRow(
                              label: 'License Plate',
                              value: profile.profile?.licenseplate ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            InfoRow(label: 'ID Card', value: profile.idcard),
                            const SizedBox(height: 12),
                            InfoRow(label: 'Email', value: profile.email),
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
                            VehiclePhotoBox(
                              vehiclePhotoUrl:
                                  profile.profile?.vehiclephoto ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            top: 20,
            left: 20,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
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
              color: Color(0xFF116692),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class VehiclePhotoBox extends StatelessWidget {
  final String? vehiclePhotoUrl;

  const VehiclePhotoBox({super.key, this.vehiclePhotoUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child:
            vehiclePhotoUrl != null && vehiclePhotoUrl!.isNotEmpty
                ? Image.network(
                  vehiclePhotoUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/motorcycle.png',
                      fit: BoxFit.cover,
                    );
                  },
                )
                : Image.asset(
                  'assets/images/motorcycle.png',
                  fit: BoxFit.cover,
                ),
      ),
    );
  }
}
