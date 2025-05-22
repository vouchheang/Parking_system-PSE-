import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/api_service.dart';

class UserProfileController {
  final ApiService _apiService = ApiService();

  Future<UserpModel> fetchUserProfile(String userId) {
    return _apiService.fetchUserProfile(userId);
  }
}

