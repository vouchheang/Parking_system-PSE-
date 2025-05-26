import 'package:parking_system/models/userprofile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _profileKey = 'userProfile';

  // Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear token (e.g., logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_profileKey); // Clear profile too
  }

  // ✅ Save profile locally
  Future<void> saveProfileLocally(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_profileKey, jsonEncode(data));
  }

  // ✅ Load profile from local storage
  Future<UserpModel?> loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileKey);

    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      return UserpModel.fromJson(jsonData);
    }
    return null;
  }
}