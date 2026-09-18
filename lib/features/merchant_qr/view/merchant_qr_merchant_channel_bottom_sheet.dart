import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/merchant_qr_controller.dart';
import '../models/merchant_qr_merchant_channel_options.dart';
import '../widgets/merchant_qr_tag26_sheet_theme.dart';

void showMerchantQrMerchantChannelBottomSheet(
  BuildContext context,
  MerchantQrController c,
) {
  c.prepareMerchantChannelSheet();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            final state = c.merchantChannelState;
            final media = MerchantQrMerchantChannelOptions.findMedia(
              state.mediaCode,
            );
            final location =
                MerchantQrMerchantChannelOptions.findTransactionLocation(
              state.transactionLocationCode,
            );
            final presence =
                MerchantQrMerchantChannelOptions.findMerchantPresence(
              state.merchantPresenceCode,
            );

            return ClipRRect(
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
                        _MerchantChannelSheetHeader(onClose: Get.back),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            MerchantQrTag26SheetTheme.horizontalPadding,
                            MerchantQrTag26SheetTheme.headerToFields,
                            MerchantQrTag26SheetTheme.horizontalPadding,
                            8,
                          ),
                          child: Column(
                            children: [
                              _MerchantChannelDropdown(
                                label: 'Media',
                                placeholder: 'Select media',
                                option: media,
                                onTap: () => _openOptionPicker(
                                  context: context,
                                  title: 'Select Media',
                                  options:
                                      MerchantQrMerchantChannelOptions.media,
                                  selectedCode: state.mediaCode,
                                  onSelected: (code) {
                                    setSheetState(() {
                                      state.mediaCode = code;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: MerchantQrTag26SheetTheme.fieldGap,
                              ),
                              _MerchantChannelDropdown(
                                label: 'Transaction Location',
                                placeholder: 'Select transaction location',
                                option: location,
                                onTap: () => _openOptionPicker(
                                  context: context,
                                  title: 'Select Transaction Location',
                                  options: MerchantQrMerchantChannelOptions
                                      .transactionLocation,
                                  selectedCode: state.transactionLocationCode,
                                  onSelected: (code) {
                                    setSheetState(() {
                                      state.transactionLocationCode = code;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: MerchantQrTag26SheetTheme.fieldGap,
                              ),
                              _MerchantChannelDropdown(
                                label: 'Merchant Presence',
                                placeholder: 'Select merchant presence',
                                option: presence,
                                onTap: () => _openOptionPicker(
                                  context: context,
                                  title: 'Select Merchant Presence',
                                  options: MerchantQrMerchantChannelOptions
                                      .merchantPresence,
                                  selectedCode: state.merchantPresenceCode,
                                  onSelected: (code) {
                                    setSheetState(() {
                                      state.merchantPresenceCode = code;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        MerchantQrTag26SheetActions(
                          onSave: () {
                            final error = c.applyMerchantChannel();
                            if (error != null) {
                              Fluttertoast.showToast(
                                msg: error,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: AppColors.primary,
                                textColor: Colors.white,
                              );
                            }
                          },
                          onCancel: c.clearMerchantChannel,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

void _openOptionPicker({
  required BuildContext context,
  required String title,
  required List<MerchantQrMerchantChannelOption> options,
  required String? selectedCode,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final maxHeight = MediaQuery.of(sheetContext).size.height * 0.62;
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(MerchantQrTag26SheetTheme.sheetRadius),
        ),
        child: Material(
          color: MerchantQrTag26SheetTheme.sheetBackground,
          child: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MerchantQrTag26SheetHandle(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      MerchantQrTag26SheetTheme.horizontalPadding,
                      0,
                      MerchantQrTag26SheetTheme.horizontalPadding,
                      12,
                    ),
                    child: Text(
                      title,
                      style: AppStyles.mediumText.copyWith(fontSize: 18),
                    ),
                  ),
                  const Divider(height: 1, color: MerchantQrTag26SheetTheme.divider),
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final item = options[index];
                        final isSelected = item.code == selectedCode;
                        return Material(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              onSelected(item.code);
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    MerchantQrTag26SheetTheme.horizontalPadding,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  MerchantQrTag26CodeBadge(
                                    code: item.code,
                                    compact: true,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: AppStyles.formTextStyle.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _MerchantChannelSheetHeader extends StatelessWidget {
  const _MerchantChannelSheetHeader({required this.onClose});

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
                  'Merchant Channel',
                  style: AppStyles.mediumText.copyWith(
                    fontSize: 21,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select media, location, and merchant presence',
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

class _MerchantChannelDropdown extends StatelessWidget {
  const _MerchantChannelDropdown({
    required this.label,
    required this.placeholder,
    required this.option,
    required this.onTap,
  });

  final String label;
  final String placeholder;
  final MerchantQrMerchantChannelOption? option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.formTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.25,
          ),
        ),
        SizedBox(height: MerchantQrTag26SheetTheme.labelGap),
        MerchantQrTag26SelectorField(
          placeholder: placeholder,
          primaryText: option?.label,
          secondaryCode: option?.code,
          onTap: onTap,
        ),
      ],
    );
  }
}
