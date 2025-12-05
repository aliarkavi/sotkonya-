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
  final TextEditingController maxUsersController = TextEditingController();

  bool allowRegister = false;

  DateTime? startDate;
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => selectedImage = File(file.path));
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

    setState(() {
      startDate = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      );
    });
  }

  Widget label(String txt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        txt,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget input(TextEditingController controller, {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    const primaryColor = Color(0xFFf2b200);

    return Scaffold(
      appBar: AppBar(title: const Text("إضافة فعالية جديدة")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // صورة الفعالية
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(15),
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

          const SizedBox(height: 20),
          label("عنوان الفعالية"),
          input(titleController),

          const SizedBox(height: 16),
          label("وصف الفعالية"),
          input(descriptionController, maxLines: 3),

          const SizedBox(height: 16),
          label("الموقع"),
          input(locationController),

          const SizedBox(height: 16),
          label("التاريخ والوقت"),
          GestureDetector(
            onTap: pickDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range, color: primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    startDate == null
                        ? "اختر تاريخ ووقت الفعالية"
                        : "${startDate!.day}/${startDate!.month}/${startDate!.year} - ${startDate!.hour}:${startDate!.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          label("رابط التسجيل (اختياري)"),
          input(registerUrlController),

          const SizedBox(height: 16),
          label("رابط الموقع (اختياري)"),
          input(websiteUrlController),

          const SizedBox(height: 20),
          // السويتش
          Row(
            children: [
              const Text(
                "السماح بالتسجيل على الفعالية",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Switch(
                activeColor: primaryColor,
                value: allowRegister,
                onChanged: (v) => setState(() => allowRegister = v),
              ),
            ],
          ),

          // يظهر فقط عندما يكون السويتش فعال
          if (allowRegister) ...[
            const SizedBox(height: 16),
            label("الحد الأقصى للمشاركين"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: maxUsersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ],

          const SizedBox(height: 30),
          // زر الحفظ
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: primaryColor,
              ),
              onPressed: () async {
                if (startDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("الرجاء اختيار تاريخ ووقت الفعالية"),
                  ));
                  return;
                }

                String imageUrl = "";
                if (selectedImage != null) {
                  imageUrl = await ImageUploadService.uploadImage(selectedImage!);
                }

                final sd = startDate!;
                final item = EventModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  location: locationController.text.trim(),
                  imageUrl: imageUrl,
                  registerUrl: registerUrlController.text.trim(),
                  websiteUrl: websiteUrlController.text.trim(),
                  startDate: sd,
                  date:
                      "${sd.day.toString().padLeft(2, '0')}/${sd.month.toString().padLeft(2, '0')}/${sd.year}",
                  time:
                      "${sd.hour.toString().padLeft(2, '0')}:${sd.minute.toString().padLeft(2, '0')}",
                  konum: locationController.text.trim(),
                  kayitLink: registerUrlController.text.trim(),
                  konumLink: websiteUrlController.text.trim(),
                  details: descriptionController.text.trim(),
                  maxRegisteredUsers: allowRegister
                      ? int.tryParse(maxUsersController.text.trim()) ?? 0
                      : null,
                  registeredUsers: allowRegister ? 0 : null,
                );

                await eventProvider.addEvent(item);
                Navigator.pop(context);
              },
              child: const Text(
                "حفظ الفعالية",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
