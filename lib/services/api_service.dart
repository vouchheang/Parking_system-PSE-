import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/models/checkin_out_model.dart';
import 'package:parking_system/models/usercount_model.dart';
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/userp_model.dart';
import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  static const String staticToken =
      '37|qzVEdYKkHDzrFEygDCq0LR8C6NqSifKWc7Kanw6Sbff81141';
  final StorageService _storageService = StorageService();

  Future<UserCount?> fetchUserCount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/count'),
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserCount.fromJson(data);
    } else {
      return null;
    }
  }

  Future<TodayActionCount?> fetchTodayActionCount() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/today-actions'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return TodayActionCount.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<List<Activity>> fetchActivities() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/activities'),
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<List<UserModel>> fetchUsers() async {
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

  Future<void> updateUserProfile(String id, UserpfModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $staticToken',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        // success
      } else {
        throw Exception(responseData['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to update user profile: ${response.statusCode}');
    }
  }

  // Fetch user profile from API
  Future<UserpModel> fetchUserProfile(String id) async {
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

      await _storageService.saveProfileLocally(data);
      return UserpModel.fromJson(data);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<void> postActivity(String userId) async {
    final url = Uri.parse('$baseUrl/api/activities');

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
