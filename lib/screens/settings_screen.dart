import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (r) => false,
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text('هل أنت متأكد؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف')),
        ],
      ),
    );

    if (ok == true) {
      try {
        await FirebaseAuth.instance.currentUser!.delete();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (r) => false,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('خطأ'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600,
                  Colors.green.shade500,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'الإعدادات العامة',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 5),
                Text(
                  'إدارة حسابك والتحكم بخيارات التطبيق',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // الملف الشخصي
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            subtitle: const Text('تعديل معلومات الحساب'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),

          // الدعم الفني
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('الدعم الفني'),
            subtitle: const Text('تواصل معنا أو أرسل مشكلة'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportScreen()),
            ),
          ),

          // عن التطبيق
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('حول التطبيق'),
            subtitle: const Text('معلومات عن النسخة والتطوير'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "SOT Konya",
                applicationVersion: "1.0.0",
                applicationLegalese: "تطبيق مخصص لخدمات SOT Konya.",
              );
            },
          ),

          const Divider(),

          // تسجيل الخروج
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('تسجيل الخروج'),
            onTap: () => _signOut(context),
          ),

          // حذف الحساب
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('حذف الحساب'),
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ),
    );
  }
}
