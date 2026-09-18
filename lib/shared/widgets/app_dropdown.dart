import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/theme/glass_theme.dart';

/// Dropdown with an opaque menu so open items stay readable over glass forms.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.icon,
    this.isExpanded = true,
    this.hint,
    this.menuMaxHeight = 320,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? icon;
  final bool isExpanded;
  final Widget? hint;
  final double menuMaxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
        border: Border.all(color: GlassTheme.borderColorSubtle, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: isExpanded,
          value: value,
          hint: hint,
          items: items,
          onChanged: onChanged,
          icon: icon ??
              const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
          elevation: 16,
          menuMaxHeight: menuMaxHeight,
          style: AppStyles.normalText,
          iconSize: 28,
        ),
      ),
    );
  }
}
