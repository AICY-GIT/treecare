import 'package:flutter/material.dart';
import 'package:tree_care/navigation/change_password.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: const Color.fromARGB(255, 195, 229, 244),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.green),
                title: const Text("Fullname"),
                subtitle: const Text("Nguyen van A"),
                trailing: TextButton(
                  onPressed: () {
                    // TODO: implement Change Name
                  },
                  child: const Text("Edit"),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color.fromARGB(255, 195, 229, 244),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.green),
                title: const Text("Email"),
                subtitle: const Text("123@mail.com"),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color.fromARGB(255, 195, 229, 244),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text("Light Mode"),
                secondary: const Icon(Icons.light_mode, color: Colors.green),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: const Color.fromARGB(255, 195, 229, 244),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.green),
                title: const Text("Change Password"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChangePassword(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
