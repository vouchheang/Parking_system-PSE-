import 'package:flutter/material.dart';
import 'package:parking_system/models/loginModel.dart';
import 'package:parking_system/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final ApiService _apiService;
  bool isLoading = false;
  String? errorMessage;
  LoginModel? loginModel;
  String? _authToken;

  LoginController(this._apiService);

  String? get authToken => _authToken;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final loginData = await _apiService.loginUser(
        email: email,
        password: password,
      );

      loginModel = loginData;
      _authToken = loginData.token; // Set the token in memory
      print('LoginController: Token set in memory: $_authToken');

      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (_authToken != null && _authToken!.isNotEmpty) {
        await prefs.setString('auth_token', _authToken!);
        print('LoginController: Token saved to SharedPreferences: $_authToken');
      } else {
        print('LoginController: No token found to save');
      }

      // Verify storage
      final storedToken = prefs.getString('auth_token');
      print('LoginController: Token retrieved from SharedPreferences: $storedToken');

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
    print('LoginController: Retrieved token from SharedPreferences: $token');
    return token;
  }
}