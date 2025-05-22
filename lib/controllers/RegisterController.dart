import 'dart:io';
import 'package:parking_system/services/api_service.dart';

class RegisterController {
  final ApiService _apiService = ApiService();

  Future<void> register({
    required String fullname,
    required String email,
    required String password,
    required String idcard,
    required String vehicletype,
    required String licenseplate,
    required String phonenumber,
    required File profileImage,
    required File vehicleImage,
  }) {
    return _apiService.registerUser(
      fullname: fullname,
      email: email,
      password: password,
      idcard: idcard,
      vehicletype: vehicletype,
      licenseplate: licenseplate,
      phonenumber: phonenumber,
      profileImage: profileImage,
      vehicleImage: vehicleImage,
    );
  }
}
