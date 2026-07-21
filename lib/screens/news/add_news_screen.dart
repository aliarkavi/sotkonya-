import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/services/image_upload_service.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class AddNewsScreen extends ConsumerStatefulWidget {
  const AddNewsScreen({super.key});

  @override
  ConsumerState<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends ConsumerState<AddNewsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  DateTime? selectedDate;
  List<XFile> selectedImages = [];

  Widget buildTextField(String label, TextEditingController controller,
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

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 50);
    if (images.isNotEmpty) {
      setState(() => selectedImages.addAll(images));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addNewNews)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildTextField(l10n.newsTitle, titleController),
            const SizedBox(height: 12),
            buildTextField(l10n.summary, subtitleController),
            const SizedBox(height: 12),
            buildTextField(l10n.newsContent, contentController, maxLines: 5),
            const SizedBox(height: 12),

            // تاريخ الخبر
            ListTile(
              title: Text(
                selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : l10n.selectNewsDate,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
            ),
            const SizedBox(height: 12),

            // اختيار الصور
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.image),
              label: Text("${l10n.selectImages} (${selectedImages.length})"),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.enterNewsTitlePrompt)),
                  );
                  return;
                }

                List<String> imageUrls = [];
                for (final img in selectedImages) {
                  final url = await ImageUploadService.uploadImage(File(img.path));
                  imageUrls.add(url);
                }

                final news = NewsModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  subtitle: subtitleController.text.trim(),
                  details: contentController.text.trim(),
                  imageUrl: imageUrls.isNotEmpty ? imageUrls.first : '',
                  images: imageUrls,
                  newsDate: selectedDate ?? DateTime.now(),
                  createdAt: DateTime.now(),
                );

                await ref.read(newsProvider).addNews(news);
                if (mounted) Navigator.pop(context);
              },
              child: Text(l10n.publishNews),
            ),
          ],
        ),
      ),
    );
  }
}





