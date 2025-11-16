import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const NewsDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'بدون عنوان';
    final body = data['body'] ?? data['excerpt'] ?? '';
    final imageUrl = (data['imageUrl'] ?? '') as String;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imageUrl.isNotEmpty)
                ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imageUrl, fit: BoxFit.cover)),
              const SizedBox(height: 12),
              Text(body, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
            ],
          ),
        ),
      ),
    );
  }
}
