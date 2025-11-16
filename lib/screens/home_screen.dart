import 'package:flutter/material.dart';
// localization removed - app is fixed to Arabic
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/content_service.dart';
import 'news_detail_screen.dart';
import 'event_detail_screen.dart';
import 'news_screen.dart';
import 'events_screen.dart';
import 'timeline_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = ContentService();
    return Scaffold(
  appBar: AppBar(title: const Text('الرئيسية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const SizedBox(height: 8),
            // Timeline quick access
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TimelineScreen())),
                icon: const Icon(Icons.history),
                label: const Text('مسيرة التجمع'),
              ),
            ),
            const Text('الأخبار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: svc.newsStream(),
              builder: (context, snap) {
                if (snap.hasError) return const Text('خطأ في تحميل الأخبار');
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) return const Text('لا توجد أخبار بعد');
                final items = docs.take(3).toList();
                return Column(
                  children: [
                    for (var d in items)
                      _NewsCard(data: d.data(), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewsDetailScreen(data: d.data())))),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsScreen())), child: const Text('عرض كل الأخبار')),
                    )
                  ],
                );
              },
            ),

            const SizedBox(height: 18),
            const Text('الفعاليات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: svc.eventsStream(),
              builder: (context, snap) {
                if (snap.hasError) return const Text('خطأ في تحميل الفعاليات');
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) return const Text('لا توجد فعاليات حالياً');
                final items = docs.take(3).toList();
                return Column(
                  children: [
                    for (var d in items)
                      _EventCard(data: d.data(), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(data: d.data())))),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EventsScreen())), child: const Text('عرض كل الفعاليات')),
                    )
                  ],
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  const _NewsCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'بدون عنوان';
    final excerpt = data['excerpt'] ?? data['body'] ?? '';
    final imageUrl = (data['imageUrl'] ?? '') as String;
    return Card(
      color: const Color(0xFF1B2430),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: imageUrl.isNotEmpty ? SizedBox(width: 64, height: 64, child: ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(imageUrl, fit: BoxFit.cover))) : null,
        title: Text(title, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
        subtitle: Text(excerpt, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
        onTap: onTap,
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  const _EventCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'بدون عنوان';
    final start = data['startDate'] as Timestamp?;
    final dateStr = start != null ? DateTime.fromMillisecondsSinceEpoch(start.millisecondsSinceEpoch).toLocal().toString() : '';
    final location = data['location'] ?? '';
    return Card(
      color: const Color(0xFF1B2430),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
        subtitle: Text(location, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
        trailing: Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: onTap,
      ),
    );
  }
}
