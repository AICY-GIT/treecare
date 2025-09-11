import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:tree_care/main.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  NetworkManager._internal();

  bool _isConnected = true;
  Timer? _noInternetTimer;
  bool _dialogShown = false;

  void init() {
    _checkInternet();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((_) {
      _checkInternet();
    });
  }

  Future<bool> _hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;

    if (kIsWeb) {
      return true; // Assume web has internet if connected
    }

    try {
      final result = await http
          .get(Uri.parse('https://google.com'))
          .timeout(const Duration(seconds: 30));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkInternet() async {
    bool previousStatus = _isConnected;
    _isConnected = await _hasInternet();

    if (previousStatus && !_isConnected) {
      _dialogShown = false;
      _noInternetTimer?.cancel();
      _noInternetTimer = Timer(const Duration(seconds: 30), () {
        if (!_dialogShown) _showDialog();
      });
    }

    if (!previousStatus && _isConnected) {
      _noInternetTimer?.cancel();
    }
  }

  void _showDialog() {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null && !_dialogShown) {
      _dialogShown = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please check your network settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
