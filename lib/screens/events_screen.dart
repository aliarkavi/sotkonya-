import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/content_service.dart';
import 'event_detail_screen.dart';
import 'event_editor_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = ContentService();
    return Scaffold(
      appBar: AppBar(title: const Text('الفعاليات')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: svc.eventsStream(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('خطأ: \\${snap.error}'));
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('لا توجد فعاليات حالياً'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final title = d['title'] ?? 'بدون عنوان';
              final start = d['startDate'] as Timestamp?;
              final dateStr = start != null ? DateTime.fromMillisecondsSinceEpoch(start.millisecondsSinceEpoch).toLocal().toString() : '';
              return ListTile(
                title: Text(title),
                subtitle: Text(d['location'] ?? ''),
                trailing: Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(data: d))),
                onLongPress: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventEditorScreen(docId: docs[i].id, initialData: d))),
              );
            },
          );
        },
      ),
    );
  }
}
