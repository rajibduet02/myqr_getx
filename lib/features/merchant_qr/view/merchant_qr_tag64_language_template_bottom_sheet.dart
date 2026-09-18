import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/merchant_qr_controller.dart';
import '../widgets/merchant_qr_tag26_sheet_theme.dart';

void showMerchantQrTag64LanguageTemplateBottomSheet(
  BuildContext context,
  MerchantQrController c,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(MerchantQrTag26SheetTheme.sheetRadius),
          ),
          child: Material(
            color: MerchantQrTag26SheetTheme.sheetBackground,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const MerchantQrTag26SheetHandle(),
                    _MerchantQrTag64SheetHeader(onClose: Get.back),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        MerchantQrTag26SheetTheme.horizontalPadding,
                        MerchantQrTag26SheetTheme.headerToFields,
                        MerchantQrTag26SheetTheme.horizontalPadding,
                        8,
                      ),
                      child: Column(
                        children: [
                          _MerchantQrTag64Field(
                            controller: c.languagePreference,
                            label: '00-Language Preference',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag64Field(
                            controller: c.merchantNameAl,
                            label: '01-Merchant Name—Alternate Language',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag64Field(
                            controller: c.merchantCityAl,
                            label: '02-Merchant City—Alternate Language',
                          ),
                        ],
                      ),
                    ),
                    MerchantQrTag26SheetActions(
                      onSave: c.applyLanguageTemplate,
                      onCancel: c.clearLanguageTemplate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _MerchantQrTag64SheetHeader extends StatelessWidget {
  const _MerchantQrTag64SheetHeader({required this.onClose});

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
                  'Merchant Information-Language Template',
                  style: AppStyles.mediumText.copyWith(
                    fontSize: 21,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Configure alternate language merchant details',
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
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.charcoalLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantQrTag64Field extends StatelessWidget {
  const _MerchantQrTag64Field({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    final dashIndex = label.indexOf('-');
    final tag = dashIndex > 0 ? label.substring(0, dashIndex) : '';
    final fieldLabel = dashIndex > 0 ? label.substring(dashIndex + 1) : label;

    return MerchantQrTag26FieldGroup(
      tag: tag,
      label: fieldLabel,
      child: MerchantQrTag26TextField(controller: controller),
    );
  }
}
