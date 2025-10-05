import 'package:flutter/material.dart';
import 'package:tree_care/services/firebase/auth_service.dart';
import 'package:tree_care/utils/validators.dart';
import 'package:tree_care/widgets/custom_input_box.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // Controllers
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  // Password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Error messages
  String? _errorCurrentPassword;
  String? _errorNewPassword;
  String? _errorConfirmPassword;

  // Dispose controllers when not needed
  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
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
                  _currentPassword(),
                  const SizedBox(height: 16),
                  _newPassword(),
                  const SizedBox(height: 16),
                  _newConfirmPassword(),
                  const SizedBox(height: 24),
                  _changeButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _newConfirmPassword() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Confirm Password',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        CustomInputBox(
          controller: _confirmController,
          hint: "Confirm your password",
          obscureText: !_isConfirmPasswordVisible,
          errorText: _errorConfirmPassword,
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

  Column _newPassword() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'New Password',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        CustomInputBox(
          controller: _newController,
          hint: "Enter your new password",
          obscureText: !_isNewPasswordVisible,
          errorText: _errorNewPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              });
            },
          ),
        ),
      ],
    );
  }

  Column _currentPassword() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current Password',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        CustomInputBox(
          controller: _currentController,
          hint: "Enter your current password",
          obscureText: !_isCurrentPasswordVisible,
          errorText: _errorCurrentPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _isCurrentPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
              });
            },
          ),
        ),
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Change Password'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  SizedBox _changeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _changePassword,
        child: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Handle password change by validating inputs and calling AuthService
  Future<void> _changePassword() async {
    setState(() {
      _errorCurrentPassword =
          Validators.password(_currentController.text.trim());
      _errorNewPassword = Validators.password(_newController.text.trim());
      _errorConfirmPassword = Validators.confirmPassword(
        _newController.text.trim(),
        _confirmController.text.trim(),
      );
    });

    if (_errorNewPassword != null || _errorConfirmPassword != null) {
      return;
    }

    try {
      await AuthService().changePassword(
        currentPassword: _currentController.text.trim(),
        newPassword: _newController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed, please login again")),
        );
        await AuthService().logOut(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    }
  }
}
