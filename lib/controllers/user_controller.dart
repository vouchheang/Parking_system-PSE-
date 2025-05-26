import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/services/api_service.dart';

class UserController {
  final ApiService _apiService = ApiService();
  Future<List<UserModel>> fetchUsers() {
    return _apiService.fetchUsers();
  }
}
