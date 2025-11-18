import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/content_service.dart';
import '../screens/news_detail_screen.dart';
import '../screens/news_screen.dart';

class NewsFeedSnippet extends StatelessWidget {
  final int limit;
  final VoidCallback? onViewAll;

  const NewsFeedSnippet({super.key, this.limit = 3, this.onViewAll});

  String _formatDate(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate().toLocal();
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final svc = ContentService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: svc.newsStream(),
      builder: (context, snap) {
        Widget body;

        if (snap.hasError) {
          body = const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('خطأ في جلب الأخبار', textAlign: TextAlign.center),
          );
        } else if (snap.connectionState == ConnectionState.waiting) {
          body = const Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          final docs = snap.data?.docs ?? [];

          if (docs.isEmpty) {
            body = const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('لا توجد أخبار حالياً', textAlign: TextAlign.center),
            );
          } else {
            final displayed = docs.take(limit).toList();
            body = Column(
              children: displayed.map((doc) {
                final d = doc.data();
                final title = d['title'] ?? 'بدون عنوان';
                final excerpt = (d['excerpt'] ?? d['description'] ?? '') as String;
                final timestamp = d['createdAt'] as Timestamp?;
                final imageUrl = (d['imageUrl'] ?? '') as String;

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NewsDetailScreen(data: d)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 84,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: 84,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.newspaper, color: Colors.grey, size: 28),
                          ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                excerpt,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formatDate(timestamp),
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        }

        return Card(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // header of card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('آخر الأخبار',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(
                      onPressed: onViewAll ??
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewsScreen()),
                          ),
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),

                const Divider(),

                body,

                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}
