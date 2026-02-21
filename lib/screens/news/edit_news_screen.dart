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
  DateTime? selectedNewsDate;

  final Color primaryColor = const Color(0xFF006db7);

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    subtitleController = TextEditingController(text: widget.news.subtitle);
    contentController = TextEditingController(text: widget.news.details);
    oldImages = [...widget.news.images];
    selectedNewsDate = widget.news.newsDate;
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      setState(() => newImages.addAll(files.map((e) => File(e.path))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("تعديل خبر")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (oldImages.isEmpty && newImages.isEmpty)
            GestureDetector(
              onTap: pickImages,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                    child: Icon(Icons.add_photo_alternate,
                        size: 40, color: Colors.grey)),
              ),
            )
          else
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: oldImages.length + newImages.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  if (index == oldImages.length + newImages.length) {
                    return GestureDetector(
                      onTap: pickImages,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                            child: Icon(Icons.add, color: Colors.grey)),
                      ),
                    );
                  }

                  final isOld = index < oldImages.length;
                  final imageWidget = isOld
                      ? Image.network(oldImages[index],
                          width: 180, height: 180, fit: BoxFit.cover)
                      : Image.file(newImages[index - oldImages.length],
                          width: 180, height: 180, fit: BoxFit.cover);

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: imageWidget,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isOld) {
                                oldImages.removeAt(index);
                              } else {
                                newImages.removeAt(index - oldImages.length);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          buildField("عنوان الخبر", titleController),
          const SizedBox(height: 12),
          buildField("الملخص", subtitleController),
          const SizedBox(height: 12),
          buildField("نص الخبر", contentController, maxLines: 5),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedNewsDate!,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => selectedNewsDate = picked);
              }
            },
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
                    "${selectedNewsDate!.day}/${selectedNewsDate!.month}/${selectedNewsDate!.year}",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () async {
              List<String> uploaded = [...oldImages];
              for (var f in newImages) {
                uploaded.add(await ImageUploadService.uploadImage(f));
              }

              final updated = widget.news.copyWith(
                title: titleController.text.trim(),
                subtitle: subtitleController.text.trim(),
                details: contentController.text.trim(),
                imageUrl: uploaded.isNotEmpty ? uploaded.first : "",
                images: uploaded,
                newsDate: selectedNewsDate,
              );

              await newsProvider.updateNews(updated);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("حفظ التعديلات"),
          ),
        ],
      ),
    );
  }

  Widget buildField(String label, TextEditingController c,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(controller: c, maxLines: maxLines),
      ],
    );
  }
}
