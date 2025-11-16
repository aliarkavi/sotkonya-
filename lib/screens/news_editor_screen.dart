import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../services/content_service.dart';

class NewsEditorScreen extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? initialData;
  const NewsEditorScreen({super.key, this.docId, this.initialData});

  @override
  State<NewsEditorScreen> createState() => _NewsEditorScreenState();
}

class _NewsEditorScreenState extends State<NewsEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _excerpt = TextEditingController();
  final TextEditingController _body = TextEditingController();
  bool _saving = false;
  XFile? _pickedImage;
  double _uploadProgress = 0.0;
  String? _initialImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _title.text = widget.initialData!['title'] ?? '';
      _excerpt.text = widget.initialData!['excerpt'] ?? '';
      _body.text = widget.initialData!['body'] ?? '';
      _initialImageUrl = widget.initialData!['imageUrl'] as String?;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _excerpt.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final svc = ContentService();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final payload = {
      'title': _title.text.trim(),
      'excerpt': _excerpt.text.trim(),
      'body': _body.text.trim(),
      'authorId': uid ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };
    try {
      if (_pickedImage != null) {
        // upload image to Firebase Storage
        final ref = FirebaseStorage.instance.ref().child('news_images').child('${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}');
        final uploadTask = ref.putData(await _pickedImage!.readAsBytes());
        uploadTask.snapshotEvents.listen((s) {
          setState(() { _uploadProgress = (s.bytesTransferred / (s.totalBytes == 0 ? 1 : s.totalBytes)); });
        });
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();
        payload['imageUrl'] = imageUrl;
      }
    } catch (e) {
      debugPrint('Image upload error: $e');
      // proceed without image
    }
    try {
      if (widget.docId == null) {
        await svc.createNews(payload);
      } else {
        // when updating, set an updatedAt timestamp
        payload['updatedAt'] = FieldValue.serverTimestamp();
        await svc.updateNews(widget.docId!, payload);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _saving = false);
      await showDialog(context: context, builder: (_) => AlertDialog(title: const Text('خطأ'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.docId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'تعديل خبر' : 'إنشاء خبر')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // image picker and preview
              GestureDetector(
                onTap: () async {
                  final img = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
                  if (img != null) setState(() { _pickedImage = img; });
                },
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(8)),
                  child: _pickedImage != null
                      ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover)
                      : (_initialImageUrl != null && _initialImageUrl!.isNotEmpty)
                          ? Image.network(_initialImageUrl!, fit: BoxFit.cover)
                          : const Center(child: Text('اضغط لإضافة صورة (اختياري)', style: TextStyle(color: Colors.white54))),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'العنوان'),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                validator: (v) => v==null||v.isEmpty? 'مطلوب':null,
              ),
              TextFormField(
                controller: _excerpt,
                decoration: const InputDecoration(labelText: 'مقتطف'),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              Expanded(
                child: TextFormField(
                  controller: _body,
                  decoration: const InputDecoration(labelText: 'النص'),
                  maxLines: null,
                  expands: true,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 12),
              if (_uploadProgress > 0 && _uploadProgress < 1)
                LinearProgressIndicator(value: _uploadProgress),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _saving?null:_save, child: _saving?const CircularProgressIndicator():Text(isEdit?'حفظ':'نشر')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
