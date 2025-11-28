import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;   // تمت الإضافة

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,   // تمت الإضافة
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,      // تمت الإضافة
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 237, 234, 242),
            hintText: "أدخل $label",
            hintStyle: TextStyle(color: Colors.grey.shade900, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}
