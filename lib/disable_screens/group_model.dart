/*import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String photoUrl;
  final String ownerId;
  final List<String> admins;
  final List<String> members;
  final Timestamp createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.ownerId,
    required this.admins,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'ownerId': ownerId,
      'admins': admins,
      'members': members,
      'createdAt': createdAt,
    };
  }

  factory GroupModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return GroupModel(
      id: doc.id,
      name: (d['name'] ?? '') as String,
      photoUrl: (d['photoUrl'] ?? '') as String,
      ownerId: (d['ownerId'] ?? '') as String,
      admins: List<String>.from(d['admins'] ?? []),
      members: List<String>.from(d['members'] ?? []),
      createdAt: d['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }
}
*/