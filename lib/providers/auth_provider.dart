import 'dart:async';
import 'dart:io'; // ✅ مطلوب للتعامل مع ملف الصورة
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // ✅ مطلوب لرفع الصور

import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../model/app_user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _appUser; // Firestore user doc
  User? _user; // FirebaseAuth user

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  String? _error;
  bool _loading = false;

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  User? get user => _user;
  AppUser? get appUser => _appUser;
  bool get loading => _loading;
  String? get error => _error;

  StreamSubscription<User?>? _authSub;

  AuthProvider() {
    // 🔥 مهم: هذا يجعل الجلسة "دائمة" + يعيد تحميل بيانات Firestore عند فتح التطبيق
    _authSub = FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _setError(null);

      // إذا صار logout / مافي مستخدم
      if (firebaseUser == null) {
        _user = null;
        _appUser = null;
        _isAdmin = false;
        notifyListeners();
        return;
      }

      // صار login أو session restored
      _user = firebaseUser;
      notifyListeners();

      // 🔥 جلب بيانات Firestore
      await _refreshUserFromFirestore(firebaseUser.uid);
    });
  }

  Future<void> _refreshUserFromFirestore(String uid) async {
    try {
      _setLoading(true);

      final firestoreUser = await _userService.getUser(uid);
      _appUser = firestoreUser;

      if (firestoreUser == null) {
        _isAdmin = false;
      } else {
        _isAdmin = (firestoreUser.role == "admin");
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 🔥 تسجيل دخول
  // ---------------------------------------------------------
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.login(email: email, password: password);
      // authStateChanges listener سيتكفل بكل شيء
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 🔥 تسجيل مستخدم جديد
  // ---------------------------------------------------------
  Future<void> register(AppUser appUser, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final u = await _authService.register(user: appUser, password: password);

      _user = u;
      _appUser = appUser.copyWith(id: u!.uid);
      _isAdmin = false;
      notifyListeners();

      // ثم نعيد مزامنة Firestore
      await _refreshUserFromFirestore(u.uid);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // ✅ تحديث ملف المستخدم (Firestore + Storage)
  // ---------------------------------------------------------
  Future<void> updateProfile(AppUser updatedUser, {File? imageFile}) async {
    _setLoading(true);
    _setError(null);

    try {
      final uid = _user?.uid;

      if (uid == null) {
        throw Exception("لا يوجد مستخدم مسجل دخول");
      }

      String finalPhotoUrl = updatedUser.photoUrl;

      // 🔥 رفع الصورة إلى Firebase Storage إذا تم اختيار صورة جديدة
      if (imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_photos')
            .child('$uid.jpg');

        await storageRef.putFile(imageFile);
        finalPhotoUrl = await storageRef.getDownloadURL();
      }

      // ضمان id الصحيح والرابط الجديد للصورة
      final toSave = updatedUser.copyWith(id: uid, photoUrl: finalPhotoUrl);

      // تحديث Firestore (يجب أن تكون موجودة في UserService)
      await _userService.updateUser(toSave);

      // تحديث محلي سريع
      _appUser = toSave;
      _isAdmin = (toSave.role == "admin");
      notifyListeners();

      // ثم مزامنة من Firestore (لضمان أي serverTimestamp أو تغيرات)
      await _refreshUserFromFirestore(uid);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 🔄 إعادة تعيين كلمة السر
  // ---------------------------------------------------------
  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 🚪 تسجيل خروج
  // ---------------------------------------------------------
  Future<void> logout() async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.logout();
      // listener سيلتقط firebaseUser=null
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}