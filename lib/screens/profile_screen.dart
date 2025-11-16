import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/user_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _majorController = TextEditingController();
  String _gender = '';
  bool _loading = true;
  bool _saving = false;
  AppUser? _appUser;
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final svc = UserService();
    final appUser = await svc.getUser(user.uid);
    if (appUser != null) {
      _appUser = appUser;
      _nameController.text = appUser.name;
      _majorController.text = appUser.major;
      _gender = appUser.gender;
    } else {
      // create a minimal AppUser locally so fields are editable
      _appUser = AppUser(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        role: 'visitor',
        major: '',
        gender: '',
        photoUrl: user.photoURL ?? '',
      );
      _nameController.text = _appUser!.name;
    }

    setState(() => _loading = false);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (picked == null) return;
    setState(() => _pickedImageFile = File(picked.path));
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (_pickedImageFile == null) return _appUser?.photoUrl.isNotEmpty == true ? _appUser!.photoUrl : null;
    final ref = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
    final uploadTask = ref.putFile(_pickedImageFile!);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    try {
      final imageUrl = await _uploadProfileImage(user.uid);

      final updated = AppUser(
        id: user.uid,
        name: _nameController.text.trim(),
        email: user.email ?? '',
        role: _appUser?.role ?? 'visitor',
        major: _majorController.text.trim(),
        gender: _gender,
        photoUrl: imageUrl ?? (_appUser?.photoUrl ?? ''),
      );

      // Update Firestore
      await UserService().updateUser(updated);

      // Update FirebaseAuth profile (displayName/photoURL)
      await user.updateDisplayName(updated.name);
      if (updated.photoUrl.isNotEmpty) {
        await user.updatePhotoURL(updated.photoUrl);
      }

      // reload local state
      await _loadProfile();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ أثناء الحفظ: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // return to first route; auth listener in app should navigate to login
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 56,
                              backgroundImage: _pickedImageFile != null
                                  ? FileImage(_pickedImageFile!) as ImageProvider
                                  : (_appUser != null && _appUser!.photoUrl.isNotEmpty
                                      ? NetworkImage(_appUser!.photoUrl)
                                      : null),
                              child: (_pickedImageFile == null && (_appUser == null || _appUser!.photoUrl.isEmpty))
                                  ? const Icon(Icons.person, size: 56)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'الاسم', border: OutlineInputBorder()),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال الاسم' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _majorController,
                          decoration: const InputDecoration(labelText: 'القسم / التخصص', border: OutlineInputBorder()),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _gender.isEmpty ? null : _gender,
                          decoration: const InputDecoration(labelText: 'الجنس', border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('ذكر', textAlign: TextAlign.right)),
                            DropdownMenuItem(value: 'female', child: Text('أنثى', textAlign: TextAlign.right)),
                          ],
                          onChanged: (v) => setState(() => _gender = v ?? ''),
                        ),
                        const SizedBox(height: 12),
                        Text('البريد: ${_appUser?.email ?? '-'}', textAlign: TextAlign.right),
                        const SizedBox(height: 8),
                        Text('الدور: ${_appUser?.role ?? '-'}', textAlign: TextAlign.right),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _saving ? null : _save,
                                icon: const Icon(Icons.save),
                                label: _saving ? const Text('جارٍ الحفظ...') : const Text('حفظ'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _signOut,
                              icon: const Icon(Icons.exit_to_app),
                              label: const Text('تسجيل الخروج'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
