import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sotkonya/screens/authentication/login/login.dart';
import 'package:sotkonya/screens/settings/user_mangment/user_management_screen.dart';
import 'package:sotkonya/screens/user/change_password_screen.dart';
import 'package:sotkonya/screens/user/profile_screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

import '../../widgets/layouts/base_page_layout.dart';
import '../../screens/settings/privacy_policy_screen.dart';

import 'about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ✅ إعدادات روابط المتجر
  // تأكد من أن هذا هو معرف الحزمة الصحيح لتطبيقك على Google Play
  final String _androidPackageName = 'com.sotkonya.app'; 
  // ⚠️ استبدل هذا الرقم بمعرف تطبيقك الحقيقي على App Store (Apple ID)
  final String _iosAppId = '1234567890'; 

  String _getStoreUrl() {
    if (Platform.isIOS) {
      return 'https://apps.apple.com/app/id$_iosAppId';
    }
    return 'https://play.google.com/store/apps/details?id=$_androidPackageName';
  }

  Future<void> _launchExternalUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الرابط حالياً')),
      );
    }
  }

  void _shareApp() {
    Share.share(
    
      'ندعوكم لتجربة تطبيق تجمع الطلبة السوريين في قونيا، المنصّة المخصّصة لتسهيل تواصل الطلبة ومشاركة الفرص والخدمات الطلابية لا تترددوا بمشاركته مع زملائكم لتعم الفائدة للجميع. ${_getStoreUrl()}',
      subject: 'تطبيق تجمع الطلبة السوريين في قونيا',
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<bool> _confirmLogout(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('تأكيد'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();

    final appUser = authProvider.appUser;
    final isAdmin = authProvider.isAdmin;

    return BasePageLayout(
      title: 'الإعدادات',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ حساب المستخدم ------------------
            _buildSectionTitle('حساب المستخدم'),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('تعديل الملف الشخصي'),
                    subtitle: Text(
                      (appUser?.email.isNotEmpty ?? false)
                          ? appUser!.email
                          : 'تحديث بياناتك الشخصية',
                    ),
                    onTap: () {   
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            title: 'الملف الشخصي',
                            obj: appUser!,
                          ),
                        ),
                      );
                  
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('تغيير كلمة المرور'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangePasswordScreen(obj: appUser!),
                        ),
                      );

                  
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      final yes = await _confirmLogout(context);
                      if (!yes) return;

                      final auth = context.read<AuthProvider>();
                      await auth.logout();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

          // ------------------ الإشعارات ------------------
_buildSectionTitle('الإشعارات'),
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      SwitchListTile(
        secondary: const Icon(Icons.notifications_active_outlined),
        title: const Text('تفعيل الإشعارات'),
        value: settings.notificationsEnabled,
        onChanged: (v) async {
          await settings.setNotificationsEnabled(v);
        },
      ),
      const Divider(height: 0),
      SwitchListTile(
        secondary: const Icon(Icons.article_outlined),
        title: const Text('إشعارات الأخبار'),
        value: settings.notificationsEnabled && settings.newsNotifications,
        onChanged: settings.notificationsEnabled
            ? (v) async => settings.setNewsNotifications(v)
            : null,
      ),
      const Divider(height: 0),
      SwitchListTile(
        secondary: const Icon(Icons.event_available_outlined),
        title: const Text('إشعارات الفعاليات'),
        value: settings.notificationsEnabled && settings.eventsNotifications,
        onChanged: settings.notificationsEnabled
            ? (v) async => settings.setEventsNotifications(v)
            : null,
      ),
    ],
  ),
),


            const SizedBox(height: 16),
            const Divider(),

            // ------------------ إعدادات التطبيق ------------------
            _buildSectionTitle('إعدادات التطبيق'),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.star_rate_outlined),
                    title: const Text('تقييم التطبيق'),
                    onTap: () => _launchExternalUrl(context, _getStoreUrl()),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text('مشاركة التطبيق'),
                    onTap: _shareApp,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('سياسة الخصوصية'),
                  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  },
                  ),
                  const Divider(height: 0),

                  // ✅ تم تعديل "حول التطبيق" لفتح صفحة AboutAppScreen (فيها أسماء الفريق)
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('حول التطبيق'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutAppScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // ------------------ قسم المشرف (ADMIN ONLY) ------------------
            if (isAdmin) ...[
              _buildSectionTitle('قسم المشرف'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    /*ListTile(
                      leading: const Icon(Icons.manage_search_outlined),
                      title: const Text('إدارة الأخبار'),
                      onTap: () {
                        // TODO: افتح شاشة إدارة الأخبار
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.event_available_outlined),
                      title: const Text('إدارة الفعاليات'),
                      onTap: () {
                        // TODO: افتح شاشة إدارة الفعاليات
                      },
                    ),*/
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.group_outlined),
                      title: const Text('إدارة المستخدمين'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserManagementScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
