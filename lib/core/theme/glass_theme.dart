import 'package:flutter/material.dart';

import 'app_colors.dart';

class GlassTheme {
  GlassTheme._();

  static const double blur = 18;
  static const double blurLight = 12;
  static const double borderRadius = 16;
  static const double borderRadiusSmall = 12;

  static const double fillOpacity = 0.22;
  static const double fillOpacityStrong = 0.32;
  static const double appBarOpacity = 0.78;
  static const double buttonOpacity = 0.88;

  static Color get borderColor => AppColors.white.withValues(alpha: 0.38);
  static Color get borderColorSubtle => AppColors.white.withValues(alpha: 0.22);
  static Color get glassFill => AppColors.white.withValues(alpha: fillOpacity);
  static Color get glassFillStrong => AppColors.white.withValues(alpha: fillOpacityStrong);

  static List<BoxShadow> get shadow => [
        BoxShadow(
          color: AppColors.charcoal.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static InputDecoration searchDecoration({
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      labelStyle: const TextStyle(color: AppColors.charcoalLight),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
    );
  }

  static InputDecoration inputDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool multiline = false,
  }) {
    final radius = BorderRadius.circular(
      multiline ? GlassTheme.borderRadius : GlassTheme.borderRadiusSmall,
    );
    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: borderColorSubtle),
    );
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: glassFill,
      labelStyle: const TextStyle(color: AppColors.charcoalLight),
      hintStyle: TextStyle(color: AppColors.charcoal.withValues(alpha: 0.45)),
      border: InputBorder.none,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
