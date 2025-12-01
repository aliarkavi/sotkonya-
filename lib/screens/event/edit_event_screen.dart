import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/event_item.dart';
import 'package:sotkonya/providers/event_provider.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class EditEventScreen extends StatefulWidget {
  final EventItem event;
  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController registerUrlController;
  late TextEditingController websiteUrlController;

  File? newImage;
  String? imageUrl;
  late DateTime startDate;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        newImage = File(file.path);
      });
    }
  }

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(startDate.year - 1),
      lastDate: DateTime(startDate.year + 5),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDate),
    );
    if (time == null) {
      setState(() {
        startDate = DateTime(date.year, date.month, date.day);
      });
      return;
    }

    setState(() {
      startDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    descriptionController =
        TextEditingController(text: widget.event.description);
    locationController = TextEditingController(text: widget.event.location);
    registerUrlController =
        TextEditingController(text: widget.event.registerUrl);
    websiteUrlController =
        TextEditingController(text: widget.event.websiteUrl);
    imageUrl = widget.event.imageUrl;
    startDate = widget.event.startDate;
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("تعديل فعالية")),
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
                      ? DecorationImage(
                          image: FileImage(newImage!),
                          fit: BoxFit.cover,
                        )
                      : (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: (newImage == null &&
                        (imageUrl == null || imageUrl!.isEmpty))
                    ? const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "عنوان الفعالية",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "وصف / تفاصيل الفعالية",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "الموقع",
              ),
            ),

            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("تاريخ ووقت الفعالية"),
              subtitle: Text(
                "${startDate.day}/${startDate.month}/${startDate.year} - ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}",
              ),
              trailing: const Icon(Icons.date_range),
              onTap: pickDateTime,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: registerUrlController,
              decoration: const InputDecoration(
                labelText: "رابط التسجيل (اختياري)",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: websiteUrlController,
              decoration: const InputDecoration(
                labelText: "رابط الموقع/المزيد عن الفعالية (اختياري)",
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                String finalImageUrl = imageUrl ?? "";

                if (newImage != null) {
                  finalImageUrl =
                      await ImageUploadService.uploadImage(newImage!);
                }

                final updated = EventItem(
                  id: widget.event.id,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  location: locationController.text.trim(),
                  imageUrl: finalImageUrl,
                  registerUrl: registerUrlController.text.trim(),
                  websiteUrl: websiteUrlController.text.trim(),
                  startDate: startDate,
                );

                await eventProvider.updateEvent(updated);
                Navigator.pop(context);
              },
              child: const Text("حفظ التغييرات"),
            ),
          ],
        ),
      ),
    );
  }
}

