import 'package:flutter/material.dart';

class CustomInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final String? errorText;
  final Widget? suffixIcon;

  const CustomInputBox({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.errorText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              hintText: hint,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
      ],
    );
  }
}
