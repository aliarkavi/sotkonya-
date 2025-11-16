import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/forum_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  final ForumService _svc = ForumService();
  final UserService _userSvc = UserService();
  File? _pickedImage;
  List<AppUser> _users = [];
  final Set<String> _selected = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final list = await _userSvc.getAllUsers();
    final me = FirebaseAuth.instance.currentUser;
    setState(() {
      _users = list.where((u) => u.id != me?.uid).toList();
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (p == null) return;
    setState(() => _pickedImage = File(p.path));
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال اسم المجموعة')));
      return;
    }
    final me = FirebaseAuth.instance.currentUser!;
    final members = [me.uid, ..._selected];
    try {
      final id = await _svc.createGroup(name: name, members: members, photo: _pickedImage);
      Navigator.of(context).pop(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ بإنشاء المجموعة: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء غروب')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
                      child: _pickedImage == null ? const Icon(Icons.group, size: 44) : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'اسم المجموعة', border: OutlineInputBorder()),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  const Text('أضف أعضاء', textAlign: TextAlign.right),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, i) {
                        final u = _users[i];
                        final sel = _selected.contains(u.id);
                        return CheckboxListTile(
                          value: sel,
                          onChanged: (v) => setState(() => v == true ? _selected.add(u.id) : _selected.remove(u.id)),
                          title: Text(u.name.isNotEmpty ? u.name : u.email),
                          secondary: u.photoUrl.isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(u.photoUrl)) : const CircleAvatar(child: Icon(Icons.person)),
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(onPressed: _create, icon: const Icon(Icons.check), label: const Text('إنشاء'))
                ],
              ),
            ),
    );
  }
}
