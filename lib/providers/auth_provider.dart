import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/app_user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _appUser; // بيانات Firestore
  User? _user;       // بيانات Firebase Auth

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  String? _error;
  bool _loading = false;

  bool _isAdmin = false; // 🔥 يتم تحديدها من Firestore
  bool get isAdmin => _isAdmin;

  User? get user => _user;
  AppUser? get appUser => _appUser;
  bool get loading => _loading;
  String? get error => _error;

  // ---------------------------------------------------------
  // 🔥 تسجيل دخول
  // ---------------------------------------------------------
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      // تسجيل الدخول من Firebase
      final u = await _authService.login(email: email, password: password);
      _setUser(u);

      // 🔥 جلب بيانات المستخدم من Firestore
      final firestoreUser = await _userService.getUser(u!.uid);

      _setAppUser(firestoreUser);

      // 🔥 التأكد من وجود المستخدم
      if (firestoreUser == null) {
        _isAdmin = false;
      } else {
        // 🔥 هل هو أدمن؟
        _isAdmin = (firestoreUser.role == "admin");

      }

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

      // حفظ بيانات Firebase
      _setUser(u);

      // حفظ بيانات Firestore مع ID
      _setAppUser(appUser.copyWith(id: u!.uid));

      // المستخدمين الجدد ليسوا إداريين
      _isAdmin = false;

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

    try {
      await _authService.logout();
      _setUser(null);
      _setAppUser(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 🌟 Internal Update Helpers
  // ---------------------------------------------------------
  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void _setAppUser(AppUser? appUser) {
    _appUser = appUser;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
