import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sotkonya/model/event_model.dart';

import '../../../widgets/details_container.dart';
import '../../../widgets/details_item_card.dart';
import '../../../widgets/layouts/details_page_layout.dart';
import '../../../widgets/promo_slider.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen(
      {super.key, required this.color, required this.obj});

  final Color color;
  final EventModel obj;

  Future<void> _openLocation() async {
    final String url = obj.konumLink.isNotEmpty
        ? obj.konumLink
        : (obj.websiteUrl ?? '');

    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showRegisterSection = obj.allowRegister &&
        obj.registeredUsers != null &&
        obj.maxRegisteredUsers != null &&
        obj.maxRegisteredUsers != 0;

    final bool showRegisterButton = obj.allowRegister;

    final bool hasLocationLink =
        obj.konumLink.isNotEmpty || (obj.websiteUrl?.isNotEmpty ?? false);

    return DetailsPageLayout(
      title: "تفاصيل الفعالية",
      child: Column(
        children: [
          DetailsItemCard(
            padding: 0,
            color: color,
            child: Column(
              children: [
                PromoSlider(images: obj.images, color: color),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        obj.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      //  الوقت + التاريخ
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          // التاريخ
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Color(0xFFFFB300),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                obj.date,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          // الوقت
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Color(0xFFFFB300),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                obj.time,
                                style: const TextStyle(fontSize: 14),
                              ),
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
                          Text(
                            obj.konum,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (showRegisterSection)
                        RegisteredUsersSection(
                          maxRegisteredUsers:
                              obj.maxRegisteredUsers ?? 0,
                          registeredUsers:
                              obj.registeredUsers ?? 0,
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
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize
                                          .shrinkWrap,
                                ),
                                onPressed: () {
                                  // منطق التسجيل سيتم إضافته لاحقاً
                                },
                                child: const Text(
                                  "التسجيل",
                                  style: TextStyle(
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
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize
                                          .shrinkWrap,
                                ),
                                onPressed: _openLocation,
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
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          if (obj.details.trim().isNotEmpty)
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
                  Text(
                    obj.details,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          if (obj.details.trim().isNotEmpty)
            const SizedBox(height: 15),

          if (obj.eventTable != null && obj.eventTable!.isNotEmpty)
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
                    itemCount: obj.eventTable!.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = obj.eventTable![index];
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
      padding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            time,
            style:
                const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              txt,
              maxLines: 1,
              style:
                  const TextStyle(fontWeight: FontWeight.w500),
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

  final int registeredUsers, maxRegisteredUsers;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final int registered = registeredUsers;
    final int max = maxRegisteredUsers;
    final double progress =
        max == 0 ? 0 : registered / max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'عدد المسجلين',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              '$registered / $max',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 5,
            backgroundColor: const Color(0xFFF1F1F1),
            valueColor:
                const AlwaysStoppedAnimation(Color(0xFFFFB300)),
          ),
        ),
      ],
    );
  }
}
