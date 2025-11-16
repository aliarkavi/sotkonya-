import 'package:flutter/material.dart';
import 'news_screen.dart';


class VisitorScreen extends StatelessWidget {
  const VisitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151C26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
  title: const Text('الزائر'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.visibility, size: 80, color: Color(0xFF4B2B1B)),
              const SizedBox(height: 24),
              const Text(
                'مرحباً بك في التطبيق',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B2B1B),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // توجيه الزائر إلى شاشة الأخبار كصفحة رئيسية للزائر
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsScreen()));
                },
                child: const Text('ابدأ التصفح'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
