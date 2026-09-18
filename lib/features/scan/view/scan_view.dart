import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/widgets/card_component.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/glass_fab.dart';
import '../binding/scan_binding.dart';
import '../controller/scan_controller.dart';
import '../widgets/emvco_validation_glass_panel.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ScanController>()) {
      ScanBinding().dependencies();
    }

    return Scaffold(
      primary: false,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: AppStyles.primaryButtonStyle,
                onPressed: controller.scanFromCamera,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_enhance_sharp),
                      const SizedBox(width: 10),
                      Text('CAMERA', style: AppStyles.buttonText),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: AppStyles.secondaryButtonStyle,
                onPressed: controller.scanFromGallery,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_album_sharp),
                      const SizedBox(width: 10),
                      Text('GALLERY', style: AppStyles.buttonText),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () {
              if (!controller.hasScannedEmvco) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!controller.isRaw.value)
                      Expanded(
                        child: GlassContainer(
                          strong: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          borderRadius: GlassTheme.borderRadiusSmall,
                          child: TextField(
                            controller: controller.searchController,
                            cursorColor: AppColors.primary,
                            style: AppStyles.normalText,
                            decoration: GlassTheme.searchDecoration(
                              labelText: 'Search Fields',
                              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                              suffixIcon: IconButton(
                                icon: controller.searchController.text.isNotEmpty
                                    ? const Icon(Icons.clear, color: AppColors.primary)
                                    : const Icon(Icons.circle, color: Colors.transparent, size: 0),
                                onPressed: controller.clearSearch,
                              ),
                            ),
                            onChanged: controller.searchList,
                          ),
                        ),
                      ),
                    GlassContainer(
                      margin: EdgeInsets.only(left: controller.isRaw.value ? 0 : 8),
                      strong: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      borderRadius: GlassTheme.borderRadiusSmall,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Raw Data', style: AppStyles.normalText),
                          Checkbox(
                            value: controller.isRaw.value,
                            onChanged: controller.toggleRaw,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          AdBannerWidget(slot: controller.adService.scanTab),
          Obx(() => _buildResults(context)),
        ],
      ),
      floatingActionButton: Obx(
        () => controller.showFloatingAction.value
            ? GlassFab(
                onPressed: controller.backToMainData,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (controller.isValidEmvco.value) {
      if (controller.isRaw.value) {
        return Expanded(
          child: _buildEmvcoResultStack(
            context,
            scrollChild: Obx(
              () {
                final bottomPadding = _validationBottomPadding(context);
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, bottomPadding),
                  child: GlassContainer(
                    strong: true,
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: GlassTheme.inputDecoration(
                        hintText: 'Raw QR data',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        multiline: true,
                      ),
                      textAlign: TextAlign.center,
                      style: AppStyles.mediumText,
                      controller: controller.qrTextController,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      return Expanded(
        child: _buildEmvcoResultStack(
          context,
          scrollChild: Padding(
            padding: const EdgeInsets.all(8),
            child: GlassContainer(
              strong: true,
              padding: const EdgeInsets.all(4),
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    8,
                    8,
                    8,
                    _validationBottomPadding(context),
                  ),
                  itemCount: controller.fieldDetails.length,
                  itemBuilder: (context, index) => _fieldItem(context, index),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Obx(
      () {
        if (!controller.showNormalQr.value) {
          return const Expanded(child: SizedBox.shrink());
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GlassContainer(
              strong: true,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.contentType.value, style: AppStyles.mediumText),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: controller.launchContent,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      controller: controller.qrTextController,
                      readOnly: true,
                      maxLines: null,
                      style: AppStyles.hyperLinkText,
                      decoration: GlassTheme.inputDecoration(
                        labelText: 'QR Content',
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.contentType.value == 'WIFI'
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: AppStyles.primaryButtonStyle,
                                onPressed: controller.connectToWifi,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.wifi, color: Colors.white),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text('CONNECT', style: AppStyles.buttonText),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _validationBottomPadding(BuildContext context) {
    if (!controller.shouldDisplayValidationPanel) {
      return 8;
    }
    return EmvcoValidationGlassPanel.scrollBottomPadding(context);
  }

  Widget _buildEmvcoResultStack(
    BuildContext context, {
    required Widget scrollChild,
  }) {
    return Obx(
      () {
        final showPanel = controller.shouldDisplayValidationPanel;

        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: scrollChild),
            if (showPanel)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: EmvcoValidationGlassPanel(
                  status: controller.emvcoValidationStatus.value!,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _fieldItem(BuildContext context, int index) {
    final field = controller.fieldDetails[index];
    return CardComponent(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              ' ${field.tag} - ${field.specification.Name.toUpperCase()}',
              style: AppStyles.mediumText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Text(field.value, style: AppStyles.mediumText),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Format  : ${field.specification.Format}', style: AppStyles.normalText),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text('Length  : ${field.specification.Length}', style: AppStyles.normalText),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text('Presence  : ${field.specification.Presence}', style: AppStyles.normalText),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('-------', style: AppStyles.normalText),
          ),
          if (controller.shouldShowExtractButton(field))
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: AppStyles.primaryButtonStyle,
                  onPressed: () => controller.onExtractTap(field),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Extract', style: AppStyles.buttonText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Comments :  ${field.specification.Comments}',
              style: AppStyles.normalText,
            ),
          ),
        ],
      ),
    );
  }
}
