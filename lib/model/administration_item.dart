class AdministrationItem {
  final String id;
  final String title;
  final String job;
  final String aboutHim;
  final String email;
  final String phone;

  AdministrationItem({
    required this.id,
    required this.title,
    required this.job,
    required this.aboutHim,
    required this.email,
    required this.phone,
  });

  factory AdministrationItem.fromMap(String id, Map<String, dynamic> map) {
    return AdministrationItem(
      id: id,
      title: map['title'] ?? '',
      job: map['job'] ?? '',
      aboutHim: map['aboutHim'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'job': job,
      'aboutHim': aboutHim,
      'email': email,
      'phone': phone,
    };
  }
}

