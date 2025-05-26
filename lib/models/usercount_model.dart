// models/user_count_model.dart
class UserCount {
  final bool success;
  final int totalUsers;

  UserCount({required this.success, required this.totalUsers});

  factory UserCount.fromJson(Map<String, dynamic> json) {
    return UserCount(
      success: json['success'],
      totalUsers: json['total_users'],
    );
  }
}
