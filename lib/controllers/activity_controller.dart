import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/services/api_service.dart';
import 'package:parking_system/services/storage_service.dart';

class ActivityController {
  final ApiService _apiService = ApiService();

  // Change method to accept userId string only
  Future<void> postActivity(String userId) {
    final Map<String, dynamic> body = {'user_id': userId};

    return _apiService.postActivity(body as String);
  }

  Future<List<Activity>> fetchActivities() {
    return _apiService.fetchActivities();
  }

   final String baseUrl = "https://pse-parking.final25.psewmad.org/api/activity/";
  final StorageService _storageService = StorageService();

 Future<Activity?> fetchActivity(String id) async {
   final token = await _storageService.getToken(); 
    if (token == null) {
      throw Exception('Token not found');
    }
  final String apiUrl = baseUrl + id;  // append the dynamic id here

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',  // add your token here
        'Accept': 'application/json',      // optional but recommended
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Activity.fromJson(jsonData);
    } else {
      print('Failed to load activity, status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching activity: $e');
    return null;
  }
}

}
