class LoginModel {
  final String id;
  final String fullname;
  final String email;
  final String phonenumber;
  final String idcard;
  final String vehicletype;
  final String licenseplate;
  final String? profilephoto;
  final String? vehiclephoto;
  final String token;
  final String role; // 🆕 Add this

  LoginModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.idcard,
    required this.vehicletype,
    required this.licenseplate,
    this.profilephoto,
    this.vehiclephoto,
    required this.token,
    required this.role, // 🆕 Include in constructor
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'].toString(),
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      idcard: json['idcard'] ?? '',
      vehicletype: json['vehicletype'] ?? '',
      licenseplate: json['licenseplate'] ?? '',
      profilephoto: json['profilephoto'],
      vehiclephoto: json['vehiclephoto'],
      token: json['token'] ?? '',
      role: json['role'] ?? '', // 🆕 Parse from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'idcard': idcard,
      'vehicletype': vehicletype,
      'licenseplate': licenseplate,
      'profilephoto': profilephoto,
      'vehiclephoto': vehiclephoto,
      'token': token,
      'role': role, // 🆕 Add to JSON output
    };
  }
}
