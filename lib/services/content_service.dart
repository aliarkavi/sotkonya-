import 'package:cloud_firestore/cloud_firestore.dart';

class ContentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream of news documents ordered by createdAt desc
  Stream<QuerySnapshot<Map<String, dynamic>>> newsStream() {
    return _db.collection('news').orderBy('createdAt', descending: true).snapshots();
  }

  /// Stream of events documents ordered by startDate desc
  Stream<QuerySnapshot<Map<String, dynamic>>> eventsStream() {
    return _db.collection('events').orderBy('startDate', descending: true).snapshots();
  }

  /// Stream of forum threads ordered by updatedAt desc
  Stream<QuerySnapshot<Map<String, dynamic>>> forumStream() {
    return _db.collection('forum').orderBy('updatedAt', descending: true).snapshots();
  }

  /// Create a news document (returns generated id)
  Future<String> createNews(Map<String, dynamic> data) async {
    final ref = await _db.collection('news').add(data);
    return ref.id;
  }

  Future<void> updateNews(String id, Map<String, dynamic> data) async {
    await _db.collection('news').doc(id).update(data);
  }

  Future<String> createEvent(Map<String, dynamic> data) async {
    final ref = await _db.collection('events').add(data);
    return ref.id;
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _db.collection('events').doc(id).update(data);
  }

  Future<void> deleteNews(String id) async {
    await _db.collection('news').doc(id).delete();
  }

  Future<void> deleteEvent(String id) async {
    await _db.collection('events').doc(id).delete();
  }

  Future<void> deleteForum(String id) async {
    await _db.collection('forum').doc(id).delete();
  }
}
