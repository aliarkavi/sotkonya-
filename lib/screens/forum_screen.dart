import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/forum_service.dart';
import '../services/user_service.dart';
import 'create_group_screen.dart';
import 'group_chat_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final svc = ForumService();
  final _userSvc = UserService();
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final u = await _userSvc.getUser(uid);
    setState(() => _role = u?.role ?? 'user');
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('المنتدى')),
      body: uid == null
          ? const Center(child: Text('يرجى تسجيل الدخول'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: svc.streamGroupsForUser(uid),
              builder: (context, snap) {
                if (snap.hasError) {
                  final err = snap.error.toString();
                  final urlMatch = RegExp(r'https:\/\/console\.firebase\.google\.com\/[\S]+').firstMatch(err);
                  final url = urlMatch?.group(0);
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('خطأ في استعلام Firestore. قد تحتاج لإنشاء فهرس مركب.'),
                          const SizedBox(height: 8),
                          Text(err, textAlign: TextAlign.center),
                          if (url != null) ...[
                            const SizedBox(height: 12),
                            SelectableText('رابط إنشاء الفهرس:\n$url', textAlign: TextAlign.center),
                          ]
                        ],
                      ),
                    ),
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final docs = snap.data?.docs ?? [];

                // If user has no groups and is a normal user, show the invited message.
                if (docs.isEmpty) {
                  final isAdmin = (_role ?? 'user') == 'admin';
                  return Center(child: Text(isAdmin ? 'لا توجد غروبات بعد' : 'لم تتم دعوتك الى اي غروب حتى الان'));
                }

                final sorted = docs.toList()
                  ..sort((a, b) {
                    final aTs = (a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                    final bTs = (b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                    return bTs.compareTo(aTs);
                  });

                return ListView.builder(
                  itemCount: sorted.length,
                  itemBuilder: (context, i) {
                    final doc = sorted[i];
                    final d = doc.data();
                    final gId = doc.id;
                    final name = d['name'] ?? 'بدون اسم';
                    final members = List<String>.from(d['members'] ?? []);
                    return ListTile(
                      leading: d['photoUrl'] != null && (d['photoUrl'] as String).isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(d['photoUrl'])) : const CircleAvatar(child: Icon(Icons.group)),
                      title: Text(name),
                      subtitle: Text('${members.length} عضو', textAlign: TextAlign.right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: gId, groupName: name, photoUrl: d['photoUrl'] ?? ''))),
                    );
                  },
                );
              },
            ),
      floatingActionButton: _role == 'admin'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final id = await Navigator.of(context).push<String?>(MaterialPageRoute(builder: (_) => const CreateGroupScreen()));
                if (id != null) {
                  final doc = await FirebaseFirestore.instance.collection('groups').doc(id).get();
                  final d = doc.data() ?? {};
                  final name = d['name'] ?? 'مجموعة جديدة';
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: id, groupName: name, photoUrl: d['photoUrl'] ?? '')));
                }
              },
            )
          : null,
    );
  }
}
