import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/providers/event_provider.dart';
import 'package:sotkonya/services/image_upload_service.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;

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
  late TextEditingController maxUsersController;

  bool allowRegister = false;
  File? newImage;
  String? imageUrl;
  late DateTime startDate;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(text: widget.event.details);
    locationController = TextEditingController(text: widget.event.konum);
    registerUrlController = TextEditingController(text: widget.event.kayitLink);
    websiteUrlController = TextEditingController(text: widget.event.konumLink);

    // إذا كان maxRegisteredUsers موجود → يعني التسجيل مفعل
    allowRegister = widget.event.maxRegisteredUsers != null &&
        widget.event.maxRegisteredUsers != 0;

    maxUsersController = TextEditingController(
        text: widget.event.maxRegisteredUsers?.toString() ?? "");

    imageUrl = widget.event.imageUrl;
    startDate = widget.event.startDate;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => newImage = File(file.path));
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
      appBar: AppBar(title: const Text("تعديل فعالية")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(15),
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
              child: (newImage == null && (imageUrl == null || imageUrl!.isEmpty))
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
                    "${startDate.day}/${startDate.month}/${startDate.year} - "
                    "${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}",
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: primaryColor,
              ),
              onPressed: () async {
                String finalImageUrl = imageUrl ?? "";

                if (newImage != null) {
                  finalImageUrl = await ImageUploadService.uploadImage(newImage!);
                }

                final sd = startDate;

                final updated = EventModel(
                  id: widget.event.id,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  location: locationController.text.trim(),
                  imageUrl: finalImageUrl,
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
                  registeredUsers: allowRegister
                      ? widget.event.registeredUsers ?? 0
                      : null,
                );

                await eventProvider.updateEvent(updated);
                Navigator.pop(context);
              },
              child: const Text(
                "حفظ التغييرات",
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
