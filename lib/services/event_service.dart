// lib/services/event_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sotkonya/model/event_item.dart';


class EventService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<List<EventItem>> getEvents() async {
    final snapshot = await eventCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return EventItem(
        title: data['title'] ?? '',
        date: data['date'] ?? '',
        time: data['time'] ?? '',
        location: data['location'] ?? '',
        iconData: Icons.event,
        color: Color(int.parse(data['color'] ?? '0xFFf2b200')),
      );
    }).toList();
  }
}
