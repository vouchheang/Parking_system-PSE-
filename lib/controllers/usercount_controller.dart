import 'package:parking_system/models/checkin_out_model.dart';
import 'package:parking_system/models/usercount_model.dart';
import 'package:parking_system/services/api_service.dart';

class UserCountController {
  final ApiService _apiService = ApiService();
  Future<UserCount?> fetchUserCount() {
    return _apiService.fetchUserCount();
  }

  Future<TodayActionCount?> fetchTodayActionCount() {
    return _apiService.fetchTodayActionCount();
  }
}
