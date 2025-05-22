import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SecurityModel {
  final String id;
  final String fullname;
  final String email;
  final String date;
  final String status;
  final String? idcard;
  final String role;

  SecurityModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.date,
    this.idcard,
    required this.status,
    required this.role,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    final securityData = json['security'] as Map<String, dynamic>?;

    return SecurityModel(
      id: json['id'].toString(),
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      idcard: json['idcard']?.toString(),
      date: json['created_at']?.toString() ?? '21192-1',
      status: securityData?['status'] ?? json['status'] ?? 'active',
      role: json['role'] ?? 'security_guard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'idcard': idcard,
      'status': status,
      'role': 'security_guard',
    };
  }
}

class SecuritiesTeam extends StatefulWidget {
  const SecuritiesTeam({super.key});

  @override
  State<SecuritiesTeam> createState() => _SecuritiesTeamState();
}

class _SecuritiesTeamState extends State<SecuritiesTeam> {
  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color primaryGreen = Color(0xFF2E8B57);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);

  static const String baseUrl = 'https://pse-parking.final25.psewmad.org';
  static const String apiToken =
      '3|vufyxvd6e9qy0nVcUKpGVk9N3Y5gKV34oGfq8HAR605d44f1';

  List<SecurityModel> securities = [];
  bool isLoading = true;
  String? errorMessage;

  // Form controllers
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSecurities();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _idcardController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Add an error handling method
  void _handleApiError(dynamic error) {
    setState(() {
      if (error is http.ClientException) {
        errorMessage = 'Network error: ${error.message}';
      } else {
        errorMessage = 'Error: $error';
      }
      isLoading = false;
    });

    // Log the error for debugging
    debugPrint('API Error: $error');
  }

  // API Methods
  Future<void> fetchSecurities() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/security'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('API Response: ${response.body}');

        final dynamic responseData = json.decode(response.body);
        List<dynamic> data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          // Response is a Map with a 'data' key containing the list
          data = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          // Response is directly a list
          data = responseData;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }

        setState(() {
          securities =
              data
                  .map(
                    (item) =>
                        SecurityModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load securities. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      _handleApiError(e);
    }
  }

  Future<void> addSecurity(
    String fullname,
    String email,
    String idcard,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/security'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: json.encode({
          'fullname': fullname,
          'email': email,
          'idcard': idcard,
          'password': password,
          'role': 'security_guard',
          'status': 'active',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Refresh securities list
        fetchSecurities();
      } else {
        // Try to parse error message from the response
        try {
          final errorData = json.decode(response.body);
          setState(() {
            errorMessage =
                errorData['message'] ??
                'Failed to add security. Status code: ${response.statusCode}';
          });
        } catch (e) {
          setState(() {
            errorMessage =
                'Failed to add security. Status code: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      _handleApiError(e);
    }
  }

  Future<void> deleteSecurityById(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/security/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Refresh securities list
        fetchSecurities();
      } else {
        setState(() {
          errorMessage =
              'Failed to delete security. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      _handleApiError(e);
    }
  }

  Future<void> updateSecurityStatus(String id, String status) async {
    try {
      final security = securities.firstWhere((element) => element.id == id);

      final response = await http.put(
        Uri.parse('$baseUrl/security/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: json.encode({
          'fullname': security.fullname,
          'email': security.email,
          'idcard': security.idcard,
          'role': security.role,
          'status': status.toLowerCase() == 'active' ? 'inactive' : 'active',
        }),
      );

      if (response.statusCode == 200) {
        // Refresh securities list
        fetchSecurities();
      } else {
        try {
          final errorData = json.decode(response.body);
          setState(() {
            errorMessage =
                errorData['message'] ??
                'Failed to update security status. Status code: ${response.statusCode}';
          });
        } catch (e) {
          setState(() {
            errorMessage =
                'Failed to update security status. Status code: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      _handleApiError(e);
    }
  }

  void _showAddSecurityForm() {
    // Reset form values
    _fullnameController.clear();
    _idcardController.clear();
    _emailController.clear();
    _passwordController.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Add New Security',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _fullnameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: textLight),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _idcardController,
                    decoration: const InputDecoration(
                      labelText: 'ID Card',
                      labelStyle: TextStyle(color: textLight),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: textLight),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: textLight),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: primaryOrange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Status will be set to Active',
                        style: TextStyle(
                          color: textLight,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: textLight)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                onPressed: () {
                  if (_fullnameController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _idcardController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    addSecurity(
                      _fullnameController.text,
                      _emailController.text,
                      _idcardController.text,
                      _passwordController.text,
                    );
                    Navigator.pop(context);
                  } else {
                    // Show validation error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Securities Team',
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecuritiesTeamHeader(),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(color: primaryBlue),
                        )
                        : securities.isEmpty
                        ? const Center(child: Text('No securities found'))
                        : ListView.builder(
                          itemCount: securities.length,
                          itemBuilder:
                              (context, index) =>
                                  _buildSecurityItem(securities[index]),
                        ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        onPressed: _showAddSecurityForm,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSecuritiesTeamHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Text(
              'Employee',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textDark,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textDark,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 40), // Space for actions
        ],
      ),
    );
  }

  Widget _buildSecurityItem(SecurityModel security) {
    final bool isActive = security.status.toLowerCase() == 'active';
    final Color statusColor = isActive ? primaryOrange : primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      security.fullname.isNotEmpty ? security.fullname[0] : '?',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 101, 199, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        security.fullname,
                        style: const TextStyle(
                          fontSize: 20,
                          color: textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      if (security.idcard != null)
                        Text(
                          'ID: ${security.idcard}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textLight,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => updateSecurityStatus(security.id, security.status),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  security.status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(security),
            tooltip: 'Delete Security',
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(SecurityModel security) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Security'),
            content: Text(
              'Are you sure you want to delete ${security.fullname}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  deleteSecurityById(security.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
