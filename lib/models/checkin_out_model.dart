class TodayActionCount {
  final String date;
  final int checkins;
  final int checkouts;

  TodayActionCount({
    required this.date,
    required this.checkins,
    required this.checkouts,
  });

  // Factory constructor to create an instance from JSON with type safety
  factory TodayActionCount.fromJson(Map<String, dynamic> json) {
    return TodayActionCount(
      date: json['date']?.toString() ?? '',
      checkins: _parseInt(json['checkins']),
      checkouts: _parseInt(json['checkouts']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? 0;
    }
    return 0;
  }

  // Convert to JSON if needed
  Map<String, dynamic> toJson() {
    return {'date': date, 'checkins': checkins, 'checkouts': checkouts};
  }
}
