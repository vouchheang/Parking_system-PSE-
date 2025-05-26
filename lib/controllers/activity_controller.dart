import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/services/api_service.dart';

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
}
