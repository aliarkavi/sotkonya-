import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TimelineEditorScreen extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? initialData;
  const TimelineEditorScreen({super.key, this.docId, this.initialData});

  @override
  State<TimelineEditorScreen> createState() => _TimelineEditorScreenState();
}

class _TimelineEditorScreenState extends State<TimelineEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _archiveController = TextEditingController();
  bool _loading = false;
  XFile? _pickedImage;
  String? _initialImageUrl;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _textController.text = widget.initialData!['text'] ?? widget.initialData!['description'] ?? '';
      final ts = widget.initialData!['date'] as Timestamp?;
      if (ts != null) _selectedDate = DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);
      _initialImageUrl = widget.initialData!['imageUrl'] as String?;
      _archiveController.text = widget.initialData!['archiveUrl'] ?? '';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _archiveController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (img != null) setState(() { _pickedImage = img; });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;
    setState(() => _loading = true);
    try {
      final col = FirebaseFirestore.instance.collection('timeline');
      final payload = {
        'text': _textController.text.trim(),
        'date': Timestamp.fromDate(_selectedDate!),
        'archiveUrl': _archiveController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };
      try {
        if (_pickedImage != null) {
          final oldUrl = _initialImageUrl;
          final ref = FirebaseStorage.instance.ref().child('timeline_images').child('${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}');
          final uploadTask = ref.putData(await _pickedImage!.readAsBytes());
          uploadTask.snapshotEvents.listen((s) {
            setState(() { _uploadProgress = (s.bytesTransferred / (s.totalBytes == 0 ? 1 : s.totalBytes)); });
          });
          final snap = await uploadTask.whenComplete(() {});
          final url = await snap.ref.getDownloadURL();
          payload['imageUrl'] = url as Object;
          // delete old image if editing and there was an old url different from the new one
          if (oldUrl != null && oldUrl.isNotEmpty && oldUrl != url) {
            try { await FirebaseStorage.instance.refFromURL(oldUrl).delete(); } catch (e) { debugPrint('Failed deleting old timeline image: $e'); }
          }
          // update initial image url to new one
          _initialImageUrl = url;
        } else if (_initialImageUrl != null && _initialImageUrl!.isNotEmpty) {
          payload['imageUrl'] = _initialImageUrl as Object;
        }
      } catch (e) {
        debugPrint('Timeline image upload error: $e');
      }

      if (widget.docId == null) {
        await col.add(payload);
      } else {
        payload['updatedAt'] = FieldValue.serverTimestamp();
        await col.doc(widget.docId).update(payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('Error saving timeline: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل حفظ الحدث')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.docId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'تعديل حدث في المسيرة' : 'أضف حدثًا في المسيرة')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(8)),
                  child: _pickedImage != null
                      ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover)
                      : (_initialImageUrl != null && _initialImageUrl!.isNotEmpty)
                          ? Image.network(_initialImageUrl!, fit: BoxFit.cover)
                          : const Center(child: Text('اضغط لإضافة صورة أرشيفية (اختياري)', style: TextStyle(color: Colors.white54))),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _textController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'وصف الحدث'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال نص للحدث' : null,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _archiveController,
                decoration: const InputDecoration(labelText: 'رابط مستند/أرشيف (اختياري)'),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(_selectedDate == null ? 'لم يتم اختيار تاريخ' : _selectedDate!.toLocal().toString(), textAlign: TextAlign.right)),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _pickDate, child: const Text('اختر تاريخ')),
                ],
              ),
              if (_uploadProgress > 0 && _uploadProgress < 1)
                Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: LinearProgressIndicator(value: _uploadProgress)),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading ? const CircularProgressIndicator() : const Text('حفظ'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
