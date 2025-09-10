import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_care/authentication/login_screen.dart';
import 'package:tree_care/models/plant_net_model.dart';
import 'package:tree_care/scan/result_botton_sheet.dart';
import 'package:tree_care/services/plant_net_service.dart';
import 'package:tree_care/utils/dialogs.dart';

class ScanScreenNoAuth extends StatefulWidget {
  const ScanScreenNoAuth({super.key});

  @override
  State<ScanScreenNoAuth> createState() => _ScanScreenNoAuthState();
}

class _ScanScreenNoAuthState extends State<ScanScreenNoAuth> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final PlantNetService _plantNetService =PlantNetService();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      try {
        setState(() => _imageFile = File(pickedFile.path));
        Popup.showLoading(context);
        final results = await _plantNetService.identifyPlant(_imageFile!);
        if(!mounted) return;
        Popup.hideLoading(context);
        _showResultsBottomSheet(results);
      } catch (e) {
        if (!mounted) return;
        Popup.hideLoading(context);
        Popup.showErrorPopup(context, e.toString());
      }
    }
  }

 void _showResultsBottomSheet(List<PlantIdentification> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ResultBottomSheet(results: results),
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
                _openFileBtn(context),
                const Spacer(),
                _loginBtn(context),
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LoginPage()),
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

  Padding _openFileBtn(BuildContext context) {
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
