class OtpResponse {
  final String message;
  final String status;

  OtpResponse({required this.message, required this.status});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(message: json['message'], status: json['status']);
  }
}

class VerifyOtp {
  final String? message;
  final int statusCode;

  VerifyOtp({this.message, this.statusCode = 200});

  factory VerifyOtp.fromJson(Map<String, dynamic> json) {
    return VerifyOtp(message: json['message']);
  }
}

