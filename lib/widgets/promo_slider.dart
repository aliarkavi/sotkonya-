import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PromoSlider extends ConsumerStatefulWidget {
  const PromoSlider({
    super.key,
    required this.items,
    this.color = Colors.blue,
    this.height = 150,
    this.fallbackIcon = Icons.image,
  });

  final List<String> items;
  final Color color;
  final double height;
  final IconData fallbackIcon;

  @override
  ConsumerState<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends ConsumerState<PromoSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(widget.fallbackIcon, size: 50, color: Colors.grey),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1,
            autoPlay: widget.items.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.items.map((img) {
            final bool isNetwork =
                img.startsWith('http://') || img.startsWith('https://');

            Widget buildImage(BoxFit fit) {
              return isNetwork
                  ? Image.network(img, fit: fit)
                  : Image.asset(img, fit: fit);
            }

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: InteractiveViewer(
                        child: buildImage(BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: buildImage(BoxFit.cover),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.items.length > 1) ...[
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.items.length; i++)
                  Container(
                    width: 16,
                    height: 5,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: i == _currentIndex ? widget.color : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}





