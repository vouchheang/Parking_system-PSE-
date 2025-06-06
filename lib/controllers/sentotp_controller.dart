import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/otp_model.dart';
import 'package:parking_system/services/storage_service.dart';

final StorageService _storageService = StorageService();

class OtpController {
  Future<OtpResponse?> sendOtp({required String email}) async {
    final url = Uri.parse("https://pse-parking.final25.psewmad.org/api/otp");

    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
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

  Future<VerifyOtp?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final url = Uri.parse(
      "https://pse-parking.final25.psewmad.org/api/verify-otp",
    );
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VerifyOtp.fromJson(data);
      } else {
        ("HTTP Error: ${response.statusCode}");
        if (response.body.isNotEmpty) {
          try {
            final data = jsonDecode(response.body);
            return VerifyOtp.fromJson(data);
          } catch (e) {
            ("Failed to parse error response: $e");
          }
        }
        return VerifyOtp(message: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      ("Error: $e");
      return VerifyOtp(message: "Network error: $e");
    }
  }
}
