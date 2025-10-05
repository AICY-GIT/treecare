import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageUtils {
  static Widget plantImage(
    String? base64Image, {
    double size = 100,
    double borderRadius = 16,
    bool isCircle = false,
  }) {
    Widget imageWidget;

    if (base64Image == null || base64Image.isEmpty) {
      imageWidget = Image.asset(
        "assets/icons/logo.png",
        fit: BoxFit.cover,
      );
    } else {
      try {
        Uint8List bytes = base64Decode(base64Image);
        imageWidget = Image.memory(
          bytes,
          fit: BoxFit.cover,
        );
      } catch (e) {
        imageWidget = Image.asset(
          "assets/icons/logo.png",
          fit: BoxFit.cover,
        );
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }
}
