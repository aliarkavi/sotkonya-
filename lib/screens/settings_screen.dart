import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
  }

  Future<void> _confirmDeleteAccount() async {
    final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
      title: const Text('حذف الحساب'),
      content: const Text('هل أنت متأكد؟ هذا الإجراء لا يمكن التراجع عنه.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('إلغاء')),
        TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف')),
      ],
    ));
    if (ok == true) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await user.delete();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
        } catch (e) {
          await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('خطأ'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            subtitle: const Text('تعديل المعلومات الشخصية'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          SwitchListTile(
            title: const Text('الوضع الداكن'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          // Language switching removed - app uses Arabic by default
          SwitchListTile(
            title: const Text('الإشعارات'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('تسجيل الخروج'),
            onTap: _signOut,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('حذف الحساب'),
            onTap: _confirmDeleteAccount,
          ),
        ],
      ),
    );
  }
}
