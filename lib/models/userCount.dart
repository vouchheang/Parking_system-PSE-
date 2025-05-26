// lib/models/user_count_model.dart
class UserCount {
  final int count;

  UserCount({required this.count});

  factory UserCount.fromJson(Map<String, dynamic> json) {
    final countValue = json['data'] != null ? json['data']['count'] : json['count'];
    if (countValue == null) {
      throw Exception('Count field is missing in JSON: $json');
    }
    final int count = countValue is String
        ? int.parse(countValue)
        : countValue is num
            ? countValue.toInt()
            : countValue;
    return UserCount(count: count);
  }
}