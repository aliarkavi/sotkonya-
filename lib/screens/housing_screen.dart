import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/housing_model.dart';
import '../services/housing_service.dart';
import '../services/user_service.dart';
import 'housing_editor_screen.dart';

class HousingScreen extends StatefulWidget {
  const HousingScreen({super.key});

  @override
  State<HousingScreen> createState() => _HousingScreenState();
}

class _HousingScreenState extends State<HousingScreen> {
  final _svc = HousingService();
  String _role = 'visitor';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final appUser = await UserService().getUser(user.uid);
    setState(() => _role = appUser?.role ?? 'visitor');
  }

  Future<void> _openMap(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط')));
    }
  }

  void _onAdd() async {
    final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HousingEditorScreen()));
    if (res == true) {
      // refresh handled by stream
    }
  }

  void _onEdit(Housing h) async {
    final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => HousingEditorScreen(housing: h)));
    if (res == true) {
      // stream updates
    }
  }

  Future<void> _onDelete(String id) async {
    final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('تأكيد الحذف'), content: const Text('هل تريد حذف هذا الإعلان؟'), actions: [TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف'))]));
    if (ok == true) {
      await _svc.deleteHousing(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السكن'),
        actions: [if (_role == 'admin') IconButton(icon: const Icon(Icons.add), onPressed: _onAdd)],
      ),
      body: StreamBuilder<List<Housing>>(
        stream: _svc.streamHousing(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text('لا توجد إعلانات بعد'));
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final h = items[i];
              return Card(
                child: ListTile(
                  leading: h.imageUrl.isNotEmpty ? Image.network(h.imageUrl, width: 72, fit: BoxFit.cover) : const Icon(Icons.home, size: 48),
                  title: Text(h.name, textAlign: TextAlign.right),
                  subtitle: Text(h.description, textAlign: TextAlign.right),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(icon: const Icon(Icons.map), onPressed: () => _openMap(h.mapUrl)),
                      if (_role == 'admin') IconButton(icon: const Icon(Icons.edit), onPressed: () => _onEdit(h)),
                      if (_role == 'admin') IconButton(icon: const Icon(Icons.delete), onPressed: () => _onDelete(h.id)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
