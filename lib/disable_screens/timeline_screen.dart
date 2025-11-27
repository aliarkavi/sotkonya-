/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/user_service.dart';
import 'timeline_editor_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  String? _role;
  bool _manageMode = false;
  final Set<String> _selectedIds = {};
  StreamSubscription<User?>? _authSub;
  
  @override
  void initState() {
    super.initState();
    _loadRole();
    // reload role when auth state changes (login/logout)
    _authSub = FirebaseAuth.instance.authStateChanges().listen((_) => _loadRole());
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _loadRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final user = await UserService().getUser(uid);
    if (!mounted) return;
    setState(() { _role = user?.role; });
  }

  /// Local fallback timeline entries (Arabic brief history)
  static final List<Map<String, String>> _fallback = [
    {'year': '2020', 'text': 'تأسيس مجموعة SOTKonya كبداية للتواصل بين الطلاب.'},
    {'year': '2021', 'text': 'تنظيم أول فعالية تعريفية واجتماعات دورية للمنتسبين.'},
    {'year': '2022', 'text': 'إطلاق منصة الأخبار والفعاليات عبر التطبيق.'},
    {'year': '2023', 'text': 'بدء تعاون مع جمعيات طلابية أخرى وتنظيم مسابقات.'},
    {'year': '2024', 'text': 'زيادة عدد الأعضاء وافتتاح قنوات محتوى جديدة (منتدى، معرض).'},
  ];

  @override
  Widget build(BuildContext context) {
    final col = FirebaseFirestore.instance.collection('timeline').orderBy('date', descending: true);
    return Scaffold(
      appBar: AppBar(title: const Text('مسيرة التجمع'), actions: [
        if (_role == 'admin')
          IconButton(
            icon: Icon(_manageMode ? Icons.close : Icons.manage_accounts),
            tooltip: _manageMode ? 'إنهاء إدارة المسيرة' : 'إدارة المسيرة',
            onPressed: () {
              setState(() {
                _manageMode = !_manageMode;
                if (!_manageMode) {
                  _selectedIds.clear();
                }
              });
            },
          ),
        if (_role == 'admin' && _manageMode)
          IconButton(
            icon: const Icon(Icons.select_all),
            tooltip: 'تحديد الكل/إلغاء الكل',
            onPressed: () async {
              // fetch all ids and toggle selection
              final snap = await FirebaseFirestore.instance.collection('timeline').get();
              final ids = snap.docs.map((d) => d.id).toList();
              setState(() {
                if (_selectedIds.length == ids.length) {
                  _selectedIds.clear();
                } else {
                  _selectedIds.addAll(ids);
                }
              });
            },
          ),
      ]),
      body: Column(
        children: [
          // debug role indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.centerRight, child: Text('uid: ${FirebaseAuth.instance.currentUser?.uid ?? "-"} | role: ${_role ?? "-"}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: col.snapshots(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('خطأ في تحميل المسيرة: ${snap.error}'));
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            // show fallback
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _fallback.length,
              itemBuilder: (context, i) {
                final e = _fallback[i];
                return _TimelineTile(year: e['year']!, text: e['text']!);
              },
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final d = doc.data();
              final date = d['date'] as Timestamp?;
              final year = date != null ? DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch).year.toString() : (d['year'] ?? '—');
              final text = (d['text'] ?? d['description'] ?? '') as String;
              final imageUrl = (d['imageUrl'] ?? '') as String;
              final selected = _selectedIds.contains(doc.id);
              return Column(
                children: [
                  GestureDetector(
                    onTap: _manageMode
                        ? () {
                            setState(() {
                              if (selected) {
                                _selectedIds.remove(doc.id);
                              } else {
                                _selectedIds.add(doc.id);
                              }
                            });
                          }
                        : null,
                    child: Row(
                      children: [
                        if (_manageMode)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Checkbox(
                              value: selected,
                              onChanged: (_) {
                                setState(() {
                                  if (selected) {
                                    _selectedIds.remove(doc.id);
                                  } else {
                                    _selectedIds.add(doc.id);
                                  }
                                });
                              },
                            ),
                          ),
                        Expanded(child: _TimelineTile(year: year, text: text, imageUrl: imageUrl)),
                      ],
                    ),
                  ),
                  if (_role == 'admin' && !_manageMode)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            // edit
                            final edited = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TimelineEditorScreen(docId: doc.id, initialData: d)));
                            if (edited == true && mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الحدث')));
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('تعديل'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () async {
                            final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('تأكيد الحذف'), content: const Text('هل أنت متأكد أنك تريد حذف هذا الحدث؟'), actions: [TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('حذف'))]));
                            if (ok == true) {
                              // delete doc and storage image if exists
                              try {
                                if (imageUrl.isNotEmpty) {
                                  final ref = FirebaseStorage.instance.refFromURL(imageUrl);
                                  await ref.delete();
                                }
                              } catch (e) {
                                debugPrint('Error deleting timeline image: $e');
                              }
                              await FirebaseFirestore.instance.collection('timeline').doc(doc.id).delete();
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الحدث')));
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          label: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                ],
              );
            },
          );
        },
            ),
          ),
        ],
      ),
      floatingActionButton: (_role == 'admin')
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final created = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TimelineEditorScreen()));
                if (created == true) {
                  // reload role not necessary; the stream will update automatically
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة حدث إلى المسيرة')));
                }
              },
            )
          : null,
      bottomNavigationBar: (_manageMode && _selectedIds.isNotEmpty)
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: const Color(0xFF151C26),
                child: Row(
                  children: [
                    Expanded(child: Text('${_selectedIds.length} محدد', textAlign: TextAlign.right)),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () async {
                        final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('تأكيد الحذف'), content: Text('هل تريد حذف ${_selectedIds.length} حدثًا من المسيرة؟'), actions: [TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('حذف'))]));
                        if (ok == true) {
                          final ids = _selectedIds.toList();
                          for (final id in ids) {
                            try {
                              final doc = await FirebaseFirestore.instance.collection('timeline').doc(id).get();
                              final imageUrl = (doc.data()?['imageUrl'] ?? '') as String;
                              if (imageUrl.isNotEmpty) {
                                try { await FirebaseStorage.instance.refFromURL(imageUrl).delete(); } catch (e) { debugPrint('Failed deleting image: $e'); }
                              }
                              await FirebaseFirestore.instance.collection('timeline').doc(id).delete();
                            } catch (e) { debugPrint('Bulk delete error: $e'); }
                          }
                          setState(() { _selectedIds.clear(); _manageMode = false; });
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف العناصر المحددة')));
                        }
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('حذف المحدد'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String year;
  final String text;
  final String? imageUrl;
  const _TimelineTile({required this.year, required this.text, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1B2430),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              alignment: Alignment.center,
              child: Text(year, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(text, textAlign: TextAlign.right, textDirection: TextDirection.rtl),
              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                const SizedBox(height: 8),
                ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(imageUrl!, fit: BoxFit.cover)),
              ]
            ])),
          ],
        ),
      ),
    );
  }
} */
