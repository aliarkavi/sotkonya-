import 'package:flutter/material.dart';

import '../../../model/notification_item.dart';

class NotificationsCard extends StatelessWidget {
  final List<NotificationItem> items;

  const NotificationsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final item = items[index];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: item.dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                if (index != items.length - 1)
                  Divider(
                    height: 0,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey.shade300,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
