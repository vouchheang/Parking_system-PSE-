import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:parking_system/services/api_service.dart'; // Update to use ApiService
// Import UserpModel

class ParkingRegistrationScreen extends StatefulWidget {
  const ParkingRegistrationScreen({super.key});

  @override
  State<ParkingRegistrationScreen> createState() =>
      _ParkingRegistrationScreenState();
}

class _ParkingRegistrationScreenState extends State<ParkingRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService(); // Use ApiService instead of RegisterController

  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _idCardController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String _selectedVehicleType = 'Motor';
  XFile? _vehicleImage; // Use XFile instead of File
  XFile? _profileImage; // Use XFile instead of File
  final List<String> _vehicleTypes = ['Motor', 'Car', 'Bicycle', 'Other'];

  Future<void> _pickVehicleImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _vehicleImage = image;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  bool _validateImages() {
    if (_profileImage == null || _vehicleImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload both profile and vehicle photos'),
        ),
      );
      return false;
    }
    return true;
  }

Future<void> _submitForm() async {
  final isFormValid = _formKey.currentState!.validate();
  final areImagesValid = _validateImages();

  if (isFormValid && areImagesValid) {
    try {
      print('Submitting: fullname=${_fullnameController.text}, email=${_emailController.text}, ...');
      final user = await _apiService.registerUser(
        fullname: _fullnameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phonenumber: _phoneNumberController.text.trim(),
        idcard: _idCardController.text.trim(),
        vehicletype: _selectedVehicleType.toLowerCase(),
        licenseplate: _licensePlateController.text.trim(),
        profilephoto: _profileImage,
        vehiclephoto: _vehicleImage,
      );

      print('Registration successful: ${user.toJson()}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted successfully!')),
      );

      // Clear form
      _formKey.currentState!.reset();
      _fullnameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneNumberController.clear();
      _idCardController.clear();
      _licensePlateController.clear();
      setState(() {
        _selectedVehicleType = 'Motor';
        _profileImage = null;
        _vehicleImage = null;
      });
    } catch (e) {
      print('Registration error: $e');
      String errorMessage = 'Registration failed: $e';
      if (e.toString().contains('email has already been taken')) {
        errorMessage = 'The email is already registered. Please use a different email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}

  String? _validateFullname(String? value) {
    if (value == null || value.trim().isEmpty) return 'Fullname is required';
    if (value.length < 4) return 'Fullname must be at least 4 characters';
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value)) return 'Fullname can only contain letters and spaces';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.-]+@institute\.pse\.ngo$');
    if (!regex.hasMatch(value)) return 'Please enter a valid PSE email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateLicensePlate(String? value) {
    final regex = RegExp(r'^\d{1,2}[A-Z]{1,3}-\d{3,4}$');
    if (value == null || value.isEmpty) return 'License plate is required';
    if (!regex.hasMatch(value)) return 'Please enter a valid Cambodian license plate';
    return null;
  }

  String? _validateIDCard(String? value) {
    final regex = RegExp(r'^\d{4}-\d{1,2}$');
    if (value == null || value.isEmpty) return 'ID Card is required';
    if (!regex.hasMatch(value)) return 'Please enter a valid PSE staff ID card number';
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final regex = RegExp(r'^(0[1-9]{1}[0-9]{7,8})$');
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!regex.hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF0D6E9E),
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              width: double.infinity,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3D4E5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: kIsWeb
                                  ? Image.network(
                                      _profileImage!.path,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    )
                                  : FutureBuilder<Uint8List>(
                                      future: _profileImage!.readAsBytes(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          );
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Color(0xFF0D6E9E),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Parking Registration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      'Fullname',
                      _fullnameController,
                      _validateFullname,
                    ),
                    _buildTextField(
                      'Email',
                      _emailController,
                      _validateEmail,
                      TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      'Password',
                      _passwordController,
                      _validatePassword,
                      TextInputType.text,
                      true,
                    ),
                    _buildTextField(
                      'Phone Number',
                      _phoneNumberController,
                      _validatePhoneNumber,
                      TextInputType.phone,
                    ),
                    _buildDropdownField(),
                    _buildTextField(
                      'License Plate Number',
                      _licensePlateController,
                      _validateLicensePlate,
                    ),
                    _buildTextField(
                      'ID Card',
                      _idCardController,
                      _validateIDCard,
                    ),
                    _buildImagePicker(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9A826),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Complete',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator, [
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF8FA3AD)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter ${label.toLowerCase()}',
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle Type',
          style: TextStyle(fontSize: 14, color: Color(0xFF8FA3AD)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedVehicleType,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _vehicleTypes
              .map((String type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedVehicleType = newValue;
              });
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Vehicle Photo',
          style: TextStyle(fontSize: 14, color: Color(0xFF8FA3AD)),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickVehicleImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD0D7DE)),
            ),
            child: _vehicleImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            _vehicleImage!.path,
                            fit: BoxFit.cover,
                          )
                        : FutureBuilder<Uint8List>(
                            future: _vehicleImage!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                  )
                : const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Color(0xFF8FA3AD),
                      size: 48,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}