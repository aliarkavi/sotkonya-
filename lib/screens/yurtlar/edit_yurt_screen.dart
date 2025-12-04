// lib/screens/yurt/edit_yurt_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/yurt_model.dart';
import '../../providers/yurt_provider.dart';

class EditYurtScreen extends StatefulWidget {
  final YurtModel item;
  const EditYurtScreen({super.key, required this.item});

  @override
  State<EditYurtScreen> createState() => _EditYurtScreenState();
}

class _EditYurtScreenState extends State<EditYurtScreen> {
  late TextEditingController titleController;
  late TextEditingController durumController;
  late TextEditingController personelController;
  late TextEditingController fiyatController;
  late TextEditingController konumController;
  late TextEditingController konumLinkController;
  late TextEditingController telefoneController;
  late TextEditingController detailsController;
  late TextEditingController imagesController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    durumController = TextEditingController(text: widget.item.durum);
    personelController =
        TextEditingController(text: widget.item.personelData);
    fiyatController = TextEditingController(text: widget.item.fiyat);
    konumController = TextEditingController(text: widget.item.konum);
    konumLinkController =
        TextEditingController(text: widget.item.konumLink);
    telefoneController = TextEditingController(text: widget.item.telefone);
    detailsController = TextEditingController(text: widget.item.details);
    imagesController =
        TextEditingController(text: widget.item.images.join(', '));
  }

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
        title: const Text("تعديل سكن"),
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
              decoration: const InputDecoration(labelText: "الحالة"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fiyatController,
              decoration: const InputDecoration(labelText: "الإيجار"),
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
              decoration: const InputDecoration(labelText: "الموقع"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: konumLinkController,
              decoration:
                  const InputDecoration(labelText: "رابط الموقع على الخريطة"),
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
                      "روابط أو مسارات الصور (افصل بين كل رابط بفاصلة , )"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final images = imagesController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final updated = widget.item.copyWith(
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

                await provider.updateYurt(updated);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("حفظ التغييرات"),
            ),
          ],
        ),
      ),
    );
  }
}
