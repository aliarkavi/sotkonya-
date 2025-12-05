// lib/screens/news/news_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/providers/news_provider.dart';
import 'package:sotkonya/providers/auth_provider.dart';
import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/widgets/shimmer_widgets.dart';

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
  static const Color primaryColor = Color(0xFF006db7);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
      _initialized = true;
    }
  }

  // BOTTOMSHEET UI
  Future<String?> _showAdminActions() {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50)),
              ),
              const SizedBox(height: 20),

              // تعديل
              GestureDetector(
                onTap: () => Navigator.pop(ctx, "edit"),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F0FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.edit, color: primaryColor),
                      SizedBox(width: 12),
                      Text("تعديل الخبر",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // حذف
              GestureDetector(
                onTap: () => Navigator.pop(ctx, "delete"),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAEA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 12),
                      Text("حذف الخبر",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // إلغاء
              GestureDetector(
                onTap: () => Navigator.pop(ctx, null),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.close, color: Colors.grey),
                      SizedBox(width: 12),
                      Text("إلغاء",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return BasePageLayout(
      title: "الأخبار",
      child: newsProvider.loading
          ? Column(
  children: List.generate(4, (_) => shimmerNewsCard()),
)
 

          : Column(
              children: [
                // زر إضافة خبر للمدير فقط
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddNewsScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "إضافة خبر جديد",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
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
                // عرض الأخبار
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsProvider.news.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final NewsModel obj = newsProvider.news[index];

                    Widget card = NewsItemCard(
                      obj: obj,
                      color: primaryColor,
                      iconData: Icons.article,
                      isAdmin: isAdmin,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NewsDetailsScreen(color: primaryColor, obj: obj),
                          ),
                        );
                      },
                    );

                    // الضغط المطوّل للمدير
                    if (isAdmin) {
                      card = GestureDetector(
                        onLongPress: () async {
                          final action = await _showAdminActions();

                          if (action == "edit") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditNewsScreen(news: obj),
                              ),
                            );
                          } else if (action == "delete") {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("حذف الخبر"),
                                content: const Text(
                                    "هل أنت متأكد من الحذف؟ لا يمكن التراجع."),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("إلغاء")),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    child: const Text(
                                      "حذف",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await newsProvider.deleteNews(obj.id);
                            }
                          }
                        },
                        child: card,
                      );
                    }
                    return card;
                  },
                ),
              ],
            ),
    );
  }
}
