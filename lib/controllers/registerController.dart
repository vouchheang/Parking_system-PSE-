import 'package:flutter/material.dart';
import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationController extends ChangeNotifier {
  final ApiService _apiService;
  bool isLoading = false;
  String? errorMessage;
  UserpModel? registrationModel;
  String? _authToken;

  RegistrationController(this._apiService);

  String? get authToken => _authToken;

  Future<bool> register({
    required String fullname,
    required String email,
    required String password,
    required String phonenumber,
    required String idcard,
    required String vehicletype,
    required String licenseplate,
    required XFile? profilephoto,
    required XFile? vehiclephoto,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final registrationData = await _apiService.registerUser(
        fullname: fullname,
        email: email,
        password: password,
        phonenumber: phonenumber,
        idcard: idcard,
        vehicletype: vehicletype,
        licenseplate: licenseplate,
        profilephoto: profilephoto,
        vehiclephoto: vehiclephoto,
      );

      registrationModel = registrationData;
      
      // Get the stored token from SharedPreferences (saved by the service)
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
      
      if (_authToken != null && _authToken!.isNotEmpty) {
        print('RegistrationController: Token retrieved from storage successfully');
      } else {
        print('RegistrationController: No token found in storage');
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('RegistrationController: Retrieved token from SharedPreferences: ${token != null ? "Token exists" : "No token found"}');
    return token;
  }

  // Clear any existing data
  void clearData() {
    registrationModel = null;
    _authToken = null;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}