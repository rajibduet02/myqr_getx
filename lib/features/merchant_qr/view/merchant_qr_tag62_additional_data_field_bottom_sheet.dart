import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/merchant_qr_controller.dart';
import '../widgets/merchant_qr_tag26_sheet_theme.dart';
import 'merchant_qr_merchant_channel_bottom_sheet.dart';

void showMerchantQrTag62AdditionalDataFieldBottomSheet(
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
                    _MerchantQrTag62SheetHeader(onClose: Get.back),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        MerchantQrTag26SheetTheme.horizontalPadding,
                        MerchantQrTag26SheetTheme.headerToFields,
                        MerchantQrTag26SheetTheme.horizontalPadding,
                        8,
                      ),
                      child: Column(
                        children: [
                          _MerchantQrTag62Field(
                            controller: c.billNumber,
                            label: '01-Bill Number',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.mobileNumber,
                            label: '02-Mobile Number',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.storeLabel,
                            label: '03-Store Label',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.loyalityNumber,
                            label: '04-Loyality Number',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.referenceLabel,
                            label: '05-Reference Label',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.consumerLabel,
                            label: '06-Customer Label',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.terminalLabel,
                            label: '07-Terminal Label',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.purposeOfTransaction,
                            label: '08-Purpose of Transaction',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.additionalConsumerRequest,
                            label: '09-Additional Consumer Data Request',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62Field(
                            controller: c.merchantTaxId,
                            label: '10-Merchant Tax ID',
                          ),
                          const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                          _MerchantQrTag62MerchantChannelField(controller: c),
                        ],
                      ),
                    ),
                    MerchantQrTag26SheetActions(
                      onSave: c.applyAdditionalFields,
                      onCancel: c.clearAdditionalFields,
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

class _MerchantQrTag62SheetHeader extends StatelessWidget {
  const _MerchantQrTag62SheetHeader({required this.onClose});

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
                  'Additional Data Field Template',
                  style: AppStyles.mediumText.copyWith(
                    fontSize: 21,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Configure additional merchant data fields',
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

class _MerchantQrTag62Field extends StatelessWidget {
  const _MerchantQrTag62Field({
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

class _MerchantQrTag62MerchantChannelField extends StatelessWidget {
  const _MerchantQrTag62MerchantChannelField({required this.controller});

  final MerchantQrController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller.merchantChannel,
      builder: (context, _) {
        final value = controller.merchantChannel.text.trim();
        return MerchantQrTag26FieldGroup(
          tag: '11',
          label: 'Merchant Channel',
          child: MerchantQrTag26SelectorField(
            placeholder: 'Configure merchant channel',
            primaryText: value.isEmpty ? null : value,
            onTap: () => showMerchantQrMerchantChannelBottomSheet(
              context,
              controller,
            ),
          ),
        );
      },
    );
  }
}
