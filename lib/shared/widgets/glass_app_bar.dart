import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/glass_theme.dart';

class GlassAppBar {
  GlassAppBar._();

  static PreferredSizeWidget build({
    required Widget title,
    PreferredSizeWidget? bottom,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
      title: title,
      bottom: bottom,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: GlassTheme.blur,
            sigmaY: GlassTheme.blur,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: GlassTheme.appBarOpacity),
              border: Border(
                bottom: BorderSide(color: GlassTheme.borderColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
