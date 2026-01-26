import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/providers/news_provider.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<File> selectedImages = [];
  final Color primaryColor = const Color(0xFF006db7);

  DateTime? selectedNewsDate;

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      setState(() {
        selectedImages.addAll(files.map((e) => File(e.path)));
      });
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedNewsDate = picked);
    }
  }

  Widget buildTextField(String label, TextEditingController c,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: c,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("إضافة خبر")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImages,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(14),
              ),
              child: selectedImages.isEmpty
                  ? const Center(child: Icon(Icons.add_photo_alternate))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(selectedImages.first,
                          fit: BoxFit.cover),
                    ),
            ),
          ),

          const SizedBox(height: 20),
          buildTextField("عنوان الخبر", titleController),
          const SizedBox(height: 12),
          buildTextField("الملخص", subtitleController),
          const SizedBox(height: 12),
          buildTextField("نص الخبر", contentController, maxLines: 5),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: pickDate,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range),
                  const SizedBox(width: 10),
                  Text(
                    selectedNewsDate == null
                        ? "اختر تاريخ الخبر"
                        : "${selectedNewsDate!.day}/${selectedNewsDate!.month}/${selectedNewsDate!.year}",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () async {
              final now = DateTime.now();
              List<String> uploadedImages = [];

              for (var file in selectedImages) {
                uploadedImages
                    .add(await ImageUploadService.uploadImage(file));
              }

              final item = NewsModel(
                id: now.millisecondsSinceEpoch.toString(),
                title: titleController.text.trim(),
                subtitle: subtitleController.text.trim(),
                details: contentController.text.trim(),
                imageUrl:
                    uploadedImages.isNotEmpty ? uploadedImages.first : "",
                images: uploadedImages,
                newsDate: selectedNewsDate ?? now,
                createdAt: now,
              );

              await newsProvider.addNews(item);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("نشر الخبر"),
          ),
        ],
      ),
    );
  }
}
