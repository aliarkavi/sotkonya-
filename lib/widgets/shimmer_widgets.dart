import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// ------------------------------------------------------------
///  🔶 GENERAL SHIMMER WRAPPER
/// ------------------------------------------------------------
Widget shimmerContainer({
  double height = 20,
  double width = double.infinity,
  double radius = 12,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

/// ------------------------------------------------------------
///  🔵 NEWS SHIMMER (بطاقة الأخبار)
/// ------------------------------------------------------------
Widget shimmerNewsCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الخبر
          Container(
            width: 110,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: 16),

          // معلومات الخبر
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerContainer(height: 14, width: 150),
                const SizedBox(height: 8),
                shimmerContainer(height: 14, width: 100),
                const SizedBox(height: 8),
                shimmerContainer(height: 14, width: 180),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// ------------------------------------------------------------
///  🟡 EVENT SHIMMER (بطاقة الفعاليات)
/// ------------------------------------------------------------
Widget shimmerEventCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // نص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(height: 16, width: 200),
                    const SizedBox(height: 10),
                    shimmerContainer(height: 14, width: 120),
                    const SizedBox(height: 10),
                    shimmerContainer(height: 14, width: 140),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // صورة
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          shimmerContainer(height: 40, width: double.infinity),
        ],
      ),
    ),
  );
}

/// ------------------------------------------------------------
///  🟠 YURT SHIMMER (بطاقة السكنات)
/// ------------------------------------------------------------
Widget shimmerYurtCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // صورة السكن
          Container(
            width: 110,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: 16),

          // معلومات السكن
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerContainer(height: 16, width: 170),
                const SizedBox(height: 10),
                shimmerContainer(height: 14, width: 100),
                const SizedBox(height: 10),
                shimmerContainer(height: 14, width: 140),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// ------------------------------------------------------------
///  📄 DETAILS PAGE SHIMMER (تفاصيل أي عنصر)
/// ------------------------------------------------------------
Widget shimmerDetailsPage() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      shimmerContainer(height: 220, radius: 16),
      const SizedBox(height: 20),
      shimmerContainer(height: 20, width: 180),
      const SizedBox(height: 12),
      shimmerContainer(height: 16, width: 250),
      const SizedBox(height: 12),
      shimmerContainer(height: 16, width: 200),
      const SizedBox(height: 20),
      shimmerContainer(height: 14, width: double.infinity),
      const SizedBox(height: 10),
      shimmerContainer(height: 14, width: double.infinity),
      const SizedBox(height: 10),
      shimmerContainer(height: 14, width: 250),
    ],
  );
}
