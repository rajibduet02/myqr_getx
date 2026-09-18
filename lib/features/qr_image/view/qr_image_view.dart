import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;
import 'package:screenshot/screenshot.dart';

import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/glass_fab.dart';
import '../../../shared/widgets/glass_scaffold.dart';
import '../controller/qr_image_controller.dart';

class QrImageScreen extends GetWidget<QrImageController> {
  const QrImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar.build(
        title: const Text('QR Image', style: AppStyles.appBarText),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            strong: true,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            child: Screenshot(
              controller: controller.screenshotController,
              child: qr.QrImageView(
                data: controller.qrString,
                version: qr.QrVersions.auto,
                size: 320,
                gapless: false,
                backgroundColor: Colors.white,
                embeddedImage: const AssetImage('assets/images/logo.png'),
                embeddedImageStyle: const qr.QrEmbeddedImageStyle(size: Size(45, 45)),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: AppStyles.primaryButtonStyle,
                onPressed: controller.shareScreenshot,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.share, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('SHARE', style: AppStyles.buttonText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AdBannerWidget(slot: controller.adService.qrImage),
        ],
      ),
      floatingActionButton: GlassFab(
        onPressed: Get.back,
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}
