import 'package:flutter/material.dart';
import 'package:tree_care/authentication/forgot_password_screen.dart';
import 'package:tree_care/authentication/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Error
  String? usernameError;
  String? passwordError;

  // Regex
  final RegExp usernameReg = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  // Username 3-20 characters, only letters, numbers, _
  final RegExp passwordReg =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
  // Password ≥8 characters, has uppercase, lowercase, number, special character

  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  _userName(),
                  const SizedBox(height: 16),
                  _password(),
                  const SizedBox(height: 24),
                  _signInButton(),
                  const SizedBox(height: 24),
                  _register(),
                  _forgotPassword(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _signInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _validateAndSignIn,
        child: const Text('Sign in', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Column _forgotPassword() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage(),
              ),
            );
          },
          child: const Text(
            "Forgot password",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Column _register() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: const Text(
            "Don't have an account, register now",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Column _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password',
            style: TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 8),
        _inputBox(
          controller: passwordController,
          hint: "Enter your password",
          obscureText: _isPasswordVisible,
          errorText: passwordError,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ],
    );
  }

  Column _userName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username',
            style: TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 8),
        _inputBox(
          controller: usernameController,
          hint: "Enter your username",
          errorText: usernameError,
        ),
      ],
    );
  }

  // Input Box Widget
  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              hintText: hint,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
      ],
    );
  }

  // Validate
  void _validateAndSignIn() {
    setState(() {
      usernameError = usernameReg.hasMatch(usernameController.text)
          ? null
          : "UUsername 3-20 characters, only letters, numbers, _";

      passwordError = passwordReg.hasMatch(passwordController.text)
          ? null
          : "Password ≥8 characters, has uppercase, lowercase, number, special character";
    });

    if (usernameError == null && passwordError == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Log in successful!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Sign in'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
