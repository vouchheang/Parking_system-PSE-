class UserpfModel {
  final String id;
  final String fullname;
  final String idcard;
  final String vehicletype;
  final String licenseplate;
  final String phonenumber;
  final String profilephoto;
  final String vehiclephoto;

  UserpfModel({
    required this.id,
    required this.fullname,
    required this.idcard,
    required this.vehicletype,
    required this.licenseplate,
    required this.phonenumber,
    required this.profilephoto,
    required this.vehiclephoto,
  });

  factory UserpfModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    return UserpfModel(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      idcard: json['idcard'] ?? '',
      vehicletype: profile['vehicletype'] ?? '',
      licenseplate: profile['licenseplate'] ?? '',
      phonenumber: profile['phonenumber'] ?? '',
      profilephoto: profile['profilephoto'] ?? '',
      vehiclephoto: profile['vehiclephoto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'idcard': idcard,
      'profile': {
        'vehicletype': vehicletype,
        'licenseplate': licenseplate,
        'phonenumber': phonenumber,
        'profilephoto': profilephoto,
        'vehiclephoto': vehiclephoto,
      },
    };
  }
}