import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  final StorageService _storageService = StorageService();

  // Fetch list of users
  Future<List<UserModel>> fetchUsers() async {
    const String staticToken =
        '12|NRNLrtv7YXimpp9Dz5PQdZNrw8trWfJge9b9fsaXaf0b4e41';

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
    const String staticToken =
        '12|NRNLrtv7YXimpp9Dz5PQdZNrw8trWfJge9b9fsaXaf0b4e41';

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

  Future<void> postActivity(String userId) async {
    final url = Uri.parse('$baseUrl/api/activities');
    const String staticToken =
        '12|NRNLrtv7YXimpp9Dz5PQdZNrw8trWfJge9b9fsaXaf0b4e41';

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Optionally parse response to show message
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        // success, you can show a snackbar or update UI
      } else {
        throw Exception(responseData['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to post activity');
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
