import 'package:flutter/material.dart';
import '../model/app_user.dart';
import '../services/user_service.dart';

class UsersProvider extends ChangeNotifier {
  final UserService _service = UserService();

  List<AppUser> _users = [];
  bool _loading = false;
  String _search = '';

  List<AppUser> get users {
    if (_search.isEmpty) return _users;
    final q = _search.toLowerCase();
    return _users.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q);
    }).toList();
  }

  bool get loading => _loading;

  Future<void> loadUsers() async {
    _loading = true;
    notifyListeners();

    _users = await _service.getAllUsers();

    _loading = false;
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  Future<void> toggleAdmin(AppUser user) async {
    final newRole = user.role == 'admin' ? 'user' : 'admin';
    await _service.updateUserRole(user.id, newRole);

    _users = _users
        .map((u) => u.id == user.id ? u.copyWith(role: newRole) : u)
        .toList();

    notifyListeners();
  }

  Future<void> toggleBlock(AppUser user) async {
    final newRole = user.role == 'blocked' ? 'user' : 'blocked';
    await _service.updateUserRole(user.id, newRole);

    _users = _users
        .map((u) => u.id == user.id ? u.copyWith(role: newRole) : u)
        .toList();

    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    await _service.deleteUser(userId);
    _users.removeWhere((u) => u.id == userId);
    notifyListeners();
  }
}
