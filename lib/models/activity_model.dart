class User {
  final String id;
  final String fullname;
  final String email;
  final String idcard;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.idcard,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      idcard: json['idcard'] ?? '',
    );
  }
}

class Activity {
  final String id;
  final String userId;
  final String action;
  final String createdAt;
  final User user;

  Activity({
    required this.id,
    required this.userId,
    required this.action,
    required this.createdAt,
    required this.user,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      action: json['action'] ?? '',
      createdAt: json['created_at'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}
