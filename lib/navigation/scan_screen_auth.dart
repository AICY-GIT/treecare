import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

import 'package:tree_care/authentication/login_screen.dart';

class ScanScreenAuth extends StatefulWidget {
  const ScanScreenAuth({super.key});

  @override
  State<ScanScreenAuth> createState() => _ScanScreenAuthState();
}

class _ScanScreenAuthState extends State<ScanScreenAuth> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      _showLoadingPopup();
      await Future.delayed(const Duration(seconds: 1));
      final isSuccess = Random().nextBool();
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (isSuccess) {
        _showSuccessPopup(
          scientificName: 'Ficus lyrata',
          commonName: 'Fiddle Leaf Fig',
          confidence: 0.87,
          suggestions: const [
            {
              'latin_name': 'Ficus benjamina',
              'common_name': 'Weeping Fig',
              'score': 0.65
            },
            {
              'latin_name': 'Ficus elastica',
              'common_name': 'Rubber Plant',
              'score': 0.52
            },
          ],
        );
      } else {
        _showErrorPopup();
      }
    }
  }

  void _showLoadingPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.green)),
    );
  }

  void _showSuccessPopup({
    required String scientificName,
    required String commonName,
    required double confidence,
    required List<Map<String, dynamic>> suggestions,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(scientificName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (commonName.isNotEmpty)
              Text(commonName,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text('Confidence: ${(confidence * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }

  void _showErrorPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error, color: Colors.red, size: 80),
            SizedBox(height: 10),
            Text('Something went wrong!')
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/temp_bg.png'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _scanBtn(size),
              const SizedBox(height: 20),
              const Spacer(),
              Row(children: [
                _openFilebtn(context),
                const Spacer(),
                _loginBtn(context), // This opens Login above the tabs
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Padding _loginBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, right: 20),
      child: ElevatedButton(
        onPressed: () {
          // IMPORTANT: push on ROOT navigator so the BottomNav is hidden
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.35, 50),
          backgroundColor: const Color.fromARGB(255, 195, 229, 244),
          elevation: 10,
          shadowColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Login',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }

  Padding _openFilebtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, left: 20),
      child: ElevatedButton(
        onPressed: () => _pickImage(ImageSource.gallery),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.35, 50),
          backgroundColor: const Color.fromARGB(255, 195, 229, 244),
          elevation: 10,
          shadowColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('File',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }

  Center _scanBtn(double size) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: const Color.fromARGB(255, 195, 229, 244),
            elevation: 10,
            shadowColor: Colors.grey,
          ),
          child: const Text('Scan',
              style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
      ),
    );
  }
}
