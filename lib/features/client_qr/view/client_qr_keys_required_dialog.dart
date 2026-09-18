import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/glass_container.dart';

Future<bool?> showClientQrKeysRequiredDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      content: GlassContainer(
        strong: true,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Keys Required',
              style: AppStyles.mediumText.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Private and Public keys must be generated for the selected '
              'recipient institution before generating the signature.',
              style: AppStyles.formTextStyle.copyWith(height: 1.45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Please generate the keys first.',
              style: AppStyles.formTextStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(
                      'Cancel',
                      style: AppStyles.formTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoalLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: AppStyles.primaryButtonStyle,
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text(
                      'Generate Keys',
                      style: AppStyles.buttonText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
