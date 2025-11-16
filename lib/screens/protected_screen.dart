import 'package:flutter/material.dart';
import 'register_screen.dart';

class ProtectedScreen extends StatelessWidget {
  final String message;
  const ProtectedScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151C26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('مطلوب انتساب'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Color(0xFF7C4DFF)),
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B2B1B),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text('الانتساب الآن'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
