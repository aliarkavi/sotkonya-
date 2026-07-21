// lib/screens/yurt/edit_yurt_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sotkonya/model/yurt_model.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class EditYurtScreen extends ConsumerStatefulWidget {
  final YurtModel item;
  const EditYurtScreen({super.key, required this.item});

  @override
  ConsumerState<EditYurtScreen> createState() => _EditYurtScreenState();
}

class _EditYurtScreenState extends ConsumerState<EditYurtScreen> {
  late TextEditingController titleController;
  late TextEditingController durumController;
  late TextEditingController fiyatController;
  late TextEditingController personelController;
  late TextEditingController konumController;
  late TextEditingController konumLinkController;
  late TextEditingController telefoneController;
  late TextEditingController detailsController;

  final List<String> oldImages = [];
  final List<File> newImages = [];
  final primaryColor = const Color(0xFFeb5623);

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      setState(() {
        newImages.addAll(files.map((e) => File(e.path)));
      });
    }
  }

  Widget buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.item.title);
    durumController = TextEditingController(text: widget.item.durum);
    fiyatController = TextEditingController(text: widget.item.fiyat);
    personelController = TextEditingController(text: widget.item.personelData);
    konumController = TextEditingController(text: widget.item.konum);
    konumLinkController = TextEditingController(text: widget.item.konumLink);
    telefoneController = TextEditingController(text: widget.item.telefone);
    detailsController = TextEditingController(text: widget.item.details);

    oldImages.addAll(widget.item.images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل سكن")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الصور القديمة
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: oldImages
                .map((img) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            img,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => oldImages.remove(img));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),

          const SizedBox(height: 10),

          // الصور الجديدة
          if (newImages.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: newImages
                  .map((img) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              img,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => newImages.remove(img));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: pickImages,
            icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
            label: const Text("إضافة صور جديدة",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // الحقول
          buildField("اسم السكن", titleController),
          const SizedBox(height: 12),
          buildField("الحالة", durumController),
          const SizedBox(height: 12),
          buildField("الإيجار", fiyatController),
          const SizedBox(height: 12),
          buildField("معلومات التواصل / نوع الغرف", personelController),
          const SizedBox(height: 12),
          buildField("الموقع", konumController),
          const SizedBox(height: 12),
          buildField("رابط خرائط Google", konumLinkController),
          const SizedBox(height: 12),
          buildField("رقم الهاتف", telefoneController),
          const SizedBox(height: 12),
          buildField("نبذة عن السكن", detailsController, maxLines: 3),

          const SizedBox(height: 20),

          // زر الحفظ
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              List<String> uploadedImages = [...oldImages];

              // رفع الصور الجديدة فقط
              for (var img in newImages) {
                final url = await ImageUploadService.uploadImage(img);
                uploadedImages.add(url);
              }

              final updated = widget.item.copyWith(
                title: titleController.text.trim(),
                durum: durumController.text.trim(),
                fiyat: fiyatController.text.trim(),
                personelData: personelController.text.trim(),
                konum: konumController.text.trim(),
                konumLink: konumLinkController.text.trim(),
                telefone: telefoneController.text.trim(),
                details: detailsController.text.trim(),
                images: uploadedImages,
              );

              await ref.read(yurtProvider).updateYurt(updated);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("حفظ التغييرات",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}





