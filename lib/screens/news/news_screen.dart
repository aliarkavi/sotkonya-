import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/NewsDetailsScreen.dart';
import 'package:sotkonya/providers/news_provider.dart';
import 'package:sotkonya/providers/auth_provider.dart';

import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/news_item_card.dart';
import 'add_news_screen.dart';
import 'edit_news_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    if (newsProvider.news.isEmpty && !newsProvider.loading) {
      newsProvider.fetchNews();
    }

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
                        backgroundColor: const Color(0xFF006db7),
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
                        "إضافة خبر",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsProvider.news.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final news = newsProvider.news[index];

                    return NewsItemCard(
                      news: news,
                      isAdmin: isAdmin,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailsScreen(news: news),
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
                                "هل أنت متأكد أنك تريد حذف هذا الخبر؟"),
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
