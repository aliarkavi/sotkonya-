import 'package:flutter/material.dart';
import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();

  List<NewsModel> _news = [];
  List<NewsModel> get news => _news;

  bool _loading = false;
  bool get loading => _loading;

  // جلب الأخبار
  Future<void> fetchNews() async {
    _loading = true;
    notifyListeners();

    _news = await _service.getNews();

    _loading = false;
    notifyListeners();
  }

  // إضافة خبر
  Future<void> addNews(NewsModel item) async {
    await _service.addNews(item);
    await fetchNews(); // نعيد التحديث بعد الإضافة
  }

  // تعديل خبر
  Future<void> updateNews(NewsModel item) async {
    await _service.updateNews(item);
    await fetchNews();
  }

  // حذف خبر
  Future<void> deleteNews(String id) async {
    await _service.deleteNews(id);
    await fetchNews();
  }
}
