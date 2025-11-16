// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final UserService _svc = UserService();
  late Future<List<AppUser>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _svc.getAllUsers();
  }

  Future<void> _refresh() async {
    setState(() {
      _usersFuture = _svc.getAllUsers();
    });
  }

  Future<void> _setRole(AppUser user, String role) async {
    await _svc.updateUserRole(user.id, role);
    await _refresh();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تحديث دور المستخدم')));
  }

  Future<void> _deleteUser(AppUser user) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('تأكيد الحذف'), content: Text('هل أنت متأكد من حذف المستخدم ${user.name}؟'), actions: [TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('حذف'))]));
    if (ok != true) return;
    await _svc.deleteUser(user.id);
    await _refresh();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف المستخدم')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين')),
      body: FutureBuilder<List<AppUser>>(
        future: _usersFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('خطأ: \\${snap.error}'));
          final users = snap.data ?? [];
          if (users.isEmpty) return const Center(child: Text('لا يوجد مستخدمين'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final u = users[i];
                return ListTile(
                  leading: u.photoUrl.isNotEmpty
                      ? CircleAvatar(backgroundImage: NetworkImage(u.photoUrl))
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(u.name.isNotEmpty ? u.name : u.email),
                  subtitle: Text('الدور: ${u.role}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'make_admin') {
                        await _setRole(u, 'admin');
                      } else if (v == 'make_moderator_news') {
                        await _setRole(u, 'moderator:news');
                      } else if (v == 'make_moderator_events') {
                        await _setRole(u, 'moderator:events');
                      } else if (v == 'ban') {
                        await _setRole(u, 'banned');
                      } else if (v == 'delete') {
                        await _deleteUser(u);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'make_admin', child: Text('تعيين مشرف عام')),
                      const PopupMenuItem(value: 'make_moderator_news', child: Text('تعيين مشرف أخبار')),
                      const PopupMenuItem(value: 'make_moderator_events', child: Text('تعيين مشرف فعاليات')),
                      const PopupMenuItem(value: 'ban', child: Text('حظر المستخدم')),
                      const PopupMenuItem(value: 'delete', child: Text('حذف المستخدم')),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
