import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventItem {
  final String id;
  final String title;        // عنوان الفعالية
  final String description;  // وصف/تفاصيل مختصرة أو كاملة
  final String location;     // مكان الفعالية
  final String imageUrl;     // صورة الفعالية (إن وجدت)
  final String registerUrl;  // رابط نموذج التسجيل (إن وجد)
  final String websiteUrl;   // رابط موقع أو صفحة الفعالية (إن وجد)
  final DateTime startDate;  // وقت بداية الفعالية

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.registerUrl,
    required this.websiteUrl,
    required this.startDate,
  });

  /// هل الفعالية قادمة؟
  bool get isUpcoming => startDate.isAfter(DateTime.now());

  /// تاريخ منسّق للعرض
  String get formattedDate {
    // مثال: 12 حزيران 2025
    return DateFormat('d MMMM yyyy', 'ar').format(startDate);
  }

  /// وقت منسّق للعرض
  String get formattedTime {
    // مثال: 10:30
    return DateFormat('HH:mm').format(startDate);
  }

  factory EventItem.fromMap(String id, Map<String, dynamic> map) {
    return EventItem(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      registerUrl: map['registerUrl'] ?? '',
      websiteUrl: map['websiteUrl'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
    );
  }

  String? get mapUrl => null;

  String get dateString => formattedDate;

  String get date => formattedDate;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'registerUrl': registerUrl,
      'websiteUrl': websiteUrl,
      'startDate': startDate,
    };
  }
}
