class UserpModel {
  final String fullname;
  final String email;
  final String? password; // Made nullable since it's not in the response
  final String phonenumber;
  final String idcard;
  final String vehicletype;
  final String licenseplate;
  final String profilephoto;
  final String vehiclephoto;

  UserpModel({
    required this.fullname,
    required this.email,
    this.password, // Nullable
    required this.phonenumber,
    required this.idcard,
    required this.vehicletype,
    required this.licenseplate,
    required this.profilephoto,
    required this.vehiclephoto,
  });

  factory UserpModel.fromJson(Map<String, dynamic> json) {
    // Handle nested structure from response
    final user = json['user'] ?? {};
    final profile = json['profile'] ?? {};

    return UserpModel(
      fullname: user['fullname'] ?? '',
      email: user['email'] ?? '',
      password: null, // Password is not returned in response
      phonenumber: profile['phonenumber'] ?? '',
      idcard: user['idcard'] ?? '',
      vehicletype: profile['vehicletype'] ?? '',
      licenseplate: profile['licenseplate'] ?? '',
      profilephoto: profile['profilephoto'] ?? '',
      vehiclephoto: profile['vehiclephoto'] ?? '',
    );
  }
  get profile => null;

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
      'idcard': idcard,
      'vehicletype': vehicletype,
      'licenseplate': licenseplate,
      'profilephoto': profilephoto,
      'vehiclephoto': vehiclephoto,
    };
  }
}
