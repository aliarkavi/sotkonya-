import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إنشاء مستخدم جديد
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // تحديث بيانات مستخدم (✅ آمن حتى لو الدوك غير موجود)
  Future<void> updateUser(AppUser user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  // الحصول على بيانات مستخدم
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    // ✅ ضمان id الصحيح حتى لو غير مخزّن في الحقول
    return AppUser.fromMap({
      ...data,
      'id': doc.id,
    });
  }

  Future<List<AppUser>> getAllUsers() async {
    final snap = await _firestore.collection('users').get();
    return snap.docs
        .map((e) => AppUser.fromMap({
              ...e.data(),
              'id': e.id,
            }))
        .toList();
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _firestore.collection('users').doc(userId).set(
      {'role': role},
      SetOptions(merge: true),
    );
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
