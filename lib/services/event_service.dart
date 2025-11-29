import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/event_item.dart';

class EventService {
  final CollectionReference eventRef =
      FirebaseFirestore.instance.collection('events');

  Future<List<EventItem>> getEvents() async {
    final snapshot = await eventRef.orderBy("date").get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return EventItem.fromMap(doc.id, data);
    }).toList();
  }
}
