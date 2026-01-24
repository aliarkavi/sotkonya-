import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.studentNumber,
    required this.major,
    this.initialLetter,
    this.photoUrl, // ✅ جديد
  });

  final String name;
  final String studentNumber;
  final String major;
  final String? initialLetter;

  /// رابط الصورة (من Firestore) - قد يكون فاضي
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final letter = (initialLetter ?? (name.isNotEmpty ? name.characters.first : 'U'))
        .toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 250,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF007FD6),
                      Color(0xFF00B5B0),
                      Color(0xFFFFC63A),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 60,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFF008FD3),
                  child: _ProfileAvatarContent(
                    letter: letter,
                    photoUrl: photoUrl,
                  ),
                ),
              ),
            ),

            Positioned.fill(
              top: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'رقم الطالب: $studentNumber',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 18,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        major,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatarContent extends StatelessWidget {
  final String letter;
  final String? photoUrl;

  const _ProfileAvatarContent({
    required this.letter,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final url = (photoUrl ?? '').trim();

    // إذا ما في صورة -> حرف أول
    if (url.isEmpty) {
      return Text(
        letter,
        style: const TextStyle(fontSize: 36, color: Colors.white),
      );
    }

    // إذا في صورة -> NetworkImage مع fallback عند الخطأ
    return ClipOval(
      child: Image.network(
        url,
        width: 88, // 2 * radius (44*2)
        height: 88,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Center(
            child: Text(
              letter,
              style: const TextStyle(fontSize: 36, color: Colors.white),
            ),
          );
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}
