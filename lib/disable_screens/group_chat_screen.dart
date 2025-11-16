/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/forum_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'group_settings_screen.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String photoUrl;
  const GroupChatScreen({super.key, required this.groupId, required this.groupName, required this.photoUrl});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final ForumService _svc = ForumService();
  final _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  Future<void> _sendText() async {
    final txt = _ctrl.text.trim();
    if (txt.isEmpty) return;
    await _svc.sendMessage(widget.groupId, text: txt);
    _ctrl.clear();
    await Future.delayed(const Duration(milliseconds: 100));
    _scroll.animateTo(_scroll.position.maxScrollExtent + 80, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Future<void> _pickAndSendImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (p == null) return;
    final file = File(p.path);
    // upload image
    final ref = FirebaseFirestore.instance.collection('groups').doc(widget.groupId).collection('messages').doc();
    final storageRef = FirebaseStorage.instance.ref().child('group_messages').child('${ref.id}.jpg');
    final task = await storageRef.putFile(file);
    final url = await task.ref.getDownloadURL();
    await _svc.sendMessage(widget.groupId, imageUrl: url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName), actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () async { final r = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupSettingsScreen(groupId: widget.groupId))); if (r == true) Navigator.of(context).pop(); })]),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream: _svc.streamMessages(widget.groupId),
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text('خطأ: ${snap.error}'));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  controller: _scroll,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final m = docs[i].data();
                    final isMe = m['senderId'] == FirebaseAuth.instance.currentUser?.uid;
                    final text = (m['text'] ?? '') as String;
                    final imageUrl = (m['imageUrl'] ?? '') as String;
                    return Align(
                      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                      child: Card(
                        color: isMe ? const Color(0xFF2E7D32) : const Color(0xFF263238),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (text.isNotEmpty) Text(text, textDirection: TextDirection.rtl),
                              if (imageUrl.isNotEmpty) Padding(padding: const EdgeInsets.only(top:8.0), child: Image.network(imageUrl, width: 220)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.image), onPressed: _pickAndSendImage),
                Expanded(child: TextField(controller: _ctrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(hintText: 'اكتب رسالة...'))),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendText),
              ],
            ),
          )
        ],
      ),
    );
  }
}
*/