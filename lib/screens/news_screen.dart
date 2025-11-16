import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/content_service.dart';
import 'news_detail_screen.dart';
import 'news_editor_screen.dart';

import '../services/user_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final svc = ContentService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final user = await UserService().getUser(uid);
    setState(() { _isAdmin = user?.role == 'admin'; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأخبار')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: svc.newsStream(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('خطأ: ${snap.error}'));
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('لا توجد أخبار بعد'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final title = d['title'] ?? 'بدون عنوان';
              final excerpt = d['excerpt'] ?? '';
              final timestamp = d['createdAt'] as Timestamp?;
              final dateStr = timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).toLocal().toString() : '';
              final imageUrl = (d['imageUrl'] ?? '') as String;
              return ListTile(
                leading: imageUrl.isNotEmpty ? SizedBox(width: 72, height: 72, child: ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(imageUrl, fit: BoxFit.cover))) : null,
                title: Text(title),
                subtitle: Text(excerpt),
                trailing: Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewsDetailScreen(data: d))),
                onLongPress: () {
                  // Open editor; Firestore rules should prevent unauthorized changes.
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewsEditorScreen(docId: docs[i].id, initialData: d)));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: _isAdmin ? FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('خبر جديد'),
        onPressed: () async {
          final created = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsEditorScreen()));
          if (created == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الخبر')));
          }
        },
      ) : null,
    );
  }
}
