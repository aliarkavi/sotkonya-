// lib/model/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;

  final String title;
  final String? description;
  final String? location;
  final String? imageUrl;
  final String? registerUrl;
  final String? websiteUrl;
  final DateTime startDate;

  final String date;
  final String time;
  final String konum;
  final String konumLink;
  final String kayitLink;
  final String details;

  final int? registeredUsers;
  final int? maxRegisteredUsers;

  final List<String> images;
  final List<Map<String, String>>? eventTable;

  /// هل الفعالية مفعّل فيها التسجيل
  final bool allowRegister;

  /// هل الفعالية مأجورة
  final bool isPaid;

  /// رقم واتساب الأدمن
  final String adminPhone;

  /// مبلغ الأجرة
  final double feeAmount;

  /// العملة
  final String feeCurrency;

  /// ✅ حالة الفعالية (مفتوح – قريبًا – مكتمل – ملغي)
  final String durum;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    this.location,
    this.imageUrl,
    this.registerUrl,
    this.websiteUrl,
    DateTime? startDate,
    String? date,
    String? time,
    String? konum,
    String? konumLink,
    String? kayitLink,
    String? details,
    this.registeredUsers,
    this.maxRegisteredUsers,
    this.images = const <String>[],
    this.eventTable,
    this.allowRegister = false,
    this.isPaid = false,
    this.adminPhone = '',
    this.feeAmount = 0,
    this.feeCurrency = '₺',

    /// الجديد
    String? durum,
  })  : startDate = startDate ?? DateTime.now(),
        date = date ?? '',
        time = time ?? '',
        konum = konum ?? '',
        konumLink = konumLink ?? '',
        kayitLink = kayitLink ?? '',
        details = details ?? '',
        durum = (durum == null || durum.isEmpty) ? 'قريبًا' : durum;

  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? start;
    final rawStart = map['startDate'];
    if (rawStart is Timestamp) {
      start = rawStart.toDate();
    } else if (rawStart is DateTime) {
      start = rawStart;
    } else if (rawStart is String) {
      start = DateTime.tryParse(rawStart);
    }

    String? dateText;
    String? timeText;
    if (start != null) {
      dateText =
          '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';
      timeText =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    }

    final imagesList = (map['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    final tableList = map['eventTable'] as List<dynamic>?;
    List<Map<String, String>>? eventTable;
    if (tableList != null) {
      eventTable = tableList
          .whereType<Map>()
          .map((m) => m.map((key, value) => MapEntry(
                key.toString(),
                value.toString(),
              )))
          .toList();
    }

    final String? location =
        map['location'] as String? ?? map['konum'] as String?;
    final String? description =
        map['description'] as String? ?? map['details'] as String?;
    final String? registerUrl =
        map['registerUrl'] as String? ?? map['kayitLink'] as String?;
    final String? websiteUrl =
        map['websiteUrl'] as String? ?? map['konumLink'] as String?;

    final String effectiveDetails =
        (map['details'] as String?) ?? description ?? '';

    final String effectiveKonum = (map['konum'] as String?) ?? location ?? '';
    final String effectiveKonumLink =
        (map['konumLink'] as String?) ?? websiteUrl ?? '';
    final String effectiveKayitLink =
        (map['kayitLink'] as String?) ?? registerUrl ?? '';

    final List<String> effectiveImages = imagesList.isNotEmpty
        ? imagesList
        : (map['imageUrl'] != null
            ? <String>[map['imageUrl'].toString()]
            : <String>[]);

    final bool allowRegister = (map['allowRegister'] as bool?) ?? false;
    final bool isPaid = (map['isPaid'] as bool?) ?? false;
    final String adminPhone = (map['adminPhone'] as String?) ?? '';

    final double feeAmount =
        (map['feeAmount'] as num?)?.toDouble() ?? 0.0;
    final String feeCurrency =
        (map['feeCurrency'] as String?)?.trim().isNotEmpty == true
            ? map['feeCurrency']
            : '₺';

    /// الحالة
    final String durum =
        (map['durum'] as String?)?.trim().isNotEmpty == true
            ? map['durum']
            : 'قريبًا';

    return EventModel(
      id: id,
      title: (map['title'] as String?) ?? '',
      description: description,
      location: location,
      imageUrl: map['imageUrl'] as String?,
      registerUrl: registerUrl,
      websiteUrl: websiteUrl,
      startDate: start,
      date: (map['date'] as String?) ?? dateText ?? '',
      time: (map['time'] as String?) ?? timeText ?? '',
      konum: effectiveKonum,
      konumLink: effectiveKonumLink,
      kayitLink: effectiveKayitLink,
      details: effectiveDetails,
      registeredUsers: (map['registeredUsers'] as num?)?.toInt(),
      maxRegisteredUsers: (map['maxRegisteredUsers'] as num?)?.toInt(),
      images: effectiveImages,
      eventTable: eventTable,
      allowRegister: allowRegister,
      isPaid: isPaid,
      adminPhone: adminPhone,
      feeAmount: feeAmount,
      feeCurrency: feeCurrency,
      durum: durum,
    );
  }

  Map<String, dynamic> toMap() {
    final String effectiveDetails =
        details.isNotEmpty ? details : (description ?? '');
    final String effectiveKonum =
        konum.isNotEmpty ? konum : (location ?? '');
    final String effectiveKonumLink =
        konumLink.isNotEmpty ? konumLink : (websiteUrl ?? '');
    final String effectiveKayitLink =
        kayitLink.isNotEmpty ? kayitLink : (registerUrl ?? '');

    final List<String> imageList = images.isNotEmpty
        ? images
        : (imageUrl != null && imageUrl!.isNotEmpty
            ? <String>[imageUrl!]
            : <String>[]);

    return {
      'title': title,
      'description': description ?? effectiveDetails,
      'location': location ?? effectiveKonum,
      'imageUrl': imageUrl,
      'registerUrl': registerUrl,
      'websiteUrl': websiteUrl,
      'startDate': startDate,
      'date': date,
      'time': time,
      'konum': effectiveKonum,
      'konumLink': effectiveKonumLink,
      'kayitLink': effectiveKayitLink,
      'details': effectiveDetails,
      'registeredUsers': registeredUsers,
      'maxRegisteredUsers': maxRegisteredUsers,
      'images': imageList,
      'eventTable': eventTable,
      'allowRegister': allowRegister,
      'isPaid': isPaid,
      'adminPhone': adminPhone.trim(),
      'feeAmount': feeAmount,
      'feeCurrency':
          feeCurrency.trim().isEmpty ? '₺' : feeCurrency.trim(),
      'durum': durum.trim().isEmpty ? 'قريبًا' : durum.trim(),
    };
  }
}
