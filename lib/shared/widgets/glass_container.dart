import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/glass_theme.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur,
    this.color,
    this.onTap,
    this.width,
    this.height,
    this.strong = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? blur;
  final Color? color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? GlassTheme.borderRadius;
    final fill = color ??
        (strong ? GlassTheme.glassFillStrong : GlassTheme.glassFill);

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur ?? GlassTheme.blur,
          sigmaY: blur ?? GlassTheme.blur,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: fill,
            border: Border.all(color: GlassTheme.borderColor, width: 1.2),
            boxShadow: GlassTheme.shadow,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          highlightColor: AppColors.white.withValues(alpha: 0.08),
          child: content,
        ),
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
