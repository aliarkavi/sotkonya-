// lib/screens/yurt/add_yurt_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/yurt_model.dart';
import '../../providers/yurt_provider.dart';

class AddYurtScreen extends StatefulWidget {
  const AddYurtScreen({super.key});

  @override
  State<AddYurtScreen> createState() => _AddYurtScreenState();
}

class _AddYurtScreenState extends State<AddYurtScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durumController = TextEditingController();
  final TextEditingController personelController = TextEditingController();
  final TextEditingController fiyatController = TextEditingController();
  final TextEditingController konumController = TextEditingController();
  final TextEditingController konumLinkController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController imagesController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    durumController.dispose();
    personelController.dispose();
    fiyatController.dispose();
    konumController.dispose();
    konumLinkController.dispose();
    telefoneController.dispose();
    detailsController.dispose();
    imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YurtProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة سكن"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "اسم السكن"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durumController,
              decoration: const InputDecoration(labelText: "الحالة (مثال: متاح)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fiyatController,
              decoration:
                  const InputDecoration(labelText: "الإيجار (مثال: 11,000 ليرة شهريًا)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: personelController,
              decoration:
                  const InputDecoration(labelText: "معلومات التواصل / نوع الغرف"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: konumController,
              decoration:
                  const InputDecoration(labelText: "الموقع (وصف نصي، مثال: قرب الحرم)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: konumLinkController,
              decoration: const InputDecoration(
                  labelText: "رابط الموقع على الخريطة (Google Maps)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: detailsController,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: "نبذة عن السكن / التفاصيل"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: imagesController,
              decoration: const InputDecoration(
                labelText:
                    "روابط أو مسارات الصور (افصل بين كل رابط بفاصلة , )",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final images = imagesController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final item = YurtModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  durum: durumController.text.trim(),
                  fiyat: fiyatController.text.trim(),
                  personelData: personelController.text.trim(),
                  konum: konumController.text.trim(),
                  konumLink: konumLinkController.text.trim(),
                  telefone: telefoneController.text.trim(),
                  details: detailsController.text.trim(),
                  images: images,
                );

                await provider.addYurt(item);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("حفظ السكن"),
            ),
          ],
        ),
      ),
    );
  }
}
