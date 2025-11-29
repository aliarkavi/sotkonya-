import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/news_item.dart';
import 'package:sotkonya/providers/news_provider.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class EditNewsScreen extends StatefulWidget {
  final NewsItem news;
  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController contentController;

  File? newImage;
  String? imageUrl;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        newImage = File(file.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    subtitleController = TextEditingController(text: widget.news.subtitle);
    contentController = TextEditingController(text: widget.news.content);
    imageUrl = widget.news.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("تعديل خبر")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: newImage != null
                      ? DecorationImage(image: FileImage(newImage!), fit: BoxFit.cover)
                      : imageUrl!.isNotEmpty
                          ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                          : null,
                ),
                child: (newImage == null && imageUrl!.isEmpty)
                    ? const Center(
                        child: Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "عنوان الخبر"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(labelText: "الملخص"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: "نص الخبر"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                String finalImageUrl = imageUrl ?? "";

                if (newImage != null) {
                  finalImageUrl =
                      await ImageUploadService.uploadImage(newImage!);
                }

                final updated = NewsItem(
                  id: widget.news.id,
                  title: titleController.text.trim(),
                  subtitle: subtitleController.text.trim(),
                  content: contentController.text.trim(),
                  imageUrl: finalImageUrl,
                  createdAt: widget.news.createdAt,
                );

                await newsProvider.updateNews(updated);
                Navigator.pop(context);
              },
              child: const Text("حفظ التعديلات"),
            ),
          ],
        ),
      ),
    );
  }
}
