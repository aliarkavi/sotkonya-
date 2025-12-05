import 'package:flutter/material.dart';
import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchEvents() async {
    _loading = true;
    notifyListeners();

    try {
      _events = await _service.getEvents();

      // ترتيب: أولاً الفعاليات القادمة، الأقرب فالأبعد، ثم الفعاليات الماضية
      final now = DateTime.now();
      final upcoming = _events
          .where((e) => e.startDate.isAfter(now))
          .toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));

      final past = _events
          .where((e) => !e.startDate.isAfter(now))
          .toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

      _events = [...upcoming, ...past];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(EventModel item) async {
    await _service.addEvent(item);
    await fetchEvents();
  }

  Future<void> updateEvent(EventModel item) async {
    await _service.updateEvent(item);
    await fetchEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _service.deleteEvent(id);
    await fetchEvents();
  }
}
