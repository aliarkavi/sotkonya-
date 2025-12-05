class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;        // 🔥 هنا نحدد أدمن أو يوزر
  final String major;
  final String gender;
  final String photoUrl;
  final String phone;
  final String university;
  final String faculty;
  final String username;
  final int? age;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.major,
    required this.gender,
    required this.photoUrl,
    this.phone = '',
    this.university = '',
    this.faculty = '',
    this.username = '',
    this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'major': major,
      'gender': gender,
      'photoUrl': photoUrl,
      'phone': phone,
      'university': university,
      'faculty': faculty,
      'username': username,
      'age': age,
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? major,
    String? gender,
    String? photoUrl,
    String? phone,
    String? university,
    String? faculty,
    String? username,
    int? age,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      major: major ?? this.major,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      university: university ?? this.university,
      faculty: faculty ?? this.faculty,
      username: username ?? this.username,
      age: age ?? this.age,
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',     // 🔥 افتراضي User
      major: map['major'] ?? '',
      gender: map['gender'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      phone: map['phone'] ?? '',
      university: map['university'] ?? '',
      faculty: map['faculty'] ?? '',
      username: map['username'] ?? '',
      age: map['age'] != null ? (map['age'] as int) : null,
    );
  }
}
