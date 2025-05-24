class Activity {
  final int userId;
  final String action;

  Activity({
    required this.userId,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'action': action,
    };
  }
}
