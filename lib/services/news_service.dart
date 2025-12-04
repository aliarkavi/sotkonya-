import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/news_model.dart';

class NewsService {
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  // جلب الأخبار
  Future<List<NewsModel>> getNews() async {
    final snapshot = await newsCollection
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return NewsModel.fromMap(doc.id, data);
    }).toList();
  }

  // إضافة خبر جديد
  Future<void> addNews(NewsModel item) async {
    await newsCollection.doc(item.id).set(item.toMap());
  }

  // تعديل خبر موجود
  Future<void> updateNews(NewsModel item) async {
    await newsCollection.doc(item.id).update(item.toMap());
  }

  // حذف خبر
  Future<void> deleteNews(String id) async {
    await newsCollection.doc(id).delete();
  }
}
