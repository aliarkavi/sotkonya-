import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدعم الفني')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'كيف يمكننا مساعدتك؟',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'اكتب مشكلتك أو سؤالك وسيتم الرد عليك خلال 24 ساعة.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'اكتب رسالتك هنا',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (_messageController.text.trim().isEmpty) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الرسالة بنجاح!')),
                );

                _messageController.clear();
              },
              child: const Text('إرسال'),
            ),

            const SizedBox(height: 30),

            const Text(
              'طرق أخرى للتواصل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(PhosphorIcons.whatsappLogo,
  size: 32.0,
),
              title: const Text('واتساب'),
              subtitle: const Text('+90 XX XXX XX XX'),
            ),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('البريد الإلكتروني'),
              subtitle: const Text('support@sotkonya.com'),
            ),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('رقم الهاتف'),
              subtitle: const Text('+90 XX XXX XX XX'),
            ),
          ],
        ),
      ),
    );
  }
}
