import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
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

  // ignore: unintended_html_in_doc_comment
  /// ⬅️ أهم تعديل: بدل VoidCallback أصبح Future<void> Function()?
  final Future<void> Function()? onTap;

  final List<Color> colors;
  final IconData icon;
  final double iconSize;
  final String text;

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
