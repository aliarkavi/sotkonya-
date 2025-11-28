import 'package:flutter/material.dart';

class HomeNewsItem extends StatelessWidget {
  const HomeNewsItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final contentHeight = 100.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          top: BorderSide(color: Color(0xFF006db7), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة أو خلفية
                Container(
                  width: 100,
                  height: contentHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/img/BG.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                const SizedBox(width: 12),

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
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              DateTime.now().toString().substring(0, 10),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 30,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF006db7),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: onTap,
                                child: const Text(
                                  "اقرأ المزيد",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
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
