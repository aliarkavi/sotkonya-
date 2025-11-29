import 'package:flutter/material.dart';
import 'package:sotkonya/model/event_item.dart';
import 'package:sotkonya/services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();

  List<EventItem> _events = [];
  List<EventItem> get events => _events;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchEvents() async {
    _loading = true;
    notifyListeners();

    _events = await _service.getEvents();

    _loading = false;
    notifyListeners();
  }
}
