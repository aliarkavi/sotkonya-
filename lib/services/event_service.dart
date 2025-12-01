import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/event_item.dart';

class EventService {
  final CollectionReference eventRef =
      FirebaseFirestore.instance.collection('events');

  Future<List<EventItem>> getEvents() async {
    final snapshot = await eventRef.orderBy("startDate").get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return EventItem.fromMap(doc.id, data);
    }).toList();
  }

  Future<void> addEvent(EventItem item) async {
    await eventRef.doc(item.id).set(item.toMap());
  }

  Future<void> updateEvent(EventItem item) async {
    await eventRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await eventRef.doc(id).delete();
  }
}
