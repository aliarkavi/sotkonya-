import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadService {
  static Future<String> uploadImage(File file) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("news_images/${DateTime.now().millisecondsSinceEpoch}.jpg");

    await storageRef.putFile(file);

    return await storageRef.getDownloadURL();
  }
}
