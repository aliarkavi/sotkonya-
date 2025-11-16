import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/forum_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class GroupSettingsScreen extends StatefulWidget {
  final String groupId;
  const GroupSettingsScreen({super.key, required this.groupId});

  @override
  State<GroupSettingsScreen> createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {
  final ForumService _svc = ForumService();
  final UserService _userSvc = UserService();
  TextEditingController _nameCtrl = TextEditingController();
  String _photoUrl = '';
  List<Map<String, dynamic>> _members = [];
  List<AppUser> _allUsers = [];
  bool _loading = true;
  String? _ownerId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();
    final d = doc.data() ?? {};
    final members = List<String>.from(d['members'] ?? []);
    final admins = List<String>.from(d['admins'] ?? []);
    final users = await _userSvc.getAllUsers();
    _allUsers = users;
    final memberDetails = users.where((u) => members.contains(u.id)).map((u) => {'id': u.id, 'name': u.name, 'photo': u.photoUrl, 'isAdmin': admins.contains(u.id)}).toList();
    setState(() {
      _nameCtrl = TextEditingController(text: d['name'] ?? '');
      _photoUrl = d['photoUrl'] ?? '';
      _members = memberDetails;
      _ownerId = d['ownerId'];
      _loading = false;
    });
  }

  Future<void> _showAddMemberDialog() async {
    // Build list of candidates (users not already in members)
    final existingIds = _members.map((m) => m['id'] as String).toSet();
    final candidates = _allUsers.where((u) => !existingIds.contains(u.id)).toList();
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يوجد مستخدمون متاحون للإضافة')));
      return;
    }

    final selected = <String>{};

    await showDialog<void>(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text('إضافة عضو/أعضاء'),
        content: SizedBox(
          width: double.maxFinite,
          height: 320,
          child: StatefulBuilder(builder: (context, setStateDialog) {
            return Column(
              children: [
                const Text('اختر واحداً أو أكثر ثم اضغط إضافة'),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: candidates.length,
                    itemBuilder: (context, i) {
                      final u = candidates[i];
                      final isSel = selected.contains(u.id);
                      return ListTile(
                        leading: u.photoUrl.isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(u.photoUrl)) : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(u.name),
                        subtitle: Text(u.email),
                        trailing: Checkbox(value: isSel, onChanged: (v) => setStateDialog(() => v == true ? selected.add(u.id) : selected.remove(u.id))),
                        onTap: () => setStateDialog(() => isSel ? selected.remove(u.id) : selected.add(u.id)),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: selected.isEmpty
                ? null
                : () async {
                    Navigator.of(ctx).pop();
                    setState(() => _loading = true);
                    try {
                      for (final uid in selected) {
                        await _svc.addMember(widget.groupId, uid);
                      }
                      await _load();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة الأعضاء')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ أثناء الإضافة: $e')));
                      setState(() => _loading = false);
                    }
                  },
            child: const Text('إضافة'),
          ),
        ],
      );
    });
  }

  Future<void> _pickAndUploadPhoto() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (p == null) return;
    final file = File(p.path);
    final ref = FirebaseStorage.instance.ref().child('group_images').child('${widget.groupId}.jpg');
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    await _svc.updateGroup(widget.groupId, {'photoUrl': url});
    setState(() => _photoUrl = url);
  }

  Future<void> _saveName() async {
    await _svc.updateGroup(widget.groupId, {'name': _nameCtrl.text.trim()});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ اسم المجموعة')));
  }

  Future<void> _leaveGroup() async {
    final me = FirebaseAuth.instance.currentUser!;
    await _svc.removeMember(widget.groupId, me.uid);
    Navigator.of(context).pop(true);
  }

  Future<void> _deleteGroup() async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('تأكيد'), content: const Text('هل تريد حذف المجموعة نهائياً؟'), actions: [TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('حذف'))]));
    if (ok == true) {
      await _svc.deleteGroup(widget.groupId);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser?.uid;
    final amIOwner = me != null && me == _ownerId;
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الغروب')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(onTap: _pickAndUploadPhoto, child: CircleAvatar(radius: 44, backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null, child: _photoUrl.isEmpty ? const Icon(Icons.group) : null)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'اسم المجموعة', border: OutlineInputBorder()), textAlign: TextAlign.right, textDirection: TextDirection.rtl),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _saveName, child: const Text('حفظ')),
                  const SizedBox(height: 8),
                  if (amIOwner) ElevatedButton(onPressed: _showAddMemberDialog, child: const Text('إضافة عضو')),
                  const SizedBox(height: 12),
                  const Text('الأعضاء', textAlign: TextAlign.right),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _members.length,
                      itemBuilder: (context, i) {
                        final m = _members[i];
                        final isAdmin = (m['isAdmin'] ?? false) as bool;
                        final isOwner = m['id'] == _ownerId;
                        return ListTile(
                          leading: m['photo'] != null && (m['photo'] as String).isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(m['photo'])) : const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(m['name'] ?? ''),
                          subtitle: isOwner ? const Text('المالك', textAlign: TextAlign.right) : (isAdmin ? const Text('مشرف', textAlign: TextAlign.right) : null),
                          trailing: amIOwner
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isOwner)
                                      IconButton(
                                        tooltip: isAdmin ? 'تخفيض من مشرف' : 'ترقية إلى مشرف',
                                        icon: Icon(Icons.security, color: isAdmin ? Colors.orangeAccent : Colors.greenAccent),
                                        onPressed: () async {
                                          try {
                                            if (isAdmin) {
                                              await _svc.demoteAdmin(widget.groupId, m['id']);
                                            } else {
                                              await _svc.promoteToAdmin(widget.groupId, m['id']);
                                            }
                                            await _load();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                                          }
                                        },
                                      ),
                                    if (!isOwner)
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                                        onPressed: () async {
                                          final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('تأكيد الحذف'), content: Text('هل تريد إزالة ${m['name']} من المجموعة؟'), actions: [TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('إزالة'))]));
                                          if (ok == true) {
                                            await _svc.removeMember(widget.groupId, m['id']);
                                            await _load();
                                          }
                                        },
                                      ),
                                  ],
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _leaveGroup, child: const Text('مغادرة المجموعة')),
                  if (amIOwner) ...[
                    const SizedBox(height: 8),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: _deleteGroup, child: const Text('حذف المجموعة')),
                  ]
                ],
              ),
            ),
    );
  }
}
