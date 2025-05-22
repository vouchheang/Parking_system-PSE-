class UserProfileModel {
  final String userId;
  final String vehicletype;
  final String licenseplate;
  final String profilephoto;
  final String vehiclephoto;

  UserProfileModel({
    required this.userId,
    required this.vehicletype,
    required this.licenseplate,
    required this.profilephoto,
    required this.vehiclephoto,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id'] ?? '',
      vehicletype: json['vehicletype'] ?? '',
      licenseplate: json['licenseplate'] ?? '',
      profilephoto: json['profilephoto'] ?? '',
      vehiclephoto: json['vehiclephoto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'vehicletype': vehicletype,
      'licenseplate': licenseplate,
      'profilephoto': profilephoto,
      'vehiclephoto': vehiclephoto,
    };
  }
}
class UserpModel {
  final String id;
  final String fullname;
  final String idcard;
  final String email;
  final UserProfileModel? profile;

  UserpModel({
    required this.id,
    required this.fullname,
    required this.idcard,
    required this.email,
    this.profile,
  });

  factory UserpModel.fromJson(Map<String, dynamic> json) {
    return UserpModel(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      idcard: json['idcard'] ?? '',
      email: json['email'] ?? '',
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'])
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

