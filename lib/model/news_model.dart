// lib/model/news_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String subtitle;
  final String details;     // النص الكامل للخبر
  final String imageUrl;    // صورة رئيسية
  final List<String> images; // صور للسلايدر
  final DateTime createdAt; // تاريخ النشر

  NewsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.imageUrl,
    required this.images,
    required this.createdAt,
  });

  factory NewsModel.fromMap(String id, Map<String, dynamic> map) {
    // دعم createdAt سواء Timestamp أو String أو null
    DateTime created;
    final createdRaw = map['createdAt'];
    if (createdRaw is Timestamp) {
      created = createdRaw.toDate();
    } else if (createdRaw is String) {
      created = DateTime.tryParse(createdRaw) ?? DateTime.now();
    } else {
      created = DateTime.now();
    }

    return NewsModel(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      // نحافظ على توافقية: لو كان في 'content' أو 'details'
      details: map['content'] ?? map['details'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      // نخزنها باسم 'content' عشان الداتا القديمة ما تنكسر
      'content': details,
      'imageUrl': imageUrl,
      'images': images,
      'createdAt': createdAt,
    };
  }

  NewsModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? details,
    String? imageUrl,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      details: details ?? this.details,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
