import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 130,
                ), // Increased space to push down content
                _buildIllustration(),
                const SizedBox(height: 40),
                _buildLoginHeader(),
                const SizedBox(height: 30),
                _buildLoginForm(),
                const SizedBox(height: 24),
                _buildLoginButton(),
                const SizedBox(height: 20),
              ],
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

  // Removed traffic cones and car methods as we're using an image asset instead

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
            hintText: '',
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
            hintText: '',
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
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
