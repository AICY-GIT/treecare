import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tree_care/services/firebase_auth_service.dart';
import 'package:tree_care/authentication/login_screen.dart';
import 'package:tree_care/navigation/change_password.dart';
import 'package:tree_care/widgets/card_settings.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final AuthService _authService = AuthService();
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No user logged in"));
    }

    final userRef = FirebaseDatabase.instance.ref("users/${user.uid}");

    return StreamBuilder<DatabaseEvent>(
      stream: userRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text("User data not found"));
        }

        final data = Map<String, dynamic>.from(
          snapshot.data!.snapshot.value as Map,
        );

        final fullName = data["fullName"] ?? "No name";
        final email = data["email"] ?? "No email";

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _fullName(fullName, context),
            const SizedBox(height: 12),
            _email(email),
            const SizedBox(height: 12),
            _lightMode(),
            const SizedBox(height: 24),
            _changePassword(context),
            const SizedBox(height: 24),
            _logOutButton(context),
          ],
        );
      },
    );
  }

  ElevatedButton _logOutButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: () async {
        try {
          await _authService.logOut(context);
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged out successfully"),
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout failed: $e")),
          );
        }
      },
      label: const Text("Logout"),
    );
  }

  CardSettings _changePassword(BuildContext context) {
    return CardSettings(
      icon: Icons.lock,
      title: "Change Password",
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChangePassword()),
        );
      },
    );
  }

  CardSettings _lightMode() {
    return CardSettings(
      icon: Icons.light_mode,
      title: "Light Mode",
      trailing: Switch(
        value: isSwitched,
        onChanged: (val) => setState(() => isSwitched = val),
        activeColor: Colors.green,
      ),
    );
  }

  CardSettings _email(email) {
    return CardSettings(
      icon: Icons.email,
      title: "Email",
      subtitle: email,
    );
  }

  CardSettings _fullName(fullName, BuildContext context) {
    return CardSettings(
      icon: Icons.person,
      title: "Fullname",
      subtitle: fullName,
      trailing: TextButton(
        onPressed: () {
          final controller = TextEditingController(text: fullName);
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text("Edit Fullname"),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                _editFullName(controller, dialogContext, context),
              ],
            ),
          );
        },
        child: const Text("Edit"),
      ),
    );
  }

  // Save edited fullname to Firebase
  ElevatedButton _editFullName(
    TextEditingController controller,
    BuildContext dialogContext,
    BuildContext pageContext,
  ) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await _authService.editFullName(controller.text.trim());
          if (mounted) {
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(pageContext).showSnackBar(
              const SnackBar(content: Text("Fullname updated")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(pageContext).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      },
      child: const Text("Save"),
    );
  }
}
