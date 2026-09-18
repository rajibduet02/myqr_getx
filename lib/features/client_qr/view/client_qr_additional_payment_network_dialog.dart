import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../controller/client_qr_controller.dart';
import '../models/client_qr_additional_payment_network_state.dart';
import '../widgets/client_qr_tag26_institution_id_field.dart';
import '../widgets/client_qr_tag26_institution_type_field.dart';
import '../widgets/client_qr_tag26_sheet_theme.dart';

void showClientQrTag26AdditionalPaymentNetworkDialog(
  BuildContext context,
  ClientQrController c,
) {
  final state = c.tag26PaymentNetwork;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(ClientQrTag26SheetTheme.sheetRadius),
              ),
              child: Material(
                color: ClientQrTag26SheetTheme.sheetBackground,
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ClientQrTag26SheetHandle(),
                        ClientQrTag26SheetHeader(onClose: Get.back),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            ClientQrTag26SheetTheme.horizontalPadding,
                            ClientQrTag26SheetTheme.headerToFields,
                            ClientQrTag26SheetTheme.horizontalPadding,
                            8,
                          ),
                          child: Column(
                            children: [
                              ClientQrTag26FieldGroup(
                                tag: '00',
                                label: 'Globally Unique Identifier',
                                child: ClientQrTag26ReadOnlyField(
                                  controller: state.globallyUniqueIdentifier,
                                ),
                              ),
                              const SizedBox(height: ClientQrTag26SheetTheme.fieldGap),
                              ClientQrTag26InstitutionTypeField(
                                selectedCode: state.selectedRecipientsInstitutionTypeCode,
                                onSelected: (code) {
                                  setSheetState(() {
                                    state.selectedRecipientsInstitutionTypeCode = code;
                                  });
                                },
                              ),
                              const SizedBox(height: ClientQrTag26SheetTheme.fieldGap),
                              ClientQrTag26InstitutionIdField(
                                selectedCode: state.selectedRecipientsInstitutionIdCode,
                                onSelected: (code) {
                                  setSheetState(() {
                                    state.selectedRecipientsInstitutionIdCode = code;
                                  });
                                },
                              ),
                              const SizedBox(height: ClientQrTag26SheetTheme.fieldGap),
                              ClientQrTag26FieldGroup(
                                tag: '03',
                                label: 'Recipient PAN',
                                child: ClientQrTag26TextField(
                                  controller: state.recipientPan,
                                  hintText: 'Enter recipient PAN',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClientQrTag26SheetActions(
                          onSave: c.applyTag26AdditionalPaymentNetwork,
                          onCancel: c.clearTag26AdditionalPaymentNetwork,
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
    },
  );
}

void showClientQrTag27AdditionalPaymentNetworkDialog(ClientQrController c) {
  showClientQrAdditionalPaymentNetworkDialog(
    state: c.tag27PaymentNetwork,
    onApply: c.applyTag27AdditionalPaymentNetwork,
    onClear: c.clearTag27AdditionalPaymentNetwork,
  );
}

void showClientQrAdditionalPaymentNetworkDialog({
  required ClientQrAdditionalPaymentNetworkState state,
  required VoidCallback onApply,
  required VoidCallback onClear,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: GlassContainer(
        strong: true,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -28,
              top: -28,
              child: InkResponse(
                onTap: Get.back,
                child: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(state.billNumber, '01-Bill Number'),
                  _dialogField(state.mobileNumber, '02-Mobile Number'),
                  _dialogField(state.storeLabel, '03-Store Label'),
                  _dialogField(state.loyalityNumber, '04-Loyality Number'),
                  _dialogField(state.referenceLabel, '05-Reference Label'),
                  _dialogField(state.consumerLabel, '06-Customer Label'),
                  _dialogField(state.terminalLabel, '07-Terminal Label'),
                  _dialogField(state.purposeOfTransaction, '08-Purpose of Transaction'),
                  _dialogField(
                    state.additionalConsumerRequest,
                    '09-Additional Consumer Data Request',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: AppColors.charcoalLight),
                        onPressed: onClear,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppColors.primary),
                        onPressed: onApply,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _dialogField(
  TextEditingController controller,
  String label, {
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      enableInteractiveSelection: !readOnly,
      cursorColor: AppColors.primary,
      style: AppStyles.formTextStyle,
      decoration: GlassTheme.inputDecoration(labelText: label),
    ),
  );
}
