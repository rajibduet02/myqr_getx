import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/widgets/glass_container.dart';
import '../binding/generate_binding.dart';
import '../controller/generate_controller.dart';

class GenerateView extends GetView<GenerateController> {
  const GenerateView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GenerateController>()) {
      GenerateBinding().dependencies();
    }

    return Scaffold(
      primary: false,
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: AppStyles.primaryButtonStyle,
                onPressed: () => Get.toNamed(AppRoutes.emvcoGenerator),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code),
                      const SizedBox(width: 10),
                      Text('EMV CO', style: AppStyles.buttonText),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: AppStyles.secondaryButtonStyle,
                onPressed: () => Get.toNamed(AppRoutes.otherQr),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code),
                      const SizedBox(width: 10),
                      Text('OTHERS', style: AppStyles.buttonText),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GlassContainer(
              strong: true,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.qr_code_2, size: 48, color: AppStyles.mediumText.color),
                  const SizedBox(height: 12),
                  Text(
                    'Generate QR Codes',
                    style: AppStyles.mediumText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose EMV CO merchant QR or other QR types',
                    style: AppStyles.normalText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          AdBannerWidget(slot: controller.adService.generateTab),
        ],
      ),
    );
  }
}
