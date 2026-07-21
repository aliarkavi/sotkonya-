// lib/services/event_registration_request_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRegistrationRequestService {
  EventRegistrationRequestService();
  static final instance = EventRegistrationRequestService();

  final _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _eventRef(String eventId) =>
      _db.collection('events').doc(eventId);

  DocumentReference<Map<String, dynamic>> _reqRef({
    required String eventId,
    required String uid,
  }) =>
      _eventRef(eventId).collection('registration_requests').doc(uid);

  /// إنشاء طلب تسجيل
  /// returns:
  /// - created  => تم إنشاء الطلب بنجاح
  /// - exists   => يوجد طلب pending مسبقاً
  /// - approved => كان موافق عليه مسبقاً
  /// - rejected => كان مرفوض مسبقاً
  /// - full / register_disabled / event_not_found
  Future<String> createRequest({
    required String eventId,
    required String uid,
    String? eventTitle,
    String? userName,
    bool? isPaid,
  }) async {
    final eventRef = _eventRef(eventId);
    final reqRef = _reqRef(eventId: eventId, uid: uid);

    return _db.runTransaction((tx) async {
      final eventSnap = await tx.get(eventRef);
      if (!eventSnap.exists) return 'event_not_found';

      final eventData = eventSnap.data() ?? {};
      final allowRegister = (eventData['allowRegister'] as bool?) ?? false;
      if (!allowRegister) return 'register_disabled';

      final max = (eventData['maxRegisteredUsers'] as num?)?.toInt() ?? 0;
      final registered = (eventData['registeredUsers'] as num?)?.toInt() ?? 0;
      if (max > 0 && registered >= max) return 'full';

      final snap = await tx.get(reqRef);
      if (snap.exists) {
        final status = snap.data()?['status']?.toString() ?? 'pending';
        if (status == 'pending') return 'exists';
        return status; // approved / rejected
      }

      tx.set(reqRef, {
        'uid': uid,
        'userName': userName ?? '',
        'eventTitle': eventTitle ?? '',
        'isPaid': isPaid ?? false,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // ✅ إنشاء إشعار للمستخدم عند تقديم الطلب
      final notifRef = _db.collection('notifications').doc();
      tx.set(notifRef, {
        'userId': uid,
        'title': 'تم استلام طلبك ⏳',
        'body': 'تم استلام طلب تسجيلك في الفعالية: ${eventData['title'] ?? ''} وهو قيد المراجعة.',
        'type': 'event_status',
        'eventId': eventId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return 'created';
    });
  }

  /// موافقة: status=approved + زيادة registeredUsers في event
  /// returns: approved / full / request_not_found / register_disabled / event_not_found
  Future<String> approveRequest({
    required String eventId,
    required String uid,
  }) async {
    final eventRef = _eventRef(eventId);
    final reqRef = _reqRef(eventId: eventId, uid: uid);

    return _db.runTransaction((tx) async {
      final eventSnap = await tx.get(eventRef);
      if (!eventSnap.exists) return 'event_not_found';

      final eventData = eventSnap.data() ?? {};
      final allowRegister = (eventData['allowRegister'] as bool?) ?? false;
      if (!allowRegister) return 'register_disabled';

      final max = (eventData['maxRegisteredUsers'] as num?)?.toInt() ?? 0;
      final registered = (eventData['registeredUsers'] as num?)?.toInt() ?? 0;
      if (max > 0 && registered >= max) return 'full';

      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) return 'request_not_found';

      final status = reqSnap.data()?['status']?.toString() ?? 'pending';
      if (status == 'approved') return 'approved';

      tx.update(reqRef, {
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      tx.update(eventRef, {
        'registeredUsers': FieldValue.increment(1),
      });

      // ✅ إنشاء إشعار للمستخدم
      final notifRef = _db.collection('notifications').doc();
      tx.set(notifRef, {
        'userId': uid,
        'title': 'تم قبول طلبك ✅',
        'body': 'تمت الموافقة على تسجيلك في فعالية: ${eventData['title'] ?? ''}',
        'type': 'event_status',
        'eventId': eventId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return 'approved';
    });
  }

  /// رفض الطلب (كما عندك)
  Future<void> rejectRequest({
    required String eventId,
    required String uid,
  }) async {
    final reqRef = _reqRef(eventId: eventId, uid: uid);
    await reqRef.set({
      'uid': uid,
      'status': 'rejected',
      'rejectedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // ✅ إنشاء إشعار للمستخدم (خارج الـ Transaction لأنه set عادي)
    await _db.collection('notifications').add({
      'userId': uid,
      'title': 'تم رفض طلبك ❌',
      'body': 'نعتذر، تم رفض طلب تسجيلك في الفعالية.',
      'type': 'event_status',
      'eventId': eventId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// ✅ (الخيار 1) إلغاء القبول: Approved -> Pending
  /// - إذا كان الطلب approved: ينقص registeredUsers -1
  /// returns:
  /// - reverted => تم إلغاء القبول وإرجاعه للمراجعة
  /// - already_pending
  /// - request_not_found
  /// - event_not_found
  Stream<DocumentSnapshot?> myRequestStream({
    required String eventId,
    required String userId,
  }) {
    if (userId.isEmpty) return Stream.value(null);
    return _reqRef(eventId: eventId, uid: userId).snapshots();
  }

  Future<String> revertToPending({
    required String eventId,
    required String uid,
  }) async {
    final eventRef = _eventRef(eventId);
    final reqRef = _reqRef(eventId: eventId, uid: uid);

    return _db.runTransaction((tx) async {
      final eventSnap = await tx.get(eventRef);
      if (!eventSnap.exists) return 'event_not_found';

      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) return 'request_not_found';

      final reqData = reqSnap.data() ?? {};
      final currentStatus = reqData['status']?.toString() ?? 'pending';

      if (currentStatus == 'pending') return 'already_pending';

      // إذا كان Approved ننقص العداد
      if (currentStatus == 'approved') {
        final eventData = eventSnap.data() ?? {};
        final currentRegistered =
            (eventData['registeredUsers'] as num?)?.toInt() ?? 0;

        final newValue = (currentRegistered - 1);
        tx.update(eventRef, {
          'registeredUsers': newValue < 0 ? 0 : newValue,
        });
      }

      // رجّعه Pending
      tx.update(reqRef, {
        'status': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
        'revertedAt': FieldValue.serverTimestamp(), // توثيق اختياري
      });

      return 'reverted';
    });
  }
}





