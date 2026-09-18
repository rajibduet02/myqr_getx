import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/merchant_qr_controller.dart';
import '../widgets/merchant_qr_tag26_institution_id_field.dart';
import '../widgets/merchant_qr_tag26_institution_type_field.dart';
import '../widgets/merchant_qr_tag26_sheet_theme.dart';

void showMerchantQrTag26AdditionalPaymentNetworkBottomSheet(
  BuildContext context,
  MerchantQrController c,
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
                        MerchantQrTag26SheetHeader(onClose: Get.back),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            MerchantQrTag26SheetTheme.horizontalPadding,
                            MerchantQrTag26SheetTheme.headerToFields,
                            MerchantQrTag26SheetTheme.horizontalPadding,
                            8,
                          ),
                          child: Column(
                            children: [
                              MerchantQrTag26FieldGroup(
                                tag: '00',
                                label: 'Globally Unique Identifier',
                                child: MerchantQrTag26ReadOnlyField(
                                  controller: state.globallyUniqueIdentifier,
                                ),
                              ),
                              const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                              MerchantQrTag26InstitutionTypeField(
                                selectedCode:
                                    state.selectedRecipientsInstitutionTypeCode,
                                onSelected: (code) {
                                  setSheetState(() {
                                    state.selectedRecipientsInstitutionTypeCode =
                                        code;
                                  });
                                },
                              ),
                              const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                              MerchantQrTag26InstitutionIdField(
                                selectedCode:
                                    state.selectedRecipientsInstitutionIdCode,
                                onSelected: (code) {
                                  setSheetState(() {
                                    state.selectedRecipientsInstitutionIdCode =
                                        code;
                                  });
                                },
                              ),
                              const SizedBox(height: MerchantQrTag26SheetTheme.fieldGap),
                              MerchantQrTag26FieldGroup(
                                tag: '03',
                                label: 'Merchant PAN',
                                child: MerchantQrTag26TextField(
                                  controller: state.recipientPan,
                                  hintText: 'Enter merchant PAN',
                                ),
                              ),
                            ],
                          ),
                        ),
                        MerchantQrTag26SheetActions(//check if the selected institution type is valid for the selected institution id
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
