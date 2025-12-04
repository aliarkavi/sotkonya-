import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PromoSlider extends StatefulWidget {
  const PromoSlider({super.key, required this.images, required this.color});

  final List<String> images;
  final Color color;

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            viewportFraction: 1,
            // autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.images.map((img) {
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
                        child: Image.asset(img, fit: BoxFit.contain),
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
                  child: Image.asset(img, fit: BoxFit.cover),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widget.images.length; i++)
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
    );
  }
}
