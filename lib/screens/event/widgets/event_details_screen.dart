import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/screens/admin/event_requests_screen.dart';
import 'package:sotkonya/widgets/content_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sotkonya/services/event_registration_request_service.dart';
import 'package:sotkonya/widgets/details_container.dart';
import 'package:sotkonya/widgets/details_item_card.dart';
import 'package:sotkonya/widgets/layouts/details_page_layout.dart';
import 'package:sotkonya/widgets/promo_slider.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class EventDetailsScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final appUser = auth.appUser;
    final bool isAdmin = auth.isAdmin;

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(obj.id);

    final l10n = AppLocalizations.of(context)!;
    return DetailsPageLayout(
      title: l10n.eventDetails,
      child: StreamBuilder<DocumentSnapshot>(
        stream: eventRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ ما'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final eventData = snapshot.data!.data() as Map<String, dynamic>;
          final event = EventModel.fromMap(snapshot.data!.id, eventData);

          final images = (event.imageUrl != null && event.imageUrl!.isNotEmpty)
              ? [event.imageUrl!]
              : event.images;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PromoSlider(
                  items: images,
                  color: color,
                  height: 250,
                  fallbackIcon: Icons.event_available,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.calendar_today_outlined,
                            label: event.date,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon: Icons.access_time,
                            label: event.time,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DetailsContainer(
                        title: l10n.aboutEvent,
                        child: ContentWidget(text: event.description ?? ''),
                      ),
                      const SizedBox(height: 16),
                      if (event.location != null && event.location!.isNotEmpty)
                        DetailsItemCard(
                          color: color,
                          icon: Icons.location_on_outlined,
                          title: l10n.location,
                          subtitle: event.location,
                          onTap: () => _openLocation(event),
                        ),
                      const SizedBox(height: 12),
                      if (event.websiteUrl != null &&
                          event.websiteUrl!.isNotEmpty)
                        DetailsItemCard(
                          color: color,
                          icon: Icons.language,
                          title: l10n.website,
                          subtitle: event.websiteUrl!,
                          onTap: () => launchUrl(
                            Uri.parse(_normalizeUrl(event.websiteUrl!)),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (isAdmin)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.people_alt_outlined,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventRequestsScreen(
                                    eventId: event.id,
                                    eventTitle: event.title,
                                  ),
                                ),
                              );
                            },
                            label: Text(
                              l10n.viewRegistrationRequests,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),

                      // ✅ قسم الفعاليات الماجورة / المجانية
                      if (event.allowRegister)
                        _RegisterSection(
                          event: event,
                          appUserId: appUser?.id ?? '',
                          appUserName: appUser?.name ?? '',
                          openWhatsApp: _openWhatsApp,
                          formatFee: _formatFee,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends ConsumerWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}

// ✅ ويدجت مستقل لاتخاذ إجراءات التسجيل
class _RegisterSection extends ConsumerStatefulWidget {
  final EventModel event;
  final String appUserId;
  final String appUserName;
  final Future<void> Function({required String phone, required String message})
      openWhatsApp;
  final String Function(double) formatFee;

  const _RegisterSection({
    required this.event,
    required this.appUserId,
    required this.appUserName,
    required this.openWhatsApp,
    required this.formatFee,
  });

  @override
  ConsumerState<_RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends ConsumerState<_RegisterSection> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isFull = widget.event.maxRegisteredUsers != null &&
        widget.event.maxRegisteredUsers! > 0 &&
        (widget.event.registeredUsers ?? 0) >=
            widget.event.maxRegisteredUsers!;

    return StreamBuilder<DocumentSnapshot?>(
      stream: EventRegistrationRequestService.instance.myRequestStream(
        eventId: widget.event.id,
        userId: widget.appUserId,
      ),
      builder: (context, snapshot) {
        final requestDoc = snapshot.data;
        final String status =
            requestDoc != null ? (requestDoc['status'] ?? 'pending') : '';

        // إذا كان هناك طلب موجود
        if (requestDoc != null) {
          return _buildStatusBox(status);
        }

        // إذا كانت الفعالية ممتلئة ولا يوجد طلب سابق
        if (isFull) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              l10n.eventFullMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          );
        }

        // زر التسجيل (مجاني أو مأجور)
        return Column(
          children: [
            if (widget.event.isPaid)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${l10n.paidEventFeeInfo} ${widget.formatFee(widget.event.feeAmount)} ${widget.event.feeCurrency}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _loading ? null : _handleRegister,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        widget.event.isPaid ? l10n.requestPaidRegistration : l10n.registerNow,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBox(String status) {
    Color boxColor = Colors.grey[100]!;
    Color textColor = Colors.black87;
    String statusText = '';
    String? subText;

    final l10n = AppLocalizations.of(context)!;

    if (status == 'pending') {
      boxColor = Colors.orange[50]!;
      textColor = Colors.orange[900]!;
      statusText = l10n.requestPending;
      if (widget.event.isPaid) {
        subText = l10n.paidEventPendingInfo;
      }
    } else if (status == 'approved') {
      boxColor = Colors.green[50]!;
      textColor = Colors.green[900]!;
      statusText = l10n.requestApproved;
    } else if (status == 'rejected') {
      boxColor = Colors.red[50]!;
      textColor = Colors.red[900]!;
      statusText = l10n.requestRejected;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            statusText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          if (subText != null) ...[
            const SizedBox(height: 8),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (widget.event.adminPhone.isNotEmpty)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green[700],
                  side: BorderSide(color: Colors.green[700]!),
                ),
                onPressed: () {
                  final msg =
                      '${l10n.whatsappInquiryPrefix} "${widget.event.title}". ${l10n.name}: ${widget.appUserName}';
                  widget.openWhatsApp(
                    phone: widget.event.adminPhone,
                    message: msg,
                  );
                },
                icon: const Icon(Icons.chat),
                label: Text(l10n.contactAdminWhatsApp),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (widget.appUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loginRequired)),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await EventRegistrationRequestService.instance.createRequest(
        eventId: widget.event.id,
        eventTitle: widget.event.title,
        uid: widget.appUserId,
        userName: widget.appUserName,
        isPaid: widget.event.isPaid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.requestSentSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}





