import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/app_user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _appUser;    // من Firestore
  final AuthService _authService = AuthService();
  String? _error;
  bool _loading = false;
  User? _user;          // من Firebase Auth
  final UserService _userService = UserService();

  User? get user => _user;

  AppUser? get appUser => _appUser;

  bool get loading => _loading;

  String? get error => _error;

  /// تسجيل دخول
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final u = await _authService.login(email: email, password: password);
      _setUser(u);

      // 🔥 جلب بيانات المستخدم من Firestore
      final firestoreUser = await _userService.getUser(u!.uid);
      _setAppUser(firestoreUser);

    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// تسجيل مستخدم جديد
  Future<void> register(AppUser appUser, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final u = await _authService.register(user: appUser, password: password);
      _setUser(u);

      _setAppUser(appUser.copyWith(id: u!.uid));

    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  /// إعادة تعيين كلمة المرور
Future<void> resetPassword(String email) async { 
  _setLoading(true);
 _setError(null); try { 
  await _authService.resetPassword(email); } catch (e) { _setError(e.toString()); } finally { _setLoading(false); } }

  /// تسجيل خروج 
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

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void _setAppUser(AppUser? appUser) {
    _appUser = appUser;
    notifyListeners();
  }
}
