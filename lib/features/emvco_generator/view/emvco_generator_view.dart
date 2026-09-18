import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_scaffold.dart';
import '../../client_qr/view/client_qr_view.dart';
import '../../merchant_qr/view/merchant_qr_view.dart';
import '../controller/emvco_generator_controller.dart';
import 'generate_keys_bottom_sheet.dart';

class EmvcoGeneratorView extends GetView<EmvcoGeneratorController> {
  const EmvcoGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmvcoGeneratorController());

    return DefaultTabController(
      length: 2,
      child: GlassScaffold(
        appBar: GlassAppBar.build(
          title: const Text('AttoQR', style: AppStyles.appBarText),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_location), text: 'Merchant QR'),
              Tab(icon: Icon(Icons.contact_page_sharp), text: 'Client QR'),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'generate_keys') {
                  showGenerateKeysBottomSheet(context);
                } else if (value == 'generate_crc') {
                  Get.toNamed(AppRoutes.generateCrc);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Obx(
                    () => Row(
                      children: [
                        Checkbox(
                          value: controller.disableValidationObs.value,
                          onChanged: controller.toggleValidation,
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleValidation(
                            !controller.disableValidationObs.value,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text('Disable Validation', style: AppStyles.normalText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'generate_keys',
                  child: Text('Generate Keys', style: AppStyles.normalText),
                ),
                const PopupMenuItem<String>(
                  value: 'generate_crc',
                  child: Text('Generate CRC', style: AppStyles.normalText),
                ),
              ],
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            MerchantQrView(),
            ClientQrView(),
          ],
        ),
      ),
    );
  }
}
