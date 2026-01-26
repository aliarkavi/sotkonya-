// ignore_for_file: unnecessary_string_interpolations, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/screens/home/widgets/home_events_card.dart';

import '../../providers/auth_provider.dart';
import '../../providers/news_provider.dart';
import '../../providers/event_provider.dart';

import '../../widgets/layouts/grid_layout.dart';
import '../../widgets/section_heading.dart';

import '../news/news_screen.dart';
import '../event/event_screen.dart';

import 'widgets/home_news_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      newsProvider.fetchNews();
      eventProvider.fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // نأخذ أول خبرين وأول فعاليتين
    final latestNews = newsProvider.news.take(2).toList();
    final latestEvents = eventProvider.events.take(2).toList();
    final userName = authProvider.appUser?.name ?? "زائر";

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("اضغط مرة أخرى للخروج من التطبيق"),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          SystemNavigator.pop();
        });
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الهيدر العلوي
                  Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/ustlider.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Text(
                          "مرحباً بك",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ قسم أحدث الأخبار - التعديل هنا
                  SectionHeading(
                    title: "أحدث الأخبار",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewsScreen()),
                    ),
                  ),
                  const SizedBox(height: 5),

                  GridLayout(
                    itemCount: latestNews.length,
                    crossAxisCount: 1,
                    mainAxisExtent: 155, // زدنا الارتفاع قليلاً ليتناسب مع التصميم الجديد
                    itemBuilder: (_, index) {
                      final item = latestNews[index];
                      return HomeNewsItem(
                        obj: item, // ✅ نمرر الكائن كاملاً الآن
                        onTap: () {
                          // هنا يفضل توجيه المستخدم لصفحة تفاصيل الخبر مباشرة 
                          // بدلاً من قائمة الأخبار العامة إذا أردت تجربة مستخدم أفضل
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NewsScreen()),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // آخر الفعاليات
                  SectionHeading(
                    title: "أحدث الفعاليات",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EventScreen()),
                    ),
                  ),
                  const SizedBox(height: 5),

                  GridLayout(
                    itemCount: latestEvents.length,
                    crossAxisCount: 1,
                    mainAxisExtent: 145,
                    itemBuilder: (_, index) {
                      final event = latestEvents[index];
                      return HomeEventsItem(
                        title: event.title,
                        subtitle: event.date,
                        imageUrl: event.imageUrl,
                        fallbackIcon: Icons.event,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EventScreen()),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}