import 'package:flutter/material.dart';
import 'package:parking_system/models/loginModel.dart';
import 'package:parking_system/services/api_service.dart';
import 'package:parking_system/services/storage_service.dart'; // Add this import

class LoginController extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService = StorageService();
  
  bool isLoading = false;
  String? errorMessage;
  LoginModel? loginModel;
  String? _authToken;
  bool isAuthenticated = false;

  LoginController(this._apiService);

  String? get authToken => _authToken;

  // Check if user is already logged in (auto-login)
  Future<bool> checkAuthStatus() async {
    try {
      isLoading = true;
      notifyListeners();

      final storedToken = await _storageService.getToken();
      
      if (storedToken != null && storedToken.isNotEmpty) {
        _authToken = storedToken;
        isAuthenticated = true;
        
        
        isLoading = false;
        notifyListeners();
        return true;
      }
      
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

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
      _authToken = loginData.token;
      isAuthenticated = true;

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

  // Use StorageService instead of direct SharedPreferences
  Future<String?> getStoredToken() async {
    return await _storageService.getToken();
  }

  // Optional: Add logout method that uses StorageService
  Future<void> logout() async {
    await _storageService.clearToken();
    _authToken = null;
    loginModel = null;
    isAuthenticated = false;
    notifyListeners();
  }
}