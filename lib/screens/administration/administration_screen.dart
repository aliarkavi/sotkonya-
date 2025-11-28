import 'package:flutter/material.dart';

import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/administration_item_card.dart';

class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(
      title: "أعضاء الإدارة",
      child: Column(
        children: [
          ListView.separated(
            itemCount: 6,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AdministrationItemCard(
                title: "عضو الإدارة رقم ${index + 1}",
                job: "المسمى الوظيفي هنا",
                aboutHim: "نبذة مختصرة عن عضو الإدارة رقم ${index + 1} هنا.",
                iconData: Icons.article,
                color: Color(0xFF00a5a5),

                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
