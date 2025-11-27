import 'package:flutter/material.dart';
import '../services/content_service.dart';

class EventEditorScreen extends StatefulWidget {
  const EventEditorScreen({super.key, this.docId, this.initialData});

  final String? docId;
  final Map<String, dynamic>? initialData;

  @override
  State<EventEditorScreen> createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  final TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _location = TextEditingController();
  bool _saving = false;
  final TextEditingController _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _title.text = widget.initialData!['title'] ?? '';
      _description.text = widget.initialData!['description'] ?? '';
      _location.text = widget.initialData!['location'] ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final svc = ContentService();
    final payload = {
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'location': _location.text.trim(),
      'startDate': DateTime.now(),
      'createdAt': DateTime.now(),
    };
    try {
      if (widget.docId == null) {
        await svc.createEvent(payload);
      } else {
        await svc.updateEvent(widget.docId!, payload);
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
      appBar: AppBar(title: Text(isEdit ? 'تعديل فعالية' : 'إنشاء فعالية')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'العنوان'),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                validator: (v) => v==null||v.isEmpty? 'مطلوب':null,
              ),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'المكان'),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              Expanded(
                child: TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                  maxLines: null,
                  expands: true,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 12),
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
