import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/layouts/base_page_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    Share.share(
      'جرّب تطبيق الطلاب الآن: https://play.google.com/store/apps/details?id=com.example.app',
      subject: 'تطبيق مفيد للطلاب',
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appUser = authProvider.appUser;
    final isAdmin = authProvider.isAdmin;
    final settings = Provider.of<SettingsProvider>(context);

    return BasePageLayout(
      title: 'الإعدادات',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم 1: حساب المستخدم
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileEditScreen(),
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
                        builder: (_) => const ChangePasswordScreen(),
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
                  onTap: () => authProvider.logout(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // قسم 2: الإشعارات
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
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // قسم 3: إعدادات التطبيق
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
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('شروط الاستخدام'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsOfUseScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('حول التطبيق'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                const ListTile(
                  leading: Icon(Icons.tag_outlined),
                  title: Text('إصدار التطبيق'),
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // قسم 4: الدعم
          _buildSectionTitle('الدعم'),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: const Text('تواصل معنا'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContactScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: const Text('إرسال اقتراح'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SuggestionScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('الإبلاغ عن مشكلة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportIssueScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // قسم 5: قسم المشرف (ADMIN ONLY)
          if (isAdmin) ...[
            _buildSectionTitle('قسم المشرف'),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.manage_search_outlined),
                    title: const Text('إدارة الأخبار'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminNewsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.event_available_outlined),
                    title: const Text('إدارة الفعاليات'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminEventsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.group_outlined),
                    title: const Text('إدارة المستخدمين'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UsersManagerScreen(),
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
    );
  }
}

// الشاشات التالية Placeholders لتكملة الربط من صفحة الإعدادات.

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
      body: const Center(child: Text('ProfileEditScreen')),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تغيير كلمة المرور')),
      body: const Center(child: Text('ChangePasswordScreen')),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سياسة الخصوصية')),
      body: const Center(
        child: Text('هنا يمكن وضع WebView لعرض سياسة الخصوصية'),
      ),
    );
  }
}

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شروط الاستخدام')),
      body: const Center(
        child: Text('هنا يمكن وضع WebView لعرض شروط الاستخدام'),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حول التطبيق')),
      body: const Center(
        child: Text('معلومات عن التطبيق'),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تواصل معنا')),
      body: const Center(
        child: Text('نموذج تواصل معنا'),
      ),
    );
  }
}

class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إرسال اقتراح')),
      body: const Center(
        child: Text('نموذج إرسال اقتراح'),
      ),
    );
  }
}

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإبلاغ عن مشكلة')),
      body: const Center(
        child: Text('نموذج الإبلاغ عن مشكلة'),
      ),
    );
  }
}

class AdminNewsScreen extends StatelessWidget {
  const AdminNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الأخبار')),
      body: const Center(
        child: Text('قائمة إدارة الأخبار'),
      ),
    );
  }
}

class AdminEventsScreen extends StatelessWidget {
  const AdminEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الفعاليات')),
      body: const Center(
        child: Text('قائمة إدارة الفعاليات'),
      ),
    );
  }
}

class UsersManagerScreen extends StatelessWidget {
  const UsersManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين')),
      body: const Center(
        child: Text('قائمة المستخدمين'),
      ),
    );
  }
}

