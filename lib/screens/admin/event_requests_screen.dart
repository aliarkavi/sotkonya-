import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sotkonya/services/event_registration_request_service.dart';

class EventRequestsScreen extends StatelessWidget {
  final String eventId;
  final String eventTitle;

  const EventRequestsScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    final reqsRef = FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('registration_requests');

    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات التسجيل: $eventTitle'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: reqsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text('لا يوجد طلبات تسجيل'));
          }

          final docs = snap.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();

              final uid = data['uid']?.toString() ?? d.id;
              final status = data['status']?.toString() ?? 'pending';

              final isPending = status == 'pending';
              final isApproved = status == 'approved';

              return Card(
                child: ListTile(
                  title: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get(),
                    builder: (context, userSnap) {
                      if (!userSnap.hasData) {
                        return const Text('جارٍ تحميل الاسم...');
                      }

                      final userData = userSnap.data!.data();
                      final userName =
                          userData?['name']?.toString() ?? 'مستخدم غير معروف';

                      return Text(userName);
                    },
                  ),
                  subtitle: Text(
                    'الحالة: ${_statusText(status)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Pending: موافقة/رفض
                      if (isPending) ...[
                        IconButton(
                          tooltip: 'موافقة',
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            final res = await EventRegistrationRequestService
                                .instance
                                .approveRequest(eventId: eventId, uid: uid);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res == 'approved'
                                      ? 'تمت الموافقة على الطلب'
                                      : 'تعذر الموافقة: $res',
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'رفض',
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await EventRegistrationRequestService.instance
                                .rejectRequest(eventId: eventId, uid: uid);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم رفض الطلب')),
                            );
                          },
                        ),
                      ]

                      // ✅ Approved: يظهر (إلغاء القبول) + أيقونة مقبول
                      else if (isApproved) ...[
                        IconButton(
                          tooltip: 'إلغاء القبول (إرجاع للمراجعة)',
                          icon: const Icon(Icons.undo, color: Colors.orange),
                          onPressed: () async {
                            final res = await EventRegistrationRequestService
                                .instance
                                .revertToPending(eventId: eventId, uid: uid);

                            if (!context.mounted) return;

                            String msg;
                            if (res == 'reverted') {
                              msg = 'تم إلغاء القبول وإرجاع الطلب للمراجعة';
                            } else if (res == 'already_pending') {
                              msg = 'الطلب أساساً بانتظار المراجعة';
                            } else {
                              msg = 'تعذر الإلغاء: $res';
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          },
                        ),
                        const Icon(Icons.verified, color: Colors.green),
                      ]

                      // ✅ Rejected أو غيرها
                      else ...[
                        const Icon(Icons.block, color: Colors.red),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// تحويل الحالة إلى نص عربي
  static String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'بانتظار المراجعة';
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }
}
