import 'package:flutter/material.dart';
import 'package:parking_system/controllers/LoginController.dart';
import 'package:parking_system/services/api_service.dart';
import 'package:parking_system/models/loginModel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(ApiService()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F7FD),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 130),
                  _buildIllustration(),
                  const SizedBox(height: 40),
                  _buildLoginHeader(),
                  const SizedBox(height: 30),
                  _buildLoginForm(),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 16),
                  _buildForgotPassword(),
                  const SizedBox(height: 20),
                  _buildTokenDisplay(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 250,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Image.asset('assets/images/splash.png', fit: BoxFit.contain),
    );
  }

  Widget _buildLoginHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2C7DA0),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Login to unlock your driving\ncompanion',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF116692),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email*',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF116692),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Password*',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF116692),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            if (controller.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                controller.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading
                ? null
                : () async {
                    final success = await controller.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login successful! Token: ${controller.authToken}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(controller.errorMessage ?? 'Login failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: controller.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Forgot Password feature not implemented yet.'),
          ),
        );
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF116692),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTokenDisplay() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        return controller.authToken != null
            ? Text(
                'Stored Token: ${controller.authToken}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF116692),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink();
      },
    );
  }
}