import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const EventDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'بدون عنوان';
    final desc = data['description'] ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right, textDirection: TextDirection.rtl),
          const SizedBox(height: 12),
          Text(desc, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
        ]),
      ),
    );
  }
}
