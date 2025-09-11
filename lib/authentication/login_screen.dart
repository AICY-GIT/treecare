import 'package:flutter/material.dart';
import 'package:tree_care/authentication/forgot_password_screen.dart';
import 'package:tree_care/authentication/register_screen.dart';
import 'package:tree_care/navigation/bottom_nav.dart';
import 'package:tree_care/services/firebase_auth_service.dart';
import 'package:tree_care/services/secure_storage_service.dart';
import 'package:tree_care/utils/validators.dart';
import 'package:tree_care/widgets/custom_input_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.replaceStackOnSuccess = true});

  final bool replaceStackOnSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firebase
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Error
  String? usernameError;
  String? passwordError;

  // Secure Storage
  final SecureStorageService _secureStorage = SecureStorageService();
  bool _rememberSignIn = false;

  // Password visibility
  bool _obscurePassword = true;

  //Test
  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Dispose controllers when not needed
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Image.asset('assets/icons/logo.png', width: 150, height: 150),
                  const SizedBox(height: 32),
                  _userName(),
                  const SizedBox(height: 16),
                  _password(),
                  _rememberCheckBox(),
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

  Row _rememberCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberSignIn,
          onChanged: (val) {
            setState(() {
              _rememberSignIn = val ?? false;
            });
          },
        ),
        const Text("Remember Sign In", style: TextStyle(color: Colors.black)),
      ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _validateAndSignIn,
        child: const Text('Sign in', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Column _forgotPassword() {
    return Column(children: [
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
        },
        child: const Text('Forgot password',
            style: TextStyle(color: Colors.black)),
      ),
    ]);
  }

  Column _register() {
    return Column(children: [
      TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const RegisterPage()));
        },
        child: const Text("Don't have an account, register now",
            style: TextStyle(color: Colors.black)),
      ),
    ]);
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
          obscureText: _obscurePassword,
          errorText: passwordError,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
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
        CustomInputBox(
          controller: usernameController,
          hint: "Enter your username",
          errorText: usernameError,
        ),
      ],
    );
  }

  // Handle sign in by validating inputs and calling AuthService
  Future<void> _validateAndSignIn() async {
    setState(() {
      final input = usernameController.text.trim();
      if (Validators.username(input) != null &&
          Validators.email(input) != null) {
        usernameError = 'Enter a valid username or email';
      } else {
        usernameError = null;
      }
      passwordError = Validators.password(passwordController.text);
    });

    if (usernameError != null || passwordError != null) return;

    setState(() => _isLoading = true);

    try {
      final identifier = usernameController.text.trim();
      final password = passwordController.text.trim();

      final user = (Validators.email(identifier) == null)
          ? await _authService.loginWithEmail(identifier, password)
          : await _authService.loginWithUsername(identifier, password);

      if (user != null && context.mounted) {
        if (_rememberSignIn) {
          await _secureStorage.saveCredentials(
            usernameController.text.trim(),
            passwordController.text.trim(),
          );
        } else {
          await _secureStorage.clearCredentials();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavBar()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop()),
      title: const Text('Sign in'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Future<void> _loadSavedCredentials() async {
    final creds = await _secureStorage.getCredentials();
    if (creds['username'] != null && creds['password'] != null) {
      setState(() {
        usernameController.text = creds['username']!;
        passwordController.text = creds['password']!;
        _rememberSignIn = true;
      });
    }
  }
}
