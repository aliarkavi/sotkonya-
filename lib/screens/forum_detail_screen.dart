import 'package:flutter/material.dart';


class ForumDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ForumDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'بدون عنوان';
    final body = data['body'] ?? data['excerpt'] ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Text(body)),
      ),
    );
  }
}
