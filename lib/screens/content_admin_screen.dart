import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/content_service.dart';
import 'news_editor_screen.dart';
import 'event_editor_screen.dart';

class ContentAdminScreen extends StatefulWidget {
  const ContentAdminScreen({super.key});

  @override
  State<ContentAdminScreen> createState() => _ContentAdminScreenState();
}

class _ContentAdminScreenState extends State<ContentAdminScreen> {
  final ContentService svc = ContentService();
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة المحتوى'),
          bottom: TabBar(tabs: [Tab(text: 'الأخبار'), Tab(text: 'الفعاليات')]),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'إنشاء',
                onPressed: () {
                  final tabIndex = DefaultTabController.of(context).index;
                  if (tabIndex == 0) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsEditorScreen()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EventEditorScreen()));
                  }
                },
              );
            }),
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final q = await showSearch<String>(context: context, delegate: _SimpleSearchDelegate());
                  if (q != null) setState(() => _filter = q);
                },
              );
            }),
          ],
        ),
        body: TabBarView(
          children: [
            // News tab
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: svc.newsStream(),
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text('خطأ: ${snap.error}'));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs.where((d) => d['title']?.toString().contains(_filter) ?? true).toList();
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final doc = docs[i];
                    final d = doc.data();
                    return ListTile(
                      title: Text(d['title'] ?? ''),
                      subtitle: Text(d['excerpt'] ?? ''),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) async {
                          if (v == 'edit') {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewsEditorScreen(docId: doc.id, initialData: d)));
                          } else if (v == 'delete') {
                            await svc.deleteNews(doc.id);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                          const PopupMenuItem(value: 'delete', child: Text('حذف')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Events tab
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: svc.eventsStream(),
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text('خطأ: ${snap.error}'));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs.where((d) => d['title']?.toString().contains(_filter) ?? true).toList();
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final doc = docs[i];
                    final d = doc.data();
                    return ListTile(
                      title: Text(d['title'] ?? ''),
                      subtitle: Text(d['location'] ?? ''),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) async {
                          if (v == 'edit') {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventEditorScreen(docId: doc.id, initialData: d)));
                          } else if (v == 'delete') {
                            await svc.deleteEvent(doc.id);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                          const PopupMenuItem(value: 'delete', child: Text('حذف')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Center(child: Text('بحث: $query'));

  @override
  Widget buildSuggestions(BuildContext context) => ListTile(title: Text('تطبيق البحث: $query'), onTap: () => close(context, query));
}
