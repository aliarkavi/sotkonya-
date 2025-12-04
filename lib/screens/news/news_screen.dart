// lib/screens/news/news_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/providers/news_provider.dart';
import 'package:sotkonya/providers/auth_provider.dart';
import 'package:sotkonya/model/news_model.dart';

import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/news_item_card.dart';
import 'widgets/news_details_screen.dart';
import 'add_news_screen.dart';
import 'edit_news_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      if (newsProvider.news.isEmpty && !newsProvider.loading) {
        newsProvider.fetchNews();
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    const primaryColor = Color(0xFF006db7);

    return BasePageLayout(
      title: "الأخبار",
      child: newsProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddNewsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "إضافة خبر جديد",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (newsProvider.news.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "لم يتم إضافة أخبار حتى الآن",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: newsProvider.news.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final NewsModel news = newsProvider.news[index];

                      return NewsItemCard(
                        obj: news,
                        iconData: Icons.article,
                        color: primaryColor,
                        isAdmin: isAdmin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailsScreen(
                                color: primaryColor,
                                obj: news,
                              ),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditNewsScreen(news: news),
                            ),
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("حذف الخبر"),
                              content: const Text(
                                "هل أنت متأكد من حذف هذا الخبر؟ لا يمكن التراجع بعد الحذف.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(false),
                                  child: const Text("إلغاء"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(true),
                                  child: const Text(
                                    "حذف",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await newsProvider.deleteNews(news.id);
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
    );
  }
}
