// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/notification_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/news_provider.dart';
import '../../widgets/layouts/grid_layout.dart';
import '../../widgets/section_heading.dart';
import '../news/news_screen.dart';
import 'widgets/home_news_item.dart';
import 'widgets/notifications_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).fetchNews();
    
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final latestNews = newsProvider.news.take(2).toList();

    final userName = authProvider.appUser?.name ?? "مستخدم";

    final notifications = [
      NotificationItem(
        title: "فعالية جديدة: ملتقى التوظيف",
        subtitle: "اليوم الساعة 2:00 مساءً",
        dotColor: Colors.blue,
      ),
      NotificationItem(
        title: "إعلان سكن: البحث عن زميل غرفة",
        subtitle: "منذ ساعتين",
        dotColor: Colors.green,
      ),
      NotificationItem(
        title: "خبر: تحديث مواعيد المكتبة",
        subtitle: "أمس",
        dotColor: Colors.red,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: [
                // هيدر الترحيب
                Container(
  padding: const EdgeInsets.all(17.0),
  height: 150,
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    image: DecorationImage(
      image: AssetImage("assets/ustlider.png"), // ضع صورتك هنا
      fit: BoxFit.cover,
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Icon(Icons.notifications_none_outlined,
            color: Colors.white, size: 30),
      ),
      const Spacer(),
      Text("مرحبًا،",
          style: TextStyle(color: Colors.white, fontSize: 16)),
      Text("$userName",
          style: TextStyle(color: Colors.white, fontSize: 20)),
    ],
  ),
),

                const SizedBox(height: 20.0),

                // الأقسام الرئيسية
                SectionHeading(title: 'آخر الأخبار'),
                const SizedBox(height: 5.0),

                GridLayout(
                  itemCount: latestNews.length,
                  crossAxisCount: 1,
                  mainAxisExtent: 145,
                  itemBuilder: (context, index) {
                    final item = latestNews[index];
                    return HomeNewsItem(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const NewsScreen()));
                      },
                      title: item.title,
                      subtitle: item.subtitle,
                      imageUrl: item.imageUrl,
                    );
                  },
                ),

                const SizedBox(height: 20.0),

                SectionHeading(title: 'آخر النشاطات'),
                const SizedBox(height: 5.0),

                NotificationsCard(items: notifications),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
