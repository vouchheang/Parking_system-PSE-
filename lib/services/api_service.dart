import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  final StorageService _storageService = StorageService();

  // Fetch list of users
  Future<List<UserModel>> fetchUsers() async {
    const String staticToken = '5|KgzNsnVTbbIhyiLNpD0R2v4WodiQO5oG7NshHPP81d26615f';

    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] is List) {
        return (jsonResponse['data'] as List)
            .map((userJson) => UserModel.fromJson(userJson))
            .toList();
      } else {
        throw Exception('Invalid response format: data is not a list');
      }
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  // Fetch user profile from API
  Future<UserpModel> fetchUserProfile(String id) async {
    const String staticToken = '5|KgzNsnVTbbIhyiLNpD0R2v4WodiQO5oG7NshHPP81d26615f';

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] ?? jsonResponse;

      await _storageService.saveProfileLocally(data); // ✅ Use StorageService
      return UserpModel.fromJson(data);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  // Public method: gets profile, auto-checks for internet
  Future<UserpModel> getUserProfile(String id) async {
    final isOnline = await checkInternet();
    if (isOnline) {
      return await fetchUserProfile(id);
    } else {
      final localProfile = await _storageService.loadProfileFromLocal();
      if (localProfile != null) {
        return localProfile;
      }
      throw Exception("No offline profile found.");
    }
  }

  // Internet check
  Future<bool> checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
