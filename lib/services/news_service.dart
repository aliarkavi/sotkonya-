import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/news_item.dart';

class NewsService {
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  Future<List<NewsItem>> getNews() async {
    final snapshot = await newsCollection
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return NewsItem.fromMap(doc.id, data);
    }).toList();
  }
}
