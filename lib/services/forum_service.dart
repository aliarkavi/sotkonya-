import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ForumService {
  final CollectionReference<Map<String, dynamic>> _groups = FirebaseFirestore.instance.collection('groups');

  Stream<QuerySnapshot<Map<String, dynamic>>> streamGroupsForUser(String uid) {
    // Avoid ordering on the query to prevent Firestore composite-index requirements
    // when combining array-contains with orderBy. We'll sort client-side instead.
    return _groups.where('members', arrayContains: uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessages(String groupId) {
    return _groups.doc(groupId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }

  Future<String> createGroup({required String name, required List<String> members, File? photo}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = await _groups.add({
      'name': name,
      'photoUrl': '',
      'ownerId': user.uid,
      'admins': [user.uid],
      'members': members,
      'createdAt': Timestamp.now(),
    });
    String photoUrl = '';
    if (photo != null) {
      final ref = FirebaseStorage.instance.ref().child('group_images').child('${docRef.id}.jpg');
      final task = await ref.putFile(photo);
      photoUrl = await task.ref.getDownloadURL();
      await docRef.update({'photoUrl': photoUrl});
    }
    return docRef.id;
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> updates) async {
    await _groups.doc(groupId).update(updates);
  }

  Future<void> addMember(String groupId, String uid) async {
    await _groups.doc(groupId).update({'members': FieldValue.arrayUnion([uid])});
  }

  Future<void> removeMember(String groupId, String uid) async {
    await _groups.doc(groupId).update({'members': FieldValue.arrayRemove([uid]), 'admins': FieldValue.arrayRemove([uid])});
  }

  Future<void> promoteToAdmin(String groupId, String uid) async {
    await _groups.doc(groupId).update({'admins': FieldValue.arrayUnion([uid])});
  }

  Future<void> demoteAdmin(String groupId, String uid) async {
    await _groups.doc(groupId).update({'admins': FieldValue.arrayRemove([uid])});
  }

  Future<void> sendMessage(String groupId, {String? text, String? imageUrl}) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _groups.doc(groupId).collection('messages').add({
      'senderId': user.uid,
      'text': text ?? '',
      'imageUrl': imageUrl ?? '',
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteGroup(String groupId) async {
    // delete subcollection messages (best-effort) then group doc
    final msgs = await _groups.doc(groupId).collection('messages').get();
    for (final d in msgs.docs) {
      await d.reference.delete();
    }
    await _groups.doc(groupId).delete();
  }
}
