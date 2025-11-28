// lib/models/event_item.dart
import 'package:flutter/material.dart';

class EventItem {
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final IconData iconData;
  final Color color;

  EventItem({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.iconData,
    required this.color,
  });
}
