import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:sotkonya/screens/authentication/login/login.dart';
//زimport 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
//import '../../providers/settings_provider.dart';
import '../../widgets/layouts/base_page_layout.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /*Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }*/

  /*void _shareApp() {
    Share.share(
      'جرّب تطبيق الطلاب الآن: https://play.google.com/store/apps/details?id=com.example.app',
      subject: 'تطبيق مفيد للطلاب',
    );
  }*/

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appUser = authProvider.appUser;
    final isAdmin = authProvider.isAdmin;
  //  final settings = Provider.of<SettingsProvider>(context);

    return BasePageLayout(
      title: 'الإعدادات',
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
                    appUser?.email.isNotEmpty == true
                        ? appUser!.email
                        : 'تحديث بياناتك الشخصية',
                  ),
                  onTap: () {},
                ),

                const Divider(height: 0),

                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('تغيير كلمة المرور'),
                  onTap: () {},
                ),

                const Divider(height: 0),

                // ------------------ زر تسجيل الخروج ------------------
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    final auth =
                        Provider.of<AuthProvider>(context, listen: false);

                    await auth.logout();

                    // 🔥 تحويل لصفحة تسجيل الدخول ومنع الرجوع للخلف
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
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
                /*SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('تفعيل الإشعارات'),
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    settings.setNotificationsEnabled(value);
                  },
                ),
                const Divider(height: 0),

                SwitchListTile(
                  secondary: const Icon(Icons.article_outlined),
                  title: const Text('إشعارات الأخبار'),
                  value: settings.notificationsEnabled &&
                      settings.newsNotifications,
                  onChanged: settings.notificationsEnabled
                      ? (value) => settings.setNewsNotifications(value)
                      : null,
                ),
                const Divider(height: 0),

                SwitchListTile(
                  secondary: const Icon(Icons.event_available_outlined),
                  title: const Text('إشعارات الفعاليات'),
                  value: settings.notificationsEnabled &&
                      settings.eventsNotifications,
                onChanged: settings.notificationsEnabled
                     ? (value) => settings.setEventsNotifications(value)
                     : null,
                ),*/
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // ------------------ إعدادات التطبيق ------------------
          /*_buildSectionTitle('إعدادات التطبيق'),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star_rate_outlined),
                  title: const Text('تقييم التطبيق'),
                  onTap: () {
                    _launchExternalUrl(
                      'https://play.google.com/store/apps/details?id=com.example.app',
                    );
                  },
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
                  onTap: () {},
                ),
                const Divider(height: 0),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('حول التطبيق'),
                  onTap: () {},
                ),
              ],
            ),
          ),*/

          const SizedBox(height: 16),
          const Divider(),

          // ------------------ قسم المشرف (ADMIN ONLY) ------------------
          if (isAdmin) ...[
            //_buildSectionTitle('قسم المشرف'),
            /*Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.manage_search_outlined),
                    title: Text('إدارة الأخبار'),
                  ),
                  Divider(height: 0),

                  ListTile(
                    leading: Icon(Icons.event_available_outlined),
                    title: Text('إدارة الفعاليات'),
                  ),
                  Divider(height: 0),

                  ListTile(
                    leading: Icon(Icons.group_outlined),
                    title: Text('إدارة المستخدمين'),
                  ),
                ],
              ),
            ),*/
          ],
        ],
      ),
    );
  }
}
