import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/housing_model.dart';
import '../services/housing_service.dart';

class HousingEditorScreen extends StatefulWidget {
  final Housing? housing;
  const HousingEditorScreen({super.key, this.housing});

  @override
  State<HousingEditorScreen> createState() => _HousingEditorScreenState();
}

class _HousingEditorScreenState extends State<HousingEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _mapCtrl = TextEditingController();
  File? _pickedFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.housing != null) {
      _nameCtrl.text = widget.housing!.name;
      _descCtrl.text = widget.housing!.description;
      _mapCtrl.text = widget.housing!.mapUrl;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (p == null) return;
    setState(() => _pickedFile = File(p.path));
  }

  Future<String?> _uploadImage(String id) async {
    if (_pickedFile == null) return widget.housing?.imageUrl;
    final ref = FirebaseStorage.instance.ref().child('housing_images').child('$id.jpg');
    final task = await ref.putFile(_pickedFile!);
    return await task.ref.getDownloadURL();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final svc = HousingService();
      if (widget.housing == null) {
        // create
        final temp = Housing(id: '', name: _nameCtrl.text.trim(), description: _descCtrl.text.trim(), imageUrl: '', mapUrl: _mapCtrl.text.trim());
        final docRef = await svc.houses.add(temp.toMap());
        final url = await _uploadImage(docRef.id);
        if (url != null) await docRef.update({'imageUrl': url});
      } else {
        final id = widget.housing!.id;
        final url = await _uploadImage(id);
        final updated = Housing(id: id, name: _nameCtrl.text.trim(), description: _descCtrl.text.trim(), imageUrl: url ?? widget.housing!.imageUrl, mapUrl: _mapCtrl.text.trim());
        await svc.updateHousing(updated);
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.housing == null ? 'إضافة سكن' : 'تعديل السكن')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: _pickedFile != null ? FileImage(_pickedFile!) : (widget.housing != null && widget.housing!.imageUrl.isNotEmpty ? NetworkImage(widget.housing!.imageUrl) : null) as ImageProvider<Object>?,
                      child: (_pickedFile == null && (widget.housing == null || widget.housing!.imageUrl.isEmpty)) ? const Icon(Icons.home, size: 56) : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'اسم السكن', border: OutlineInputBorder()),
                    textAlign: TextAlign.right,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال اسم' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'الوصف', border: OutlineInputBorder()),
                    maxLines: 4,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mapCtrl,
                    decoration: const InputDecoration(labelText: 'رابط الخريطة (Google Maps)', border: OutlineInputBorder()),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save), label: Text(_saving ? 'جارٍ الحفظ...' : (widget.housing == null ? 'إضافة' : 'حفظ'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
