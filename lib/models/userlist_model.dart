
class Profile {
  final String userId;
  final String licenseplate;

  Profile({
    required this.userId,
    required this.licenseplate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['user_id'] ?? '',
      licenseplate: json['licenseplate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'licenseplate': licenseplate,
    };
  }
}
  // Fields from the Profile table
class UserModel {
  final String id;
  final String fullname;
  final String idcard;
  final Profile? profile;

  UserModel({
    required this.id,
    required this.fullname,
    required this.idcard,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      idcard: json['idcard'] ?? '',
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'idcard': idcard,
      'profile': profile?.toJson(),
    };
  }
}
