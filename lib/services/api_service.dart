import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/models/checkin_out_model.dart';
import 'package:parking_system/models/usercount_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_system/models/loginModel.dart';
import 'package:parking_system/models/userlist_model.dart';
import 'package:parking_system/models/user_model.dart';
import 'package:parking_system/models/userprofile_model.dart';
import 'package:parking_system/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  final StorageService _storageService = StorageService();

  Future<UserCount?> fetchUserCount() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/count'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserCount.fromJson(data);
    } else {
      return null;
    }
  }

  Future<TodayActionCount?> fetchTodayActionCount() async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/today-actions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return TodayActionCount.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<List<Activity>> fetchActivities() async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/activities'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }


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

  try {
    // Upload images to Cloudinary and get URLs
    String? profilePhotoUrl;
    String? vehiclePhotoUrl;

    if (profilephoto != null) {
      profilePhotoUrl = await uploadImageToCloudinary(profilephoto);
    }
    if (vehiclephoto != null) {
      vehiclePhotoUrl = await uploadImageToCloudinary(vehiclephoto);
    }

    // Prepare the request body with Cloudinary URLs
    final body = {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
      'idcard': idcard,
      'vehicletype': vehicletype.toLowerCase(),
      'licenseplate': licenseplate,
      'profilephoto': profilePhotoUrl ?? '',
      'vehiclephoto': vehiclePhotoUrl ?? '',
    };

    // Only log the URL for debugging, not sensitive data
    print('Sending registration request to: $url');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $staticToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      
      // Handle token storage if present
      if (jsonResponse['access_token'] != null) {
        await _saveTokenToStorage(jsonResponse['access_token']);
      }
      
      // Log success without exposing sensitive data
      if (jsonResponse['success'] == true) {
        print('Registration successful for user: $fullname');
      }
      
      final data = jsonResponse['data'] ?? jsonResponse;
      return UserpModel.fromJson(data);
    } else {
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  } catch (e) {
    print('Registration error: $e');
    throw Exception('Error during registration: $e');
  }
}

// Private method to save token to SharedPreferences
Future<void> _saveTokenToStorage(String token) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Registration: Token saved to SharedPreferences successfully');
  } catch (e) {
    print('Registration: Error saving token to SharedPreferences: $e');
  }
}

  Future<String> uploadImageToCloudinary(XFile imageFile) async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/djl0qjlmt/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] =
          'flutter_unsigned'; // Ensure this preset exists in your Cloudinary account

    try {
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: imageFile.name),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
            filename: imageFile.name,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data['secure_url'];
      } else {
        print('Cloudinary upload failed: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Image upload failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<LoginModel> loginUser({
    required String email,
    required String password,
  }) async {
    final StorageService storageService = StorageService();

    try {
      final url = Uri.parse('$baseUrl/api/login');
      final body = jsonEncode({'email': email, 'password': password});
      print(url);
      print(body);
      final response = await http.post(
        url,
        body: {'email': email, 'password': password},
      );

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] ?? jsonResponse;

        final loginModel = LoginModel.fromJson(data);

        // Store the token using StorageService
        await storageService.saveToken(loginModel.token);

        return loginModel;
      } else {
        // More specific error handling
        String errorMessage = 'Login failed';
        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (e) {
          // If response body is not valid JSON, use default message
        }

        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      // Handle other types of errors (network issues, etc.)
      throw Exception('Network error: Unable to connect to server');
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] is List) {
        return (jsonResponse['data'] as List)
            .map((userJson) => UserModel.fromJson(userJson))
            .toList();
      } else {
        throw Exception('Invalid response format: data is not a list');
      }
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  Future<void> updateUserProfile(String id, UserpfModel user) async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        // success
      } else {
        throw Exception(responseData['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to update user profile: ${response.statusCode}');
    }
  }

  // Fetch user profile from API
  Future<UserpModel> fetchUserProfile(String id) async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] ?? jsonResponse;

      await _storageService.saveProfileLocally(data);
      return UserpModel.fromJson(data);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<void> postActivity(String userId) async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    final url = Uri.parse('$baseUrl/api/activities');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
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
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
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
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
