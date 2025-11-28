import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
