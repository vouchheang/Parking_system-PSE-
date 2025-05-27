import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/services/api_service.dart';

class ActivityController {
  final ApiService _apiService = ApiService();
  final String baseUrl = "https://pse-parking.final25.psewmad.org";
  final staticToken = '71|uo1wPGg4qPwMH0BGuxDAyRN2fi657zpjMxXjoeyY1bb77bd7';

  // Updated postActivity method to return ActivityResponse
  Future<ActivityResponse> postActivity(String userId) async {
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
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return ActivityResponse.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to post activity: ${response.statusCode}');
    }
  }

  Future<List<Activity>> fetchActivities() {
    return _apiService.fetchActivities();
  }

  Future<Activity?> fetchActivity(String id) async {
    final String apiUrl = "$baseUrl/api/activity/$id"; // Fixed URL construction
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $staticToken',
          'Accept': 'application/json',
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

// Add this model class for the POST response
class ActivityResponse {
  final bool success;
  final String message;
  final User user;
  final Activity activity;

  ActivityResponse({
    required this.success,
    required this.message,
    required this.user,
    required this.activity,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['user']),
      activity: Activity.fromJson(json['activity']),
    );
  }
}