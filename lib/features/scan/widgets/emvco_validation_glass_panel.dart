import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/emvco/emvco_qr_validation_result.dart';

class EmvcoValidationGlassPanel extends StatelessWidget {
  const EmvcoValidationGlassPanel({
    super.key,
    required this.status,
  });

  final EmvcoValidationStatus status;

  static const double horizontalMargin = 16;
  static const double bottomMargin = 12;
  static const double panelBorderRadius = 16;
  static const double contentVerticalPadding = 16;

  static double scrollBottomPadding(BuildContext context) {
    const contentHeight = 28.0;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    return contentVerticalPadding * 2 +
        contentHeight +
        bottomMargin +
        safeBottom +
        horizontalMargin;
  }

  @override
  Widget build(BuildContext context) {
    final isValid = status == EmvcoValidationStatus.valid;
    final accentColor =
        isValid ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final label = switch (status) {
      EmvcoValidationStatus.valid => 'Valid QR',
      EmvcoValidationStatus.invalidCrc => 'Invalid CRC',
      EmvcoValidationStatus.invalidSignature => 'Invalid Signature',
    };
    final icon = isValid ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final glassFill = Color.alphaBlend(
      accentColor.withValues(alpha: isValid ? 0.14 : 0.12),
      AppColors.white.withValues(alpha: GlassTheme.fillOpacity),
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          horizontalMargin,
          0,
          horizontalMargin,
          bottomMargin,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.97, end: 1).animate(animation),
                child: child,
              ),
            );
          },
          child: ClipRRect(
            key: ValueKey(status),
            borderRadius: BorderRadius.circular(panelBorderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: GlassTheme.blur,
                sigmaY: GlassTheme.blur,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(panelBorderRadius),
                  color: glassFill,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.14),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    ...GlassTheme.shadow,
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: contentVerticalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: accentColor, size: 26),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppStyles.mediumText.copyWith(
                            color: accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
