import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/NewsDetailsScreen.dart';
import 'package:sotkonya/providers/news_provider.dart';


import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/news_item_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    if (newsProvider.news.isEmpty && !newsProvider.loading) {
      newsProvider.fetchNews();
    }

    return BasePageLayout(
      title: "الأخبار",
      child: newsProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newsProvider.news.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final news = newsProvider.news[index];
return NewsItemCard(
  news: news,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailsScreen(news: news),
      ),
    );
  },
);
              },
            ),
    );
  }
}