import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'housing_screen.dart';
import 'settings_screen.dart';
import 'news_screen.dart';
import 'events_screen.dart';
//import 'forum_screen.dart'  ;
import 'content_admin_screen.dart';
import 'admin_users_screen.dart';
//import 'timeline_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'القائمة',
          ),
        ),
        title: const Text('لوحة الإدارة'),
        backgroundColor: const Color(0xFF151C26),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'الملف الشخصي',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF151C26)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(radius: 28, child: Icon(Icons.person)),
                  SizedBox(height: 8),
                  Text('SOTKonya', style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 4),
                  Text('لوحة الإدارة', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('الأخبار'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('الفعاليات'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EventsScreen())),
            ),
          /*  ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('المنتدى'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForumScreen())),
            ), */
            ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text('السكنات'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HousingScreen())),
            ),
            /*ListTile(
              leading: const Icon(Icons.history),
              title: const Text('مسيرة التجمع'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TimelineScreen())),
            ),*/
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('إدارة المحتوى'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContentAdminScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('المستخدمون'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminUsersScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الإعدادات'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF151C26),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.admin_panel_settings, size: 96, color: Color(0xFFFFA726)),
              SizedBox(height: 16),
              Text('مرحبا، أنت داخل لوحة الإدارة', style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.right, textDirection: TextDirection.rtl),
              SizedBox(height: 8),
              Text('يمكنك إدارة المستخدمين، الأخبار، والفعاليات من هنا.', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center, textDirection: TextDirection.rtl),
            ],
          ),
        ),
      ),
    );
  }
}
