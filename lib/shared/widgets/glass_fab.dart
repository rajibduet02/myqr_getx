import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/glass_theme.dart';

class GlassFab extends StatelessWidget {
  const GlassFab({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: GlassTheme.blurLight,
          sigmaY: GlassTheme.blurLight,
        ),
        child: Material(
          color: AppColors.primary.withValues(alpha: GlassTheme.buttonOpacity),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: GlassTheme.borderColor),
          ),
          elevation: 0,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
