import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sotkonya/model/notification_model.dart';
import 'package:sotkonya/providers/auth_provider.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // يتم استدعاؤها عند بدء التطبيق أو تسجيل الدخول
  void init(AuthProvider authProvider) {
    final user = authProvider.user;
    _subscription?.cancel();

    if (user != null) {
      _subscription = _db
          .collection('notifications')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        _notifications = snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
            .toList();
        notifyListeners();
      });
    } else {
      _notifications = [];
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _db
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    final batch = _db.batch();
    for (var n in _notifications.where((n) => !n.isRead)) {
      batch.update(
        _db.collection('notifications').doc(n.id),
        {'isRead': true},
      );
    }
    await batch.commit();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}