import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/glass_scaffold.dart';
import '../controller/other_qr_controller.dart';

class OtherQrView extends GetView<OtherQrController> {
  const OtherQrView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtherQrController());

    return GlassScaffold(
      appBar: GlassAppBar.build(
        title: const Text('QR-OTHERS', style: AppStyles.appBarText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassContainer(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                strong: true,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select a QR Type', style: AppStyles.formTextStyle),
                    Obx(
                      () => AppDropdown<String>(
                        value: controller.selectedQrType.value,
                        hint: const Text('Choose QR type', style: AppStyles.normalText),
                        icon: const FaIcon(FontAwesomeIcons.angleDown, color: AppColors.primary),
                        items: controller.qrTypes
                            .map(
                              (type) => DropdownMenuItem<String>(
                                value: type,
                                child: Row(
                                  children: [
                                    Icon(controller.iconForType(type), color: AppColors.primary),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(type, style: AppStyles.normalText),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => controller.selectedQrType.value = v,
                      ),
                    ),
                  ],
                ),
              ),
              GlassContainer(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                strong: true,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _field(
                      controller.qrContent,
                      controller.selectedQrType.value ?? 'Content',
                      multiline: true,
                    ),
                    Obx(
                      () => controller.selectedQrType.value == 'SMS'
                          ? _field(controller.smsQrContent, 'SMS Message')
                          : controller.selectedQrType.value == 'EMAIL'
                              ? Column(
                                  children: [
                                    _field(controller.emailCc, 'CC'),
                                    _field(controller.emailBcc, 'BCC'),
                                    _field(controller.emailSubject, 'SUBJECT'),
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(4, 12, 0, 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('BODY', style: AppStyles.formTextStyle),
                                      ),
                                    ),
                                    _field(controller.emailBody, '', multiline: true),
                                  ],
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: AppStyles.primaryButtonStyle,
                      onPressed: controller.generateQr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_sharp),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('Generate', style: AppStyles.buttonText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AdBannerWidget(slot: controller.adService.overlay),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: c,
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLines: multiline ? 10 : 1,
        keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
        decoration: GlassTheme.inputDecoration(
          labelText: label.isEmpty ? null : label,
          multiline: multiline,
        ),
      ),
    );
  }
}
