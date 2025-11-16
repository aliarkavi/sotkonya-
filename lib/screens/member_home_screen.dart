import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'housing_screen.dart';
import 'settings_screen.dart';
import 'news_screen.dart';
import 'events_screen.dart';
import 'forum_screen.dart';
import 'timeline_screen.dart';

class MemberHomeScreen extends StatelessWidget {
  const MemberHomeScreen({super.key});

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
            title: const Text('الرئيسية'),
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
                children: [
                  const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                  const SizedBox(height: 8),
                      const Text('SOTKonya', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 4),
                      const Text('الزائر', style: TextStyle(color: Colors.white70)),
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
            ListTile(
              leading: const Icon(Icons.forum),
                  title: const Text('المنتدى'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForumScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.home_work),
                  title: const Text('السكنات'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HousingScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
                  title: const Text('الإعدادات'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.history),
                  title: const Text('مسيرة التجمع'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TimelineScreen())),
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
            children: [
              const Icon(Icons.home, size: 96, color: Color(0xFF4B2B1B)),
              const SizedBox(height: 16),
                  const Text('SOTKonya', style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.right),
              const SizedBox(height: 8),
                  const Text('مرحباً بك في التطبيق', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
