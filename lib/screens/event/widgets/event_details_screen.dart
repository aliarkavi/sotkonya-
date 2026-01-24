import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/screens/admin/event_requests_screen.dart';
import 'package:sotkonya/widgets/content_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/auth_provider.dart';
import '../../../services/event_registration_request_service.dart';
import '../../../widgets/details_container.dart';
import '../../../widgets/details_item_card.dart';
import '../../../widgets/layouts/details_page_layout.dart';
import '../../../widgets/promo_slider.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.color, required this.obj});

  final Color color;
  final EventModel obj;

  String _normalizeUrl(String url) {
    final u = url.trim();
    if (u.isEmpty) return '';
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    return 'https://$u';
  }

  // ✅ تطبيع رقم الهاتف ليتحول لصيغة مناسبة لواتساب
  String _normalizePhone(String phone) {
    var p = phone.trim().replaceAll(' ', '').replaceAll('-', '');
    if (p.isEmpty) return '';

    // 00... => +...
    if (p.startsWith('00')) p = '+${p.substring(2)}';

    // 05... => +90...
    if (p.startsWith('0') && !p.startsWith('+')) {
      p = '+90${p.substring(1)}';
    }

    // 90... => +90...
    if (p.startsWith('90') && !p.startsWith('+')) {
      p = '+$p';
    }

    return p;
  }

  // ✅ فتح واتساب برسالة جاهزة
  Future<void> _openWhatsApp({
    required String phone,
    required String message,
  }) async {
    final p = _normalizePhone(phone);
    if (p.isEmpty) return;

    // wa.me لا يقبل + لذلك نحذفه
    final waPhone = p.replaceAll('+', '');
    final text = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$waPhone?text=$text');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openLocation(EventModel e) async {
    final String rawUrl =
        e.konumLink.isNotEmpty ? e.konumLink : (e.websiteUrl ?? '');
    final String url = _normalizeUrl(rawUrl);
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _formatFee(double amount) {
    // إذا رقم صحيح بدون كسور: 150 بدل 150.0
    if (amount % 1 == 0) return amount.toStringAsFixed(0);
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final appUser = auth.appUser;
    final bool isAdmin = auth.isAdmin;

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(obj.id);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: eventRef.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snap.hasData || snap.data?.data() == null) {
          return const Scaffold(
            body: Center(child: Text('تعذر تحميل بيانات الفعالية')),
          );
        }

        // ✅ أحدث نسخة من الحدث
        final updatedObj = EventModel.fromMap(obj.id, snap.data!.data()!);

        // ✅ التسجيل فقط إذا allowRegister=true
        final bool allowRegister = updatedObj.allowRegister;

        // ✅ أرقام التسجيل
        final int registered = updatedObj.registeredUsers ?? 0;
        final int max = updatedObj.maxRegisteredUsers ?? 0;

        // ✅ اكتمل العدد فقط إذا max > 0
        final bool isFull = allowRegister && max > 0 && registered >= max;

        // ✅ إظهار شريط التسجيل دائمًا إذا التسجيل مفعل
        final bool showRegisterSection = allowRegister;

        // ✅ زر التسجيل يظهر إذا التسجيل مفعل لكنه يتعطل إذا اكتمل العدد
        final bool showRegisterButton = allowRegister;

        final bool hasLocationLink = updatedObj.konumLink.isNotEmpty ||
            (updatedObj.websiteUrl?.isNotEmpty ?? false);

        // ✅ زر واتساب يظهر فقط للمدفوع + رقم موجود
        final bool showWhatsAppButton =
            updatedObj.isPaid && updatedObj.adminPhone.trim().isNotEmpty;

        // ✅ عرض مبلغ الأجرة
        final bool showFee =
            updatedObj.isPaid && (updatedObj.feeAmount > 0);

        Future<void> onRegisterPressed() async {
          if (appUser == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سجّل دخول أولاً لإرسال طلب التسجيل')),
            );
            return;
          }

          if (isFull) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('اكتمل العدد ولا يمكن التسجيل')),
            );
            return;
          }

          try {
            final res = await EventRegistrationRequestService.instance
                .createRequest(eventId: updatedObj.id, uid: appUser.id);

            if (!context.mounted) return;

            switch (res) {
              case 'created':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال الطلب (بانتظار المراجعة)'),
                  ),
                );
                break;

              case 'exists':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لديك طلب قيد المراجعة بالفعل'),
                  ),
                );
                break;

              case 'approved':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('أنت مسجل بالفعل (تمت الموافقة مسبقاً)'),
                  ),
                );
                break;

              case 'rejected':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم رفض طلبك سابقاً. تواصل مع الإدارة'),
                  ),
                );
                break;

              case 'full':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اكتمل العدد ولا يمكن التسجيل')),
                );
                break;

              case 'register_disabled':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('التسجيل غير مفعّل لهذه الفعالية')),
                );
                break;

              case 'event_not_found':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('لم يتم العثور على الفعالية')),
                );
                break;

              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('نتيجة غير متوقعة: $res')),
                );
            }
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تعذر إرسال الطلب: $e')),
            );
          }
        }

        return DetailsPageLayout(
          title: "تفاصيل الفعالية",
          child: Column(
            children: [
              DetailsItemCard(
                padding: 0,
                color: color,
                child: Column(
                  children: [
                    PromoSlider(images: updatedObj.images, color: color),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            updatedObj.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // الوقت + التاريخ
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 18,
                                    color: Color(0xFFFFB300),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(updatedObj.date,
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 18,
                                    color: Color(0xFFFFB300),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(updatedObj.time,
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Color(0xFFFFB300),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(updatedObj.konum,
                                    style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),

                          // ✅ عرض مبلغ الأجرة
                          if (showFee) ...[
                            const SizedBox(height: 10),
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                const Icon(
                                  Icons.payments_outlined,
                                  size: 18,
                                  color: Color(0xFFFFB300),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'الأجرة: ${_formatFee(updatedObj.feeAmount)} ${updatedObj.feeCurrency}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 16),

                          if (showRegisterSection)
                            RegisteredUsersSection(
                              maxRegisteredUsers: max,
                              registeredUsers: registered,
                              color: const Color(0xFFFFB300),
                            ),

                          if (showRegisterSection)
                            const SizedBox(height: 15)
                          else
                            const SizedBox(height: 5),

                          Row(
                            children: [
                              if (showRegisterButton)
                                Expanded(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: color,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      disabledBackgroundColor:
                                          color.withOpacity(0.55),
                                    ),
                                    onPressed: isFull ? null : onRegisterPressed,
                                    child: Text(
                                      isFull ? "اكتمل العدد" : "التسجيل",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              if (showRegisterButton && hasLocationLink)
                                const SizedBox(width: 10),
                              if (hasLocationLink)
                                Expanded(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: color,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () => _openLocation(updatedObj),
                                    child: const Text(
                                      "الموقع",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // ✅ زر واتساب للتواصل مع الأدمن للتأكيد
                          if (showWhatsAppButton) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.chat, color: Colors.green),
                                label: Text(
                                  'تأكيد التسجيل والدفع عبر واتساب',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  final userNameText = (appUser == null)
    ? 'غير مسجّل دخول'
    : (appUser.name.trim().isEmpty ? 'مستخدم' : appUser.name.trim());

final msg =
    'مرحبًا، أريد تأكيد التسجيل/الدفع لفعالية: ${updatedObj.title}\n'
    'الاسم: $userNameText';

                                  _openWhatsApp(
                                    phone: updatedObj.adminPhone,
                                    message: msg,
                                  );
                                },
                              ),
                            ),
                          ],

                          // ✅ زر الأدمن
                          if (isAdmin) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.admin_panel_settings),
                                label: const Text(
                                  'عرض طلبات التسجيل',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: color,
                                  side: BorderSide(color: color),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EventRequestsScreen(
                                        eventId: updatedObj.id,
                                        eventTitle: updatedObj.title,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              if (updatedObj.details.trim().isNotEmpty)
                DetailsContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "نبذة عن الفعالية",
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ContentWidget(text: updatedObj.details),
                    ],
                  ),
                ),

              if (updatedObj.details.trim().isNotEmpty) const SizedBox(height: 15),

              if (updatedObj.eventTable != null && updatedObj.eventTable!.isNotEmpty)
                DetailsContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "جدول الفعالية",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        itemCount: updatedObj.eventTable!.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = updatedObj.eventTable![index];
                          return EventTableItme(
                            color: color,
                            txt: item.values.first,
                            time: item.keys.first,
                          );
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class EventTableItme extends StatelessWidget {
  const EventTableItme({
    super.key,
    required this.color,
    required this.time,
    required this.txt,
  });

  final Color color;
  final String time, txt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              txt,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class RegisteredUsersSection extends StatelessWidget {
  const RegisteredUsersSection({
    super.key,
    required this.registeredUsers,
    required this.maxRegisteredUsers,
    required this.color,
  });

  final Color color;
  final int registeredUsers, maxRegisteredUsers;

  @override
  Widget build(BuildContext context) {
    final int registered = registeredUsers;
    final int max = maxRegisteredUsers;

    final bool hasMax = max > 0;
    final bool isFull = hasMax && registered >= max;
    final double progress = hasMax ? (registered / max).clamp(0, 1) : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    isFull ? Icons.lock_outline : Icons.how_to_reg_outlined,
                    size: 18,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFull ? 'اكتمل العدد' : 'المسجلون الآن',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                hasMax ? '$registered / $max' : '$registered / غير محدد',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F1F1),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          if (hasMax) ...[
            const SizedBox(height: 8),
            Text(
              'نسبة الامتلاء: ${(progress * 100).round()}%',
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
