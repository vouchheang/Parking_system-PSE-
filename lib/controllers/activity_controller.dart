import 'package:parking_system/services/api_service.dart';

class ActivityController {
  final ApiService _apiService = ApiService();

  // Change method to accept userId string only
  Future<void> postActivity(String userId) {
    // Create a minimal Map with just user_id to send to API
    final Map<String, dynamic> body = {
      'user_id': userId,
    };

    return _apiService.postActivity(body as String);
  }
}
