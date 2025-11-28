import 'package:flutter/material.dart';

import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/yurtlar_item_card.dart';

class YurtlarScreen extends StatelessWidget {
  const YurtlarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(
      title: "السكنات",
      child: Column(
        children: [
          ListView.separated(
            itemCount: 6,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return YurtlarItemCard(
                title: "سكن الطلاب رقم ${index + 1}",
                durum: "متاح",
                personelData: "غرف مزدوجة",
                rentData: "11,000 ليرة شهريًا",
                location: "الموقع هنا",
                iconData: Icons.article,
                color: Color(0xFFeb5623),

                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
