import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/glass_scaffold.dart';
import '../controller/generate_crc_controller.dart';

class GenerateCrcView extends GetView<GenerateCrcController> {
  const GenerateCrcView({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar.build(
        title: const Text('Generate CRC', style: AppStyles.appBarText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassContainer(
              strong: true,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EMVCo Payload',
                    style: AppStyles.mediumText,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Paste the payload including Tag 63 and length (6304), without the CRC value',
                    style: AppStyles.normalText.copyWith(
                      color: AppColors.charcoalLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.payloadController,
                    maxLines: 12,
                    minLines: 8,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: AppStyles.normalText.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                    decoration: GlassTheme.inputDecoration(
                      hintText: '000201010211...6304',
                      multiline: true,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Paste from clipboard',
                            onPressed: controller.pasteFromClipboard,
                            icon: const Icon(
                              Icons.content_paste_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Clear',
                            onPressed: controller.clearInput,
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.payloadController,
                    builder: (context, value, _) {
                      final length = value.text.trim().replaceAll(RegExp(r'\s+'), '').length;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$length characters',
                            style: AppStyles.normalText.copyWith(
                              color: AppColors.charcoalLight,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: AppStyles.primaryButtonStyle,
              onPressed: controller.generateCrc,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_2_rounded, color: Colors.white),
                    const SizedBox(width: 10),
                    Text('Generate CRC', style: AppStyles.buttonText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
