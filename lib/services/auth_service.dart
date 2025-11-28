import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotkonya/model/app_user.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// تسجيل دخول مستخدم عادي أو إداري
  Future<User?> login({required String email, required String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "حدث خطأ أثناء تسجيل الدخول";
    }
  }

  /// إنشاء حساب مستخدم جديد
  Future<User?> register({required AppUser user, required String password}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      final newUser = cred.user!;
      final appUser = user.copyWith(id: newUser.uid); // التأكد من تعيين الـ uid
      await UserService().createUser(appUser);
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "حدث خطأ أثناء التسجيل";
    }
  }

  /// إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "حدث خطأ أثناء إعادة تعيين كلمة المرور";
    }
  }

  /// تسجيل خروج
  Future<void> logout() async {
    await _auth.signOut();
  }
}
