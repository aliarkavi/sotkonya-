class YurtItem {
  final String id;
  final String title;
  final String status;
  final String personelData;
  final String rentData;
  final String location;
  final String phone;
  final String mapUrl;

  YurtItem({
    required this.id,
    required this.title,
    required this.status,
    required this.personelData,
    required this.rentData,
    required this.location,
    required this.phone,
    required this.mapUrl,
  });

  factory YurtItem.fromMap(String id, Map<String, dynamic> map) {
    return YurtItem(
      id: id,
      title: map['title'] ?? '',
      status: map['status'] ?? '',
      personelData: map['personelData'] ?? '',
      rentData: map['rentData'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      mapUrl: map['mapUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status,
      'personelData': personelData,
      'rentData': rentData,
      'location': location,
      'phone': phone,
      'mapUrl': mapUrl,
    };
  }
}

