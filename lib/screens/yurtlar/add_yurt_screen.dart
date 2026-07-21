// lib/screens/yurt/add_yurt_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sotkonya/model/yurt_model.dart';
import 'package:sotkonya/services/image_upload_service.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class AddYurtScreen extends ConsumerStatefulWidget {
  const AddYurtScreen({super.key});

  @override
  ConsumerState<AddYurtScreen> createState() => _AddYurtScreenState();
}

class _AddYurtScreenState extends ConsumerState<AddYurtScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durumController = TextEditingController();
  final TextEditingController fiyatController = TextEditingController();
  final TextEditingController personelController = TextEditingController();
  final TextEditingController konumController = TextEditingController();
  final TextEditingController konumLinkController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  final List<File> selectedImages = [];
  final primaryColor = const Color(0xFFeb5623);

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      setState(() {
        selectedImages.addAll(files.map((e) => File(e.path)));
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addHousing)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // اختيار الصور
          GestureDetector(
            onTap: pickImages,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(14),
              ),
              child: selectedImages.isEmpty
                  ? const Center(
                      child: Icon(Icons.add_photo_alternate,
                          color: Colors.grey, size: 40),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        selectedImages.first,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 10),

          // عرض الصور المختارة
          if (selectedImages.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedImages
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
                                setState(() {
                                  selectedImages.remove(img);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),

          const SizedBox(height: 20),

          buildField(l10n.housingName, titleController),
          const SizedBox(height: 12),
          buildField(l10n.status, durumController),
          const SizedBox(height: 12),
          buildField(l10n.rent, fiyatController),
          const SizedBox(height: 12),
          buildField(l10n.contactRoomsInfo, personelController),
          const SizedBox(height: 12),
          buildField(l10n.location, konumController),
          const SizedBox(height: 12),
          buildField(l10n.googleMapsLink, konumLinkController),
          const SizedBox(height: 12),
          buildField(l10n.phone, telefoneController),
          const SizedBox(height: 12),
          buildField(l10n.aboutHousing, detailsController, maxLines: 3),

          const SizedBox(height: 20),

          // زر الحفظ
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              List<String> uploadedImages = [];

              // رفع الصور
              for (var img in selectedImages) {
                final url = await ImageUploadService.uploadImage(img);
                uploadedImages.add(url);
              }

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
                images: uploadedImages,
              );

              await ref.read(yurtProvider).addYurt(item);
              if (mounted) Navigator.pop(context);
            },
            child: Text(l10n.saveHousing,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}





