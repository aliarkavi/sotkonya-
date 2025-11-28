

import 'package:cloud_firestore/cloud_firestore.dart';

class NewsItem {
  final String id;
  final String title;
  final String subtitle;
  final String content; // النص الكامل للخبر
  final String imageUrl; // صورة الخبر
  final DateTime createdAt;

  NewsItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
  });

  factory NewsItem.fromMap(String id, Map<String, dynamic> map) {
    return NewsItem(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
