import 'package:flutter/material.dart';
import 'package:tree_care/authentication/login_screen.dart';
import 'package:tree_care/services/firebase/auth_service.dart';
import 'package:tree_care/utils/validators.dart';
import 'package:tree_care/widgets/custom_input_box.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Firebase
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Error
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;
  String? emailError;

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  // Dispose controllers when not needed
  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  _fullName(),
                  const SizedBox(height: 16),
                  _userName(),
                  const SizedBox(height: 16),
                  _password(),
                  const SizedBox(height: 24),
                  _confirmPassword(),
                  const SizedBox(height: 24),
                  _email(),
                  const SizedBox(height: 48),
                  _registerButton(),
                  const SizedBox(height: 24),
                  _signIn(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _fullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Full Name',
            style: TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 8),
        CustomInputBox(
          controller: fullNameController,
          hint: "Enter your full name",
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
        CustomInputBox(
          controller: usernameController,
          hint: "Enter your username",
          errorText: usernameError,
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
        CustomInputBox(
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

  Column _confirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Confirm Password',
            style: TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 8),
        CustomInputBox(
          controller: confirmPasswordController,
          hint: "Enter your confirm password",
          obscureText: _isConfirmPasswordVisible,
          errorText: confirmPasswordError,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
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

  SizedBox _registerButton() {
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
        onPressed: _validateAndRegister,
        child: const Text('Register', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Column _signIn(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text("Already have an account, sign in",
              style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  // Handle registration by validating inputs and calling AuthService
  Future<void> _validateAndRegister() async {
    setState(() {
      usernameError = Validators.username(usernameController.text);
      passwordError = Validators.password(passwordController.text);
      confirmPasswordError = Validators.confirmPassword(
        passwordController.text,
        confirmPasswordController.text,
      );
      emailError = Validators.email(emailController.text);
    });

    if (usernameError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        emailError == null) {
      setState(() => _isLoading = true);

      try {
        await _authService.registerUser(
          fullName: fullNameController.text.trim(),
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Register successful")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
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
      title: const Text('Register'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
