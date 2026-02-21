import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/providers/notification_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الإشعارات"),
        actions: [
          if (notifications.any((n) => !n.isRead))
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: "تحديد الكل كمقروء",
              onPressed: () => provider.markAllAsRead(),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "لا توجد إشعارات حالياً",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Container(
                  color: item.isRead ? null : Colors.blue.withOpacity(0.05),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.isRead
                          ? Colors.grey[300]
                          : Theme.of(context).primaryColor,
                      child: Icon(
                        _getIconForType(item.type),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight:
                            item.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(item.body),
                        const SizedBox(height: 6),
                        Text(
                          timeago.format(item.createdAt, locale: 'ar'),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!item.isRead) {
                        provider.markAsRead(item.id);
                      }
                      // يمكن هنا إضافة توجيه لصفحة الفعالية إذا وجد eventId
                      /*
                      if (item.eventId != null) {
                         Navigator.push(...);
                      }
                      */
                    },
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'event_status':
        return Icons.event_available;
      case 'news':
        return Icons.article;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications;
    }
  }
}