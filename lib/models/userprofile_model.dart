class UserpModel {
  final String fullname;
  final String email;
  final String? password;
  final String phonenumber;
  final String idcard;
  final String vehicletype;
  final String licenseplate;
  final String profilephoto;
  final String vehiclephoto;

  UserpModel({
    required this.fullname,
    required this.email,
    this.password,
    required this.phonenumber,
    required this.idcard,
    required this.vehicletype,
    required this.licenseplate,
    required this.profilephoto,
    required this.vehiclephoto,
  });

  factory UserpModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};

    return UserpModel(
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      password: null,
      phonenumber: profile['phonenumber'] ?? '',
      idcard: json['idcard'] ?? '',
      vehicletype: profile['vehicletype'] ?? '',
      licenseplate: profile['licenseplate'] ?? '',
      profilephoto: profile['profilephoto'] ?? '',
      vehiclephoto: profile['vehiclephoto'] ?? '',
    );
  }

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