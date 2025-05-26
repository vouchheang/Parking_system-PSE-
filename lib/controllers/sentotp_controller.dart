import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/otp_model.dart';

class OtpController {
  Future<OtpResponse?> sendOtp({required String email}) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<OtpResponse?> verifyOtp({
  required String email,
  required String otp,
}) async {
  final url = Uri.parse("http://127.0.0.1:8000/api/verify-otp");
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return OtpResponse.fromJson(data);
    } else {
      // Handle non-200 status codes
      print("HTTP Error: ${response.statusCode}");
      if (response.body.isNotEmpty) {
        try {
          final data = jsonDecode(response.body);
          return OtpResponse.fromJson(data);
        } catch (e) {
          print("Failed to parse error response: $e");
        }
      }
      return OtpResponse(
        message: "Server error: ${response.statusCode}",
        status: "error"
      );
    }
  } catch (e) {
    print("Error: $e");
    return OtpResponse(
      message: "Network error: $e",
      status: "error"
    );
  }
}
}
