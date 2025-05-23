class UserpModel {
  final String id;
  final String fullname;
  final String idcard;
  final String email;
  final String phonenumber;
  final String vehicletype;
  final String licenseplate;
  final String profilephoto;
  final String vehiclephoto;

  UserpModel({
    required this.id,
    required this.fullname,
    required this.idcard,
    required this.email,
    required this.phonenumber,
    required this.vehicletype,
    required this.licenseplate,
    required this.profilephoto,
    required this.vehiclephoto,
  });

  factory UserpModel.fromJson(Map<String, dynamic> json) {
    return UserpModel(
      id: json['id']?.toString() ?? '',
      fullname: json['fullname'] ?? '',
      idcard: json['idcard'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      vehicletype: json['vehicletype'] ?? '',
      licenseplate: json['licenseplate'] ?? '',
      profilephoto: json['profilephoto'] ?? '',
      vehiclephoto: json['vehiclephoto'] ?? '',
    );
  }

  get profile => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'idcard': idcard,
      'email': email,
      'phonenumber': phonenumber,
      'vehicletype': vehicletype,
      'licenseplate': licenseplate,
      'profilephoto': profilephoto,
      'vehiclephoto': vehiclephoto,
    };
  }
}