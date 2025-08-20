import 'package:flutter/material.dart';
import 'package:tree_care/authentication/login_screen.dart';

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

  // Error
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;
  String? emailError;

  // Regex
  final RegExp usernameReg = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  // Username 3-20 characters, only letters, numbers, _
  final RegExp passwordReg =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
  // Password ≥8 characters, has uppercase, lowercase, number, special character
  final RegExp emailReg = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,4}$');
  // Email format

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

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
        _inputBox(
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
        _inputBox(
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

  Column _confirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Confirm Password',
            style: TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 8),
        _inputBox(
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
        _inputBox(
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
  void _validateAndRegister() {
    setState(() {
      usernameError = usernameReg.hasMatch(usernameController.text)
          ? null
          : "Username 3-20 characters, only letters, numbers, _";

      passwordError = passwordReg.hasMatch(passwordController.text)
          ? null
          : "Password ≥8 characters, has uppercase, lowercase, number, special character";

      confirmPasswordError =
          confirmPasswordController.text == passwordController.text
              ? null
              : "Confirm password does not match";

      emailError = emailReg.hasMatch(emailController.text)
          ? null
          : "Email format is invalid";
    });

    if (usernameError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        emailError == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Registration successful!"),
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
