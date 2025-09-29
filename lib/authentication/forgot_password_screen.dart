import 'package:flutter/material.dart';
import 'package:tree_care/authentication/register_screen.dart';
import 'package:tree_care/services/firebase_auth_service.dart';
import 'package:tree_care/widgets/custom_input_box.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controllers
  final TextEditingController emailController = TextEditingController();

  // Firebase
  final AuthService _authService = AuthService();

  // Error
  String? emailError;

  // Dispose controllers when not needed
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
                  _email(),
                  const SizedBox(height: 24),
                  _forgotPasswordButton(),
                  const SizedBox(height: 24),
                  _register(),
                  _signIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Forgot Password'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  SizedBox _forgotPasswordButton() {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          setState(() {
            emailError = null;
          });
          final email = emailController.text.trim();
          try {
            await _authService.resetPassword(email);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Password reset email sent. Please check your inbox."),
              ),
            );
            Navigator.pop(context); // Back to login screen
          } catch (e) {
            setState(() {
              emailError = e.toString();
            });
          }
        },
        child: const Text('Forgot Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
      ),
    );
  }

  Column _signIn() {
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
            "Already have an account, sign in",
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

  Column _email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email', style: TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 8),
        CustomInputBox(
          controller: emailController,
          hint: "Enter your email",
          errorText: emailError,
        ),
      ],
    );
  }
}
