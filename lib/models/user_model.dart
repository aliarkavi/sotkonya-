class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // visitor, user, admin
  final String major;
  final String gender; // male, female
  final String photoUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.major,
    required this.gender,
    required this.photoUrl,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'visitor',
      major: data['major'] ?? '',
      gender: data['gender'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'major': major,
      'gender': gender,
      'photoUrl': photoUrl,
    };
  }
}
