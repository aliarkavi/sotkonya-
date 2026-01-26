import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String subtitle;
  final String details;
  final String imageUrl;
  final List<String> images;

  /// تاريخ الخبر (يدخله الأدمن)
  final DateTime newsDate;

  /// تاريخ النشر التقني
  final DateTime createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.imageUrl,
    required this.images,
    required this.newsDate,
    required this.createdAt,
  });

  factory NewsModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime parse(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      return DateTime.now();
    }

    return NewsModel(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      details: map['content'] ?? map['details'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      newsDate: map['newsDate'] != null
          ? parse(map['newsDate'])
          : parse(map['createdAt']), // دعم الأخبار القديمة
      createdAt: parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'content': details,
      'imageUrl': imageUrl,
      'images': images,
      'newsDate': newsDate,
      'createdAt': createdAt,
    };
  }

  NewsModel copyWith({
    String? title,
    String? subtitle,
    String? details,
    String? imageUrl,
    List<String>? images,
    DateTime? newsDate,
  }) {
    return NewsModel(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      details: details ?? this.details,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      newsDate: newsDate ?? this.newsDate,
      createdAt: createdAt,
    );
  }
}
