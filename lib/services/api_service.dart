import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_system/models/loginModel.dart';
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/userprofile_model.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  static const String staticToken = '5|KgzNsnVTbbIhyiLNpD0R2v4WodiQO5oG7NshHPP81d26615f';

  Future<List<UserModel>> fetchUsers() async {
    const String staticToken =
        '12|NRNLrtv7YXimpp9Dz5PQdZNrw8trWfJge9b9fsaXaf0b4e41';


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

  // Fetch user profile from API
  Future<UserpModel> fetchUserProfile(String id) async {
    const String staticToken =
        '12|NRNLrtv7YXimpp9Dz5PQdZNrw8trWfJge9b9fsaXaf0b4e41';
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

  Future<void> postActivity(String userId) async {
    final url = Uri.parse('$baseUrl/api/activities');
    const String staticToken =
        '12|NRNLrtv7YXimpp9Dz5PQdZNrw8trWfJge9b9fsaXaf0b4e41';

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Optionally parse response to show message
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        // success, you can show a snackbar or update UI
      } else {
        throw Exception(responseData['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to post activity');
    }
  }

  // Public method: gets profile, auto-checks for internet
  Future<UserpModel> getUserProfile(String id) async {
    final isOnline = await checkInternet();
    if (isOnline) {
      return await fetchUserProfile(id);
    } else {
      final localProfile = await _storageService.loadProfileFromLocal();
      if (localProfile != null) {
        return localProfile;
      }
      throw Exception("No offline profile found.");
    }
  }

  // Internet check
  Future<bool> checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
}