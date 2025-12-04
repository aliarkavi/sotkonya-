// lib/model/yurt_model.dart
class YurtModel {
  final String id;
  final String title;
  final String durum;        // الحالة
  final String fiyat;        // الإيجار
  final String personelData; // معلومات التواصل (مختصرة / شخص مسؤول)
  final String konum;        // الموقع النصي
  final String konumLink;    // رابط الخريطة
  final String telefone;     // رقم الهاتف
  final String details;      // وصف / نبذة عن السكن
  final List<String> images; // روابط أو مسارات صور

  YurtModel({
    required this.id,
    required this.title,
    required this.durum,
    required this.fiyat,
    required this.personelData,
    required this.konum,
    required this.konumLink,
    required this.telefone,
    required this.details,
    required this.images,
  });

  factory YurtModel.fromMap(String id, Map<String, dynamic> map) {
    return YurtModel(
      id: id,
      title: map['title'] ?? '',
      durum: map['durum'] ?? '',
      fiyat: map['fiyat'] ?? '',
      personelData: map['personelData'] ?? '',
      konum: map['konum'] ?? '',
      konumLink: map['konumLink'] ?? '',
      telefone: map['telefone'] ?? '',
      details: map['details'] ?? '',
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'durum': durum,
      'fiyat': fiyat,
      'personelData': personelData,
      'konum': konum,
      'konumLink': konumLink,
      'telefone': telefone,
      'details': details,
      'images': images,
    };
  }

  YurtModel copyWith({
    String? id,
    String? title,
    String? durum,
    String? fiyat,
    String? personelData,
    String? konum,
    String? konumLink,
    String? telefone,
    String? details,
    List<String>? images,
  }) {
    return YurtModel(
      id: id ?? this.id,
      title: title ?? this.title,
      durum: durum ?? this.durum,
      fiyat: fiyat ?? this.fiyat,
      personelData: personelData ?? this.personelData,
      konum: konum ?? this.konum,
      konumLink: konumLink ?? this.konumLink,
      telefone: telefone ?? this.telefone,
      details: details ?? this.details,
      images: images ?? this.images,
    );
  }
}
