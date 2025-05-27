import 'dart:convert';
import 'package:parking_system/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/api_service.dart';

class UserProfileController {
  final ApiService _apiService = ApiService();

  Future<void> updateUserProfile(
    String id,
    Map<String, dynamic> updatedProfileData,
  ) {
    return _apiService.updateUserProfile(
      id,
      UserpfModel.fromJson(updatedProfileData),
    );
  }

  /// Online fetch from API
  Future<UserpModel> fetchUserProfile(String userId) async {
    final profile = await _apiService.fetchUserProfile(userId);

    // Save to local storage
    await saveProfileLocally(profile);

    return profile;
  }

  /// Load from SharedPreferences
  Future<UserpModel?> loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userProfile');

    if (jsonString == null) return null;

    final data = jsonDecode(jsonString);
    return UserpModel.fromJson(data);
  }

  /// Save profile to SharedPreferences
  Future<void> saveProfileLocally(UserpModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString('userProfile', jsonString);
  }

  Future<UserpModel> getUserProfile(String userId) async {
    try {
      // Try fetching from the API first
      return await fetchUserProfile(userId);
    } catch (e) {
      // If API fetch fails, try loading from local cache
      final localProfile = await loadProfileFromLocal();
      if (localProfile != null) return localProfile;
      // If no local data, rethrow or throw a custom exception
      throw Exception(
        "Failed to fetch profile online and no offline profile found.",
      );
    }
  }
}
