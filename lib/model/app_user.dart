class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String major;
  final String gender;
  final String photoUrl;
  final String phone;
  final String university;
  final String faculty;
  final String username;
  final int? age;
  final String studentNumber;
  final String studyYear;
  final String extraInfo;

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
    this.studentNumber = '',
    this.studyYear = '',
    this.extraInfo = '',
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
      'studentNumber': studentNumber,
      'studyYear': studyYear,
      'extraInfo': extraInfo,
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
    String? studentNumber,
    String? studyYear,
    String? extraInfo,
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
      studentNumber: studentNumber ?? this.studentNumber,
      studyYear: studyYear ?? this.studyYear,
      extraInfo: extraInfo ?? this.extraInfo,
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      major: map['major'] ?? '',
      gender: map['gender'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      phone: map['phone'] ?? '',
      university: map['university'] ?? '',
      faculty: map['faculty'] ?? '',
      username: map['username'] ?? '',
      age: (map['age'] as num?)?.toInt(),
      studentNumber: map['studentNumber'] ?? '',
      studyYear: map['studyYear'] ?? '',
      extraInfo: map['extraInfo'] ?? '',
    );
  }
}