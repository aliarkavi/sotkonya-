// lib/providers/news_provider.dart
import 'package:flutter/material.dart';
import 'package:sotkonya/model/news_item.dart';
import 'package:sotkonya/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();

  List<NewsItem> _news = [];
  List<NewsItem> get news => _news;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchNews() async {
    _loading = true;
    notifyListeners();

    _news = await _service.getNews();

    _loading = false;
    notifyListeners();
  }
}
