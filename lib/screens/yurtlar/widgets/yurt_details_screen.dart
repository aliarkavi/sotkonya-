// lib/screens/yurt/widgets/yurt_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sotkonya/model/yurt_model.dart';
import 'package:sotkonya/widgets/contact_information.dart';
import 'package:sotkonya/widgets/details_container.dart';
import 'package:sotkonya/widgets/details_item_card.dart';
import 'package:sotkonya/widgets/layouts/details_page_layout.dart';
import 'package:sotkonya/widgets/promo_slider.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class YurtDetailsScreen extends ConsumerWidget {
  const YurtDetailsScreen({
    super.key,
    required this.color,
    required this.obj,
  });

  final Color color;
  final YurtModel obj;

  Future<void> _openLocation() async {
    if (obj.konumLink.isEmpty) return;
    final uri = Uri.parse(obj.konumLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return DetailsPageLayout(
      title: l10n.housingDetails,
      child: Column(
        children: [
          PromoSlider(items: obj.images, color: color, height: 250),
          const SizedBox(height: 15),
          DetailsItemCard(
            padding: 0,
            color: color,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              obj.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              obj.durum,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined, color: color),
                          const SizedBox(width: 4),
                          Expanded(child: Text(obj.konum)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline_sharp, color: color),
                          const SizedBox(width: 4),
                          Expanded(child: Text(obj.personelData)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_money_rounded, color: color),
                          const SizedBox(width: 4),
                          Expanded(child: Text(obj.fiyat)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: _openLocation,
                          child: Text(
                            l10n.viewOnMap,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          DetailsContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutHousing,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  obj.details,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          DetailsContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.contactInfo,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ContactInformation(
                  color: color,
                  icon: Icons.phone_enabled,
                  data: obj.telefone,
                ),
                const SizedBox(height: 10),
                ContactInformation(
                  color: color,
                  icon: Icons.location_on,
                  data: obj.konum,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}





