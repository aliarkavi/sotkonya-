import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/services/image_upload_service.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class EditNewsScreen extends ConsumerStatefulWidget {
  final NewsModel news;
  const EditNewsScreen({super.key, required this.news});

  @override
  ConsumerState<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends ConsumerState<EditNewsScreen> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController contentController;
  late List<String> existingImages;
  List<XFile> newImages = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    subtitleController = TextEditingController(text: widget.news.subtitle);
    contentController = TextEditingController(text: widget.news.details);
    existingImages = List.from(widget.news.images);
  }

  Widget buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editNews)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildField(l10n.newsTitle, titleController),
            const SizedBox(height: 12),
            buildField(l10n.summary, subtitleController),
            const SizedBox(height: 12),
            buildField(l10n.newsContent, contentController, maxLines: 5),
            const SizedBox(height: 12),

            // الصور الحالية
            if (existingImages.isNotEmpty) ...[
              Text(l10n.currentImages, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: existingImages.map((url) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(() => existingImages.remove(url)),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // إضافة صور جديدة
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final images = await picker.pickMultiImage(imageQuality: 50);
                if (images.isNotEmpty) {
                  setState(() => newImages.addAll(images));
                }
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: Text("${l10n.addNewImages} (${newImages.length})"),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                // رفع الصور الجديدة
                List<String> uploadedUrls = [];
                for (final img in newImages) {
                  final url = await ImageUploadService.uploadImage(File(img.path));
                  uploadedUrls.add(url);
                }

                final allImages = [...existingImages, ...uploadedUrls];

                final updated = widget.news.copyWith(
                  title: titleController.text.trim(),
                  subtitle: subtitleController.text.trim(),
                  details: contentController.text.trim(),
                  images: allImages,
                  imageUrl: allImages.isNotEmpty ? allImages.first : '',
                );

                await ref.read(newsProvider).updateNews(updated);
                if (mounted) Navigator.pop(context);
              },
              child: Text(l10n.saveChanges),
            ),
          ],
        ),
      ),
    );
  }
}





