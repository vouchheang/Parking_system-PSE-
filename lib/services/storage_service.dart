import 'package:parking_system/models/userprofile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _profileKey = 'userProfile';
  static const String _roleKey = 'role';
  static const String _idKey = 'id';


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

  // Save role
  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  // Get role
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }


  // Save role
  Future<void> saveID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idKey, id);
  }

  // Get role
  Future<String?> getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
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
  // Clear user profile from local storage
Future<void> clearUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_profileKey);
}

Future<void> clearRole() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_roleKey);
}
}