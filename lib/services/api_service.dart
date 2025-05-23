import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:parking_system/models/loginModel.dart';
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/userprofile_model.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  static const String staticToken = '5|KgzNsnVTbbIhyiLNpD0R2v4WodiQO5oG7NshHPP81d26615f';



  Future<UserpModel> registerUser({
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
    final url = Uri.parse('$baseUrl/api/register');

    // Prepare JSON body
    final body = {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
      'idcard': idcard,
      'vehicletype': vehicletype.toLowerCase(),
      'licenseplate': licenseplate,
      'profilephoto': profilephoto?.name ?? '', // Send filename or empty string
      'vehiclephoto': vehiclephoto?.name ?? '', // Send filename or empty string
    };

    // Log the request
    print('Sending registration request to: $url');
    print('Request Body: ${jsonEncode(body)}');

    // Send JSON request
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // Log the response
    print('Response Status: ${response.statusCode}');
  
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] ?? jsonResponse;
      return UserpModel.fromJson(data);
    } else {
      throw Exception('Failed to register user: ${response.statusCode} - ${response.body}');
    }
  }

  fetchUserProfile(String userId) {}

  Future<List<UserModel>> fetchUsers() async {
    // TODO: Implement the logic to fetch users
    throw UnimplementedError('fetchUsers() has not been implemented yet.');
  }
   Future<LoginModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/login');

    // Prepare JSON body
    final body = {
      'email': email,
      'password': password,
    };

    // Log the request
    print('Sending login request to: $url');
    print('Request Body: ${jsonEncode(body)}');

    // Send JSON request
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // Log the response
    print('Response Status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] ?? jsonResponse;
      return LoginModel.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
}
}