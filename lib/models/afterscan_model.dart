class AfterscanModel {
  final String id;
  final String fullname;
  final String email;
  final String idCard;
  final String licensePlate;

  AfterscanModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.idCard,
    required this.licensePlate,
  });

  factory AfterscanModel.fromJson(Map<String, dynamic> json) {
    return AfterscanModel(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      idCard: json['id_card'] ?? '',
      licensePlate: json['license_plate'] ?? '',
    );
  }
}
