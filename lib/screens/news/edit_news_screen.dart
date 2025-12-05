// lib/screens/news/edit_news_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/providers/news_provider.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class EditNewsScreen extends StatefulWidget {
  final NewsModel news;
  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController contentController;

  List<String> oldImages = [];
  List<File> newImages = [];
  final Color primaryColor = const Color(0xFF006db7);

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      setState(() {
        newImages.addAll(files.map((e) => File(e.path)));
      });
    }
  }

  Widget buildField(String label, TextEditingController c,
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
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    subtitleController = TextEditingController(text: widget.news.subtitle);
    contentController = TextEditingController(text: widget.news.details);

    oldImages = [...widget.news.images];
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("تعديل خبر")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // عرض الصور القديمة
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: oldImages
                .map((img) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(img,
                              width: 90, height: 90, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                oldImages.remove(img);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              padding: const EdgeInsets.all(3),
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

          // عرض الصور الجديدة المختارة
          if (newImages.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: newImages
                  .map((img) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(img,
                                width: 90, height: 90, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  newImages.remove(img);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(3),
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

          // زر إضافة صور جديدة
          ElevatedButton.icon(
            onPressed: pickImages,
            icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
            label: const Text("إضافة صور جديدة",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 20),

          buildField("عنوان الخبر", titleController),
          const SizedBox(height: 14),

          buildField("الملخص", subtitleController),
          const SizedBox(height: 14),

          buildField("نص الخبر", contentController, maxLines: 5),
          const SizedBox(height: 24),

          // زر حفظ التعديلات
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              List<String> uploaded = [...oldImages];

              // رفع الصور الجديدة فقط
              for (var f in newImages) {
                final url = await ImageUploadService.uploadImage(f);
                uploaded.add(url);
              }

              final updated = widget.news.copyWith(
                title: titleController.text.trim(),
                subtitle: subtitleController.text.trim(),
                details: contentController.text.trim(),
                imageUrl: uploaded.isNotEmpty ? uploaded.first : "",
                images: uploaded,
              );

              await newsProvider.updateNews(updated);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("حفظ التعديلات",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
