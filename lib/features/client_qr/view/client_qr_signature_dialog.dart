import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/glass_container.dart';

void showClientQrSignatureDialog(BuildContext context, String signatureBase64) {
  showDialog<void>(
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
              'Signature Generated',
              style: AppStyles.mediumText.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
                border: Border.all(color: GlassTheme.borderColorSubtle),
              ),
              child: SelectableText(
                signatureBase64,
                style: AppStyles.formTextStyle.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: signatureBase64));
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Signature copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Copy', style: AppStyles.normalText),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: AppStyles.primaryButtonStyle,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('OK', style: AppStyles.buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
