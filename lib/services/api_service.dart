import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/models/activity_model.dart';
import 'package:parking_system/models/checkin_out_model.dart';
import 'package:parking_system/models/registerModel.dart';
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

  Future<void> registerUser({
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
          'Authorization': 'Bearer token',
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

        // final data = jsonResponse['data'] ?? jsonResponse;
        final userData = RegisterResponseModel.fromJson(jsonResponse);
        await _storageService.saveToken(userData.accessToken);
        await _storageService.saveRole(userData.data.user.role);
        await _storageService.saveID(userData.data.user.id);

         
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
    try {
      final url = Uri.parse('$baseUrl/api/login');
      final body = {'email': email, 'password': password};

      print('POST $url');
      print('Body: $body');

      final response = await http.post(url, body: body);

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] ?? jsonResponse;

        final loginModel = LoginModel.fromJson(data);

        // Save token using StorageService
        final _storageService = StorageService();
        await _storageService.saveToken(loginModel.token);
        await _storageService.saveRole(loginModel.role);
        await _storageService.saveID(loginModel.id);

        return loginModel;
      } else {
        String errorMessage = 'Login failed';
        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (_) {}
        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
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
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
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
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/getbyid/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] ?? jsonResponse;

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

  // FIXED METHOD: Public method: gets profile, auto-checks for internet
  Future<UserpModel> getUserProfile(String id) async {
    print('ApiService: Getting user profile for ID: $id');

    final token = await _storageService.getToken();
    if (token == null) {
      print('ApiService: No token found');
      // Try to get from local storage
      final localProfile = await _storageService.loadProfileFromLocal();
      if (localProfile != null) {
        print('ApiService: Found local profile without token');
        return localProfile;
      }
      throw Exception('No token found and no local profile available');
    }

    final isOnline = await checkInternet();
    print('ApiService: Internet connection: $isOnline');

    if (isOnline) {
      try {
        print('ApiService: Fetching from API...');
        final profile = await fetchUserProfile(id);

        // Save to local storage for offline use
        await _storageService.saveProfileLocally(profile.toJson());
        print('ApiService: Profile fetched and saved locally');

        return profile;
      } catch (e) {
        print('ApiService: API fetch failed: $e');
        // If API fails, try local storage as fallback
        final localProfile = await _storageService.loadProfileFromLocal();
        if (localProfile != null) {
          print('ApiService: Using local profile as fallback');
          return localProfile;
        }
        throw Exception('API fetch failed and no local profile: $e');
      }
    } else {
      print('ApiService: No internet, using local storage');
      final localProfile = await _storageService.loadProfileFromLocal();
      if (localProfile != null) {
        return localProfile;
      }
      throw Exception("No internet connection and no offline profile found.");
    }
  }

  // FIXED METHOD: Internet check without unnecessary token check
  Future<bool> checkInternet() async {
    try {
      var result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print('Error checking internet connectivity: $e');
      return false;
    }
  }
}
