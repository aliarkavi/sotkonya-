import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/providers/event_provider.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController registerUrlController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();

  DateTime? startDate;
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

  Future<void> pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
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
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة فعالية جديدة"),
      ),
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
                  image: selectedImage != null
                      ? DecorationImage(
                          image: FileImage(selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selectedImage == null
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
                startDate == null
                    ? "اختر تاريخ ووقت الفعالية"
                    : "${startDate!.day}/${startDate!.month}/${startDate!.year} - ${startDate!.hour.toString().padLeft(2, '0')}:${startDate!.minute.toString().padLeft(2, '0')}",
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
                if (startDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "الرجاء اختيار تاريخ ووقت الفعالية",
                      ),
                    ),
                  );
                  return;
                }

                String imageUrl = "";
                if (selectedImage != null) {
                  imageUrl =
                      await ImageUploadService.uploadImage(selectedImage!);
                }

                final DateTime sd = startDate!;
                final String dateText =
                    '${sd.day.toString().padLeft(2, '0')}/${sd.month.toString().padLeft(2, '0')}/${sd.year}';
                final String timeText =
                    '${sd.hour.toString().padLeft(2, '0')}:${sd.minute.toString().padLeft(2, '0')}';

                final String location = locationController.text.trim();
                final String description = descriptionController.text.trim();
                final String registerUrl = registerUrlController.text.trim();
                final String websiteUrl = websiteUrlController.text.trim();

                final item = EventModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: description,
                  location: location,
                  imageUrl: imageUrl,
                  registerUrl: registerUrl,
                  websiteUrl: websiteUrl,
                  startDate: sd,
                  date: dateText,
                  time: timeText,
                  konum: location,
                  kayitLink: registerUrl,
                  konumLink: websiteUrl,
                  details: description,
                );

                await eventProvider.addEvent(item);
                Navigator.pop(context);
              },
              child: const Text("حفظ الفعالية"),
            ),
          ],
        ),
      ),
    );
  }
}
