import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

/// Tag 26 bottom sheet presentation tokens — scoped to Merchant QR Tag 26 only.
class MerchantQrTag26SheetTheme {
  MerchantQrTag26SheetTheme._();

  static const sheetRadius = 26.0;
  static const fieldRadius = 14.0;
  static const badgeRadius = 8.0;
  static const fieldHeight = 56.0;
  static const buttonHeight = 54.0;
  static const horizontalPadding = 22.0;
  static const headerToFields = 22.0;
  static const fieldGap = 20.0;
  static const labelGap = 8.0;
  static const actionGap = 24.0;

  static const sheetBackground = AppColors.white;
  static const fieldFill = Color(0xFFF7F8FA);
  static const readOnlyFill = Color(0xFFF1F3F6);
  static const fieldBorder = Color(0xFFE3E6EA);
  static const divider = Color(0xFFEEF0F3);
  static const subtitle = Color(0xFF7A828A);
  static const placeholder = Color(0xFF9AA3AD);

  static BoxDecoration fieldDecoration({bool readOnly = false, bool focused = false}) {
    return BoxDecoration(
      color: readOnly ? readOnlyFill : fieldFill,
      borderRadius: BorderRadius.circular(fieldRadius),
      border: Border.all(
        color: focused
            ? AppColors.primary.withValues(alpha: 0.55)
            : readOnly
                ? fieldBorder.withValues(alpha: 0.85)
                : fieldBorder,
        width: focused ? 1.4 : 1,
      ),
    );
  }

  static InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppStyles.formTextStyle.copyWith(color: placeholder),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }
}

class MerchantQrTag26FieldLabel extends StatelessWidget {
  const MerchantQrTag26FieldLabel({
    super.key,
    required this.tag,
    required this.label,
  });

  final String tag;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MerchantQrTag26CodeBadge(code: tag),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppStyles.formTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class MerchantQrTag26CodeBadge extends StatelessWidget {
  const MerchantQrTag26CodeBadge({
    super.key,
    required this.code,
    this.compact = false,
  });

  final String code;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(MerchantQrTag26SheetTheme.badgeRadius),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: AppColors.primaryDark,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'cambria',
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class MerchantQrTag26ReadOnlyField extends StatelessWidget {
  const MerchantQrTag26ReadOnlyField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MerchantQrTag26SheetTheme.fieldHeight,
      decoration: MerchantQrTag26SheetTheme.fieldDecoration(readOnly: true),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(
            Icons.verified_outlined,
            size: 20,
            color: AppColors.primary.withValues(alpha: 0.75),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.text,
              style: AppStyles.formTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class MerchantQrTag26TextField extends StatelessWidget {
  const MerchantQrTag26TextField({
    super.key,
    required this.controller,
    this.hintText,
  });

  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MerchantQrTag26SheetTheme.fieldDecoration(),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle.copyWith(fontWeight: FontWeight.w500),
        decoration: MerchantQrTag26SheetTheme.inputDecoration(hintText: hintText),
      ),
    );
  }
}

class MerchantQrTag26SelectorField extends StatelessWidget {
  const MerchantQrTag26SelectorField({
    super.key,
    required this.onTap,
    required this.placeholder,
    this.primaryText,
    this.secondaryCode,
  });

  final VoidCallback onTap;
  final String placeholder;
  final String? primaryText;
  final String? secondaryCode;

  @override
  Widget build(BuildContext context) {
    final hasSelection = primaryText != null && primaryText!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MerchantQrTag26SheetTheme.fieldRadius),
        child: Ink(
          height: MerchantQrTag26SheetTheme.fieldHeight,
          decoration: MerchantQrTag26SheetTheme.fieldDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Expanded(
                child: hasSelection
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            primaryText!,
                            style: AppStyles.formTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (secondaryCode != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              secondaryCode!,
                              style: AppStyles.formTextStyle.copyWith(
                                fontSize: 12,
                                color: MerchantQrTag26SheetTheme.subtitle,
                              ),
                            ),
                          ],
                        ],
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          placeholder,
                          style: AppStyles.formTextStyle.copyWith(
                            color: MerchantQrTag26SheetTheme.placeholder,
                          ),
                        ),
                      ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary.withValues(alpha: 0.85),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MerchantQrTag26SheetHandle extends StatelessWidget {
  const MerchantQrTag26SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        margin: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: BoxDecoration(
          color: MerchantQrTag26SheetTheme.fieldBorder,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

class MerchantQrTag26SheetHeader extends StatelessWidget {
  const MerchantQrTag26SheetHeader({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        MerchantQrTag26SheetTheme.horizontalPadding,
        4,
        12,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Payment Network',
                  style: AppStyles.mediumText.copyWith(
                    fontSize: 21,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Configure recipient institution information',
                  style: AppStyles.formTextStyle.copyWith(
                    fontSize: 13,
                    color: MerchantQrTag26SheetTheme.subtitle,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: MerchantQrTag26SheetTheme.fieldFill,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onClose,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close_rounded, size: 20, color: AppColors.charcoalLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MerchantQrTag26SheetActions extends StatelessWidget {
  const MerchantQrTag26SheetActions({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        MerchantQrTag26SheetTheme.horizontalPadding,
        MerchantQrTag26SheetTheme.actionGap,
        MerchantQrTag26SheetTheme.horizontalPadding,
        8,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MerchantQrTag26SheetTheme.buttonHeight,
            child: ElevatedButton(
              style: AppStyles.primaryButtonStyle.copyWith(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MerchantQrTag26SheetTheme.fieldRadius),
                  ),
                ),
              ),
              onPressed: onSave,
              child: const Text('Save', style: AppStyles.buttonText),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.charcoalLight,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              'Clear & Close',
              style: AppStyles.formTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.charcoalLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MerchantQrTag26FieldGroup extends StatelessWidget {
  const MerchantQrTag26FieldGroup({
    super.key,
    required this.tag,
    required this.label,
    required this.child,
  });

  final String tag;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MerchantQrTag26FieldLabel(tag: tag, label: label),
        SizedBox(height: MerchantQrTag26SheetTheme.labelGap),
        child,
      ],
    );
  }
}
