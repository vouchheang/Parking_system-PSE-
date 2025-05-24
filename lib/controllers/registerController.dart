import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class User {
  final String fullname;
  final String email;
  // Add other fields as needed

  User({required this.fullname, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      // Add other fields
    };
  }
}

class RegisterController {
  Future<User> registerUser({
    required String fullname,
    required String email,
    required String password,
    required String phonenumber,
    required String idcard,
    required String vehicletype,
    required String licenseplate,
    required XFile? profilephoto,
    required XFile? vehiclephoto,
  }) async {
    const String apiUrl = 'YOUR_API_ENDPOINT'; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add text fields
      request.fields['fullname'] = fullname;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['phonenumber'] = phonenumber;
      request.fields['idcard'] = idcard;
      request.fields['vehicletype'] = vehicletype;
      request.fields['licenseplate'] = licenseplate;

      // Add profile photo
      if (profilephoto != null) {
        if (kIsWeb) {
          final bytes = await profilephoto.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'profilephoto',
            bytes,
            filename: profilephoto.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'profilephoto',
            profilephoto.path,
            filename: profilephoto.name,
          ));
        }
      }

      // Add vehicle photo
      if (vehiclephoto != null) {
        if (kIsWeb) {
          final bytes = await vehiclephoto.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'vehiclephoto',
            bytes,
            filename: vehiclephoto.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'vehiclephoto',
            vehiclephoto.path,
            filename: vehiclephoto.name,
          ));
        }
      }

      // Send the request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(responseData.body);
        return User(
          fullname: jsonData['fullname'] ?? fullname,
          email: jsonData['email'] ?? email,
        );
      } else {
        throw Exception('Failed to register: ${responseData.body}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}