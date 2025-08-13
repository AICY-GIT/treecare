import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

import 'package:tree_care/authentication/login_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // this whole this is for shw, change when adding Pl@ntNet API service
      _showLoadingPopup(); //loading trong 4s
      await Future.delayed(const Duration(seconds: 4));

      // random thanh cong hay that bai (chua co service)
      bool isSuccess = Random().nextBool();
      Navigator.of(context).pop(); // tat loading screen

      if (isSuccess) {
        //fake plant info
        _showSuccessPopup(
          scientificName: "Ficus lyrata",
          commonName: "Fiddle Leaf Fig",
          confidence: 0.87,
          suggestions: [
            {
              "latin_name": "Ficus benjamina",
              "common_name": "Weeping Fig",
              "score": 0.65
            },
            {
              "latin_name": "Ficus elastica",
              "common_name": "Rubber Plant",
              "score": 0.52
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
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }

  void _showSuccessPopup(
      {required String scientificName,
      required String commonName,
      required double confidence,
      required List<Map<String, dynamic>> suggestions}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
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
            Text("Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 16)),
            if (suggestions.isNotEmpty) ...[
              const Divider(),
              const Text("Other possible matches:",
                  style: TextStyle(decoration: TextDecoration.underline)),
              ...suggestions.take(2).map((s) => Text(
                    "${s['common_name']?.isNotEmpty == true ? s['common_name'] : s['latin_name']} ${(s['score'] * 100).toStringAsFixed(1)}%",
                    textAlign: TextAlign.center,
                  )),
            ],
            const SizedBox(height: 10),
            const Text("Powered by Pl@ntNet",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error, color: Colors.red, size: 80),
            SizedBox(height: 10),
            Text("Something went wrong!", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Retry"),
            ),
          )
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
            image: AssetImage("assets/images/temp_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _scanBtn(size),
              const SizedBox(height: 20),
              const Spacer(),
              Row(
                children: [
                  _openFilebtn(context),
                  const Spacer(),
                  _loginBtn(context)
                ],
              )
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.35, 50),
          backgroundColor: const Color.fromARGB(255, 195, 229, 244),
          elevation: 10,
          shadowColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.login_rounded, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text("Login", style: TextStyle(fontSize: 20, color: Colors.black)),
          ],
        ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.folder_open_rounded, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text("File", style: TextStyle(fontSize: 20, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Center _scanBtn(double size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
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
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                "Scan",
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
