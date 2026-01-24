// lib/screens/admin/events/edit_event_screen.dart
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
  late TextEditingController adminPhoneController;

  // ✅ جديد
  late TextEditingController feeAmountController;
  late TextEditingController feeCurrencyController;

  bool allowRegister = false;
  bool isPaid = false;

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

    allowRegister = widget.event.allowRegister;
    isPaid = widget.event.isPaid;

    maxUsersController = TextEditingController(
      text: (widget.event.maxRegisteredUsers ?? 0) == 0
          ? ""
          : widget.event.maxRegisteredUsers.toString(),
    );

    adminPhoneController = TextEditingController(text: widget.event.adminPhone);

    feeAmountController = TextEditingController(
      text: widget.event.feeAmount == 0 ? "" : widget.event.feeAmount.toString(),
    );
    feeCurrencyController =
        TextEditingController(text: widget.event.feeCurrency.isEmpty ? '₺' : widget.event.feeCurrency);

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

  Widget input(
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    const primaryColor = Color(0xFFf2b200);

    final showPaidOptions = allowRegister;
    final showPaidFields = allowRegister && isPaid;

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
                    ? DecorationImage(image: FileImage(newImage!), fit: BoxFit.cover)
                    : (imageUrl != null && imageUrl!.isNotEmpty)
                        ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                        : null,
              ),
              child: (newImage == null && (imageUrl == null || imageUrl!.isEmpty))
                  ? const Center(child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey))
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
                activeThumbColor: primaryColor,
                value: allowRegister,
                onChanged: (v) {
                  setState(() {
                    allowRegister = v;
                    if (!allowRegister) {
                      isPaid = false;
                      adminPhoneController.clear();
                      maxUsersController.clear();
                      feeAmountController.clear();
                      feeCurrencyController.text = '₺';
                    }
                  });
                },
              ),
            ],
          ),

          if (showPaidOptions) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Text(
                  "الفعالية مأجورة",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  activeThumbColor: primaryColor,
                  value: isPaid,
                  onChanged: (v) {
                    setState(() {
                      isPaid = v;
                      if (!isPaid) {
                        adminPhoneController.clear();
                        feeAmountController.clear();
                        feeCurrencyController.text = '₺';
                      }
                    });
                  },
                ),
              ],
            ),
          ],

          if (allowRegister) ...[
            const SizedBox(height: 16),
            label("الحد الأقصى للمشاركين (اتركه فارغ = غير محدد)"),
            input(maxUsersController, keyboardType: TextInputType.number),
          ],

          if (showPaidFields) ...[
            const SizedBox(height: 16),
            label("مبلغ الأجرة"),
            input(feeAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),

            const SizedBox(height: 16),
            label("العملة (مثال: ₺ أو TRY)"),
            input(feeCurrencyController),

            const SizedBox(height: 16),
            label("رقم واتساب الأدمن لتأكيد الدفع (مثال: +905xxxxxxxxx)"),
            input(adminPhoneController, keyboardType: TextInputType.phone),
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
                if (allowRegister && isPaid) {
                  final fee = double.tryParse(feeAmountController.text.trim().replaceAll(',', '.')) ?? 0;
                  if (fee <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("الرجاء إدخال مبلغ أجرة صحيح")),
                    );
                    return;
                  }
                  if (adminPhoneController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("الرجاء إدخال رقم واتساب الأدمن للفعاليات المأجورة")),
                    );
                    return;
                  }
                }

                String finalImageUrl = imageUrl ?? "";
                if (newImage != null) {
                  finalImageUrl = await ImageUploadService.uploadImage(newImage!);
                }

                final sd = startDate;

                final int maxUsers = allowRegister
                    ? (int.tryParse(maxUsersController.text.trim()) ?? 0)
                    : 0;

                final double fee = double.tryParse(
                      feeAmountController.text.trim().replaceAll(',', '.'),
                    ) ??
                    0;

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

                  allowRegister: allowRegister,
                  isPaid: isPaid,
                  adminPhone: adminPhoneController.text.trim(),

                  feeAmount: isPaid ? fee : 0,
                  feeCurrency: feeCurrencyController.text.trim().isEmpty
                      ? '₺'
                      : feeCurrencyController.text.trim(),

                  // حافظ على عداد المسجلين الحالي
                  maxRegisteredUsers: allowRegister ? maxUsers : null,
                  registeredUsers: allowRegister ? (widget.event.registeredUsers ?? 0) : null,
                );

                await eventProvider.updateEvent(updated);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text(
                "حفظ التغييرات",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
