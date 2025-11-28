import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/app_user.dart';


class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إنشاء مستخدم جديد
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // تحديث بيانات مستخدم
  Future<void> updateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  // الحصول على بيانات مستخدم
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }
}
  