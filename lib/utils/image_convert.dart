import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageUtils {
  static Widget plantImage(String? base64Image, {double size = 100}) {
    if (base64Image == null || base64Image.isEmpty) {
      return Image.asset(
        "assets/icons/logo.png",
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    try {
      Uint8List bytes = base64Decode(base64Image);
      return Image.memory(
        bytes,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Image.asset(
        "assets/icons/logo.png",
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
  }
}
