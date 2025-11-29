import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/news_item.dart';
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

  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة خبر"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// اختيار صورة
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: selectedImage != null
                      ? DecorationImage(
                          image: FileImage(selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selectedImage == null
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
                String imageUrl = "";

                if (selectedImage != null) {
                  imageUrl = await ImageUploadService.uploadImage(selectedImage!);
                }

                final item = NewsItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  subtitle: subtitleController.text.trim(),
                  content: contentController.text.trim(),
                  imageUrl: imageUrl,
                  createdAt: DateTime.now(),
                );

                await newsProvider.addNews(item);
                Navigator.pop(context);
              },
              child: const Text("نشر الخبر"),
            ),
          ],
        ),
      ),
    );
  }
}
