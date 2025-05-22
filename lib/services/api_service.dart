import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/userprofile_model.dart';
// import 'package:parking_system/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  // final StorageService _storageService = StorageService();

  Future<List<UserModel>> fetchUsers() async {
    const String staticToken =
        '3|vufyxvd6e9qy0nVcUKpGVk9N3Y5gKV34oGfq8HAR605d44f1'; 

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

  Future<UserpModel> fetchUserProfile(String id) async {
    const String staticToken =
        '3|vufyxvd6e9qy0nVcUKpGVk9N3Y5gKV34oGfq8HAR605d44f1';

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

      final profile = UserpModel.fromJson(data);

      return profile;
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }
}

