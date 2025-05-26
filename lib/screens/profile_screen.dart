import 'package:flutter/material.dart';
import 'package:parking_system/controllers/userprofile_controller.dart';
import 'package:parking_system/models/userprofile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.userId, {super.key});
  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileController _userProfileController = UserProfileController();
  late Future<UserpModel> _userProfileData;
  bool _isEditing = false;
  bool _isUpdating = false;

  // Text controllers for editing (removed email controller since it's read-only)
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _vehicletypeController = TextEditingController();
  final TextEditingController _licenseplateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProfileData = _userProfileController.getUserProfile(widget.userId);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _idcardController.dispose();
    _phonenumberController.dispose();
    _vehicletypeController.dispose();
    _licenseplateController.dispose();
    super.dispose();
  }

  void _populateControllers(UserpModel profile) {
    _fullnameController.text = profile.fullname;
    _idcardController.text = profile.idcard;
    _phonenumberController.text = profile.phonenumber;
    _vehicletypeController.text = profile.vehicletype;
    _licenseplateController.text = profile.licenseplate;
  }

  void _onEditPressed() {
    setState(() {
      _isEditing = true;
    });
  }

  void _onCancelEdit() {
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _onSavePressed() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      Map<String, dynamic> updatedProfileData = {
        'fullname': _fullnameController.text.trim(),
        'idcard': _idcardController.text.trim(),
        'vehicletype': _vehicletypeController.text.trim(),
        'licenseplate': _licenseplateController.text.trim(),
        'phonenumber': _phonenumberController.text.trim(),
        'profilephoto': '', // You might want to handle photo updates separately
        'vehiclephoto': '', // You might want to handle photo updates separately
      };

      // Update the user profile with the new data
      await _userProfileController.updateUserProfile(
        widget.userId,
        updatedProfileData,
      );

      // Refresh the profile data
      setState(() {
        _userProfileData = _userProfileController.getUserProfile(widget.userId);
        _isEditing = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
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

              // Populate controllers when not editing (to get fresh data)
              if (!_isEditing) {
                _populateControllers(profile);
              }

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
                                // ignore: unnecessary_null_comparison
                                profile.profilephoto != null
                                    ? NetworkImage(
                                          profile.profilephoto,
                                        )
                                        as ImageProvider
                                    : const AssetImage(
                                      'assets/images/profile.png',
                                    ),
                          ),
                          const SizedBox(height: 12),

                          // Edit/Save/Cancel buttons
                          if (!_isEditing)
                            ElevatedButton.icon(
                              onPressed: _onEditPressed,
                              icon: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Color(0xFF116692),
                              ),
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Color(0xFF116692),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  197,
                                  197,
                                ),
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed:
                                      _isUpdating ? null : _onSavePressed,
                                  icon:
                                      _isUpdating
                                          ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF116692),
                                            ),
                                          )
                                          : const Icon(
                                            Icons.save,
                                            size: 18,
                                            color: Color(0xFF116692),
                                          ),
                                  label: Text(
                                    _isUpdating ? 'Saving...' : 'Save',
                                    style: const TextStyle(
                                      color: Color(0xFF116692),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[100],
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: _isUpdating ? null : _onCancelEdit,
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[100],
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 16),
                          Text(
                            _isEditing
                                ? _fullnameController.text
                                : profile.fullname,
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
                            _isEditing
                                ? EditableInfoRow(
                                  label: 'Fullname',
                                  controller: _fullnameController,
                                )
                                : InfoRow(
                                  label: 'Fullname',
                                  value: profile.fullname,
                                ),
                            const SizedBox(height: 12),
                            _isEditing
                                ? EditableInfoRow(
                                  label: 'Phone Number',
                                  controller: _phonenumberController,
                                )
                                : InfoRow(
                                  label: 'Phone Number',
                                  value: profile.phonenumber,
                                ),
                            const SizedBox(height: 12),
                            _isEditing
                                ? EditableInfoRow(
                                  label: 'Vehicle Type',
                                  controller: _vehicletypeController,
                                )
                                : InfoRow(
                                  label: 'Vehicle Type',
                                  value: profile.vehicletype,
                                ),
                            const SizedBox(height: 12),
                            _isEditing
                                ? EditableInfoRow(
                                  label: 'License Plate',
                                  controller: _licenseplateController,
                                )
                                : InfoRow(
                                  label: 'License Plate',
                                  value: profile.licenseplate,
                                ),
                            const SizedBox(height: 12),
                            _isEditing
                                ? EditableInfoRow(
                                  label: 'ID Card',
                                  controller: _idcardController,
                                )
                                : InfoRow(
                                  label: 'ID Card',
                                  value: profile.idcard,
                                ),
                            const SizedBox(height: 12),
                            // Email is always read-only, regardless of edit mode
                            ReadOnlyInfoRow(
                              label: 'Email',
                              value: profile.email,
                            ),
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
                              vehiclePhotoUrl: profile.vehiclephoto,
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

class EditableInfoRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const EditableInfoRow({
    super.key,
    required this.label,
    required this.controller,
  });

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
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}

// New widget for read-only fields with visual distinction
class ReadOnlyInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ReadOnlyInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Row(
            children: [
              Text(
                '$label :',
                style: const TextStyle(
                  color: Color(0xFF116692),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.lock, size: 14, color: Colors.grey),
            ],
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
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
