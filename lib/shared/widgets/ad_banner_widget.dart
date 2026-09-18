import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/services/ad_service.dart';
import 'glass_container.dart';

class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key, required this.slot});

  final AdBannerSlot slot;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      return const SizedBox.shrink();
    }

    return Center(
      child: GlassContainer(
        padding: const EdgeInsets.all(4),
        borderRadius: 12,
        blur: 10,
        child: SizedBox(
          width: slot.banner.size.width.toDouble(),
          height: slot.banner.size.height.toDouble(),
          child: AdWidget(ad: slot.banner),
        ),
      ),
    );
  }
}
