import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(AppUser user) async {
    await users.doc(user.id).set(user.toMap());
  }

  Future<AppUser?> getUser(String id) async {
    final doc = await users.doc(id).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(AppUser user) async {
    await users.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await users.doc(id).delete();
  }

  /// Set a user's role (e.g., 'admin', 'moderator:news', 'user', 'banned')
  Future<void> updateUserRole(String id, String role) async {
    await users.doc(id).update({'role': role});
  }

  Future<List<AppUser>> getAllUsers() async {
    final snapshot = await users.get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }
}
