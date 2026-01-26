// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../model/news_model.dart'; // تأكد من مسار المودل الصحيح

class HomeNewsItem extends StatelessWidget {
  const HomeNewsItem({
    super.key,
    required this.obj, // نمرر الكائن كاملاً ليأخذ منه كل البيانات
    required this.onTap,
  });

  final NewsModel obj;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const contentHeight = 110.0; // زيادة بسيطة ليتسع للتاريخ بوضوح
    
    // تنسيق التاريخ بنفس الطريقة التي استخدمتها في الأكواد السابقة
    final dateString = "${obj.newsDate.day}/${obj.newsDate.month}/${obj.newsDate.year}";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2), // مسافة بسيطة حول الكارت
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          top: BorderSide(color: Color(0xFF006db7), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة الخبر
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: contentHeight,
                    color: Colors.grey.shade200,
                    child: obj.imageUrl.isNotEmpty
                        ? Image.network(
                            obj.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.broken_image, color: Colors.grey),
                          )
                        : const Icon(Icons.newspaper, size: 40, color: Colors.grey),
                  ),
                ),

                const SizedBox(width: 12),

                // النصوص
                Expanded(
                  child: SizedBox(
                    height: contentHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              obj.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              obj.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),

                        // السطر السفلي: التاريخ + الزر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // التاريخ مع أيقونة بسيطة
                            Row(
                              children: [
                                
                                const SizedBox(width: 4),
                                Text(
                                  dateString,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            
                            // زر اقرأ المزيد
                            SizedBox(
                              height: 28,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF006db7),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: onTap,
                                child: const Text(
                                  "اقرأ المزيد",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}