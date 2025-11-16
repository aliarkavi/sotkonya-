import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المعرض')),
      body: const Center(child: Text('المعرض - صور ووسائط (سيتم ربطه بـ Firebase Storage لاحقًا)')),
    );
  }
}
