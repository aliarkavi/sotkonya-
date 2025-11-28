import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final IconData icon;

  /// ⬅️ أهم تعديل: بدل VoidCallback أصبح Future<void> Function()?
  final Future<void> Function()? onTap;

  final double iconSize;
  final List<Color> colors;

  const GradientButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.iconSize = 18,
    this.colors = const [
      Color(0xff006db7),
      Color(0xff00b39f),
      Color(0xffeb5623),
      Color(0xfff2b200),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),

          /// ⬅️ التعديل هنا ليدعم async
          onTap: () async {
            if (onTap != null) {
              await onTap!();
            }
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: iconSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
