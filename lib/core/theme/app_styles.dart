import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'glass_theme.dart';

class AppStyles {
  AppStyles._();

  static const normalText = TextStyle(
    color: AppColors.charcoal,
    fontSize: 15,
    fontFamily: 'cambria',
    fontWeight: FontWeight.w100,
  );

  static const formTextStyle = TextStyle(
    color: AppColors.charcoal,
    fontSize: 15,
    fontFamily: 'cambria',
    fontWeight: FontWeight.w100,
  );

  static const appBarText = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontFamily: 'cambria',
    fontWeight: FontWeight.w100,
  );

  static const buttonText = TextStyle(
    color: AppColors.white,
    fontSize: 15,
    fontFamily: 'cambria',
    fontWeight: FontWeight.bold,
  );

  static const mediumText = TextStyle(
    color: AppColors.charcoal,
    fontSize: 20,
    fontFamily: 'cambria',
    fontWeight: FontWeight.bold,
  );

  static const hyperLinkText = TextStyle(
    color: AppColors.primary,
    fontSize: 20,
    fontFamily: 'cambria',
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static final primaryButtonStyle = ButtonStyle(
    foregroundColor: WidgetStateProperty.all<Color>(AppColors.white),
    backgroundColor: WidgetStateProperty.all<Color>(
      AppColors.primary.withValues(alpha: GlassTheme.buttonOpacity),
    ),
    overlayColor: WidgetStateProperty.all<Color>(
      AppColors.white.withValues(alpha: 0.12),
    ),
    elevation: WidgetStateProperty.all<double>(0),
    shadowColor: WidgetStateProperty.all<Color>(
      AppColors.primary.withValues(alpha: 0.25),
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
        side: BorderSide(color: GlassTheme.borderColor),
      ),
    ),
  );

  static final secondaryButtonStyle = ButtonStyle(
    foregroundColor: WidgetStateProperty.all<Color>(AppColors.white),
    backgroundColor: WidgetStateProperty.all<Color>(
      AppColors.charcoal.withValues(alpha: GlassTheme.buttonOpacity),
    ),
    overlayColor: WidgetStateProperty.all<Color>(
      AppColors.white.withValues(alpha: 0.1),
    ),
    elevation: WidgetStateProperty.all<double>(0),
    shadowColor: WidgetStateProperty.all<Color>(
      AppColors.charcoal.withValues(alpha: 0.2),
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
        side: BorderSide(color: GlassTheme.borderColorSubtle),
      ),
    ),
  );

  static final greenButtonStyle = primaryButtonStyle;
  static final orangeButtonStyle = secondaryButtonStyle;
}
