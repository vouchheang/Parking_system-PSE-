class RegisterResponseModel {
  final bool success;
  final String message;
  final String accessToken;
  final String tokenType;
  final RegisterData data;

  RegisterResponseModel({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      data: RegisterData.fromJson(json['data'] ?? {}),
    );
  }
}

class RegisterData {
  final RegisterUser user;
  final RegisterProfile profile;

  RegisterData({
    required this.user,
    required this.profile,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: RegisterUser.fromJson(json['user'] ?? {}),
      profile: RegisterProfile.fromJson(json['profile'] ?? {}),
    );
  }
}

class RegisterUser {
  final String id;
  final String idcard;
  final String fullname;
  final String email;
  final String role;

  RegisterUser({
    required this.id,
    required this.idcard,
    required this.fullname,
    required this.email,
    required this.role,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      id: json['id'] ?? '',
      idcard: json['idcard'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class RegisterProfile {
  final String id;
  final String userId;
  final String vehicletype;
  final String licenseplate;
  final String phonenumber;
  final String profilephoto;
  final String vehiclephoto;

  RegisterProfile({
    required this.id,
    required this.userId,
    required this.vehicletype,
    required this.licenseplate,
    required this.phonenumber,
    required this.profilephoto,
    required this.vehiclephoto,
  });

  factory RegisterProfile.fromJson(Map<String, dynamic> json) {
    return RegisterProfile(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      vehicletype: json['vehicletype'] ?? '',
      licenseplate: json['licenseplate'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      profilephoto: json['profilephoto'] ?? '',
      vehiclephoto: json['vehiclephoto'] ?? '',
    );
  }
}
