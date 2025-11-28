import 'package:flutter/material.dart';
import '../../../model/news_item.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsItem news;

  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الخبر"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // صورة الخبر
            if (news.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  news.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // العنوان
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006db7),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // التاريخ
                  Text(
                    "تاريخ النشر: ${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // المحتوى
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
