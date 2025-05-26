class OtpResponse {
  final String message;
  final String status;

  OtpResponse({required this.message, required this.status});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}
