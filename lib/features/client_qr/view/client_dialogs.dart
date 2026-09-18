import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/client_qr_controller.dart';
import '../widgets/client_qr_tag26_sheet_theme.dart';

void showLanguageTemplateDialog(BuildContext context, ClientQrController c) {
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
                    ClientQrBottomSheetHeader(
                      title: 'Recipient Information-Language Template',
                      subtitle: 'Configure alternate language recipient details',
                      onClose: Get.back,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        ClientQrTag26SheetTheme.horizontalPadding,
                        ClientQrTag26SheetTheme.headerToFields,
                        ClientQrTag26SheetTheme.horizontalPadding,
                        8,
                      ),
                      child: Column(
                        children: _spacedFields([
                          ClientQrBottomSheetField(
                            controller: c.languagePreference,
                            label: '00-Language Preference',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.merchantNameAl,
                            label: '01-Merchant Name—Alternate Language',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.merchantCityAl,
                            label: '02-Merchant City—Alternate Language',
                          ),
                        ]),
                      ),
                    ),
                    ClientQrTag26SheetActions(
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

void showAdditionalFieldsDialog(BuildContext context, ClientQrController c) {
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
                    ClientQrBottomSheetHeader(
                      title: 'Additional Data Field Template',
                      subtitle: 'Configure additional consumer data fields',
                      onClose: Get.back,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        ClientQrTag26SheetTheme.horizontalPadding,
                        ClientQrTag26SheetTheme.headerToFields,
                        ClientQrTag26SheetTheme.horizontalPadding,
                        8,
                      ),
                      child: Column(
                        children: _spacedFields([
                          ClientQrBottomSheetField(
                            controller: c.billNumber,
                            label: '01-Bill Number',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.mobileNumber,
                            label: '02-Mobile Number',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.storeLabel,
                            label: '03-Store Label',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.loyalityNumber,
                            label: '04-Loyality Number',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.referenceLabel,
                            label: '05-Reference Label',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.consumerLabel,
                            label: '06-Customer Label',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.terminalLabel,
                            label: '07-Terminal Label',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.purposeOfTransaction,
                            label: '08-Purpose of Transaction',
                          ),
                          ClientQrBottomSheetField(
                            controller: c.additionalConsumerRequest,
                            label: '09-Additional Consumer Data Request',
                          ),
                        ]),
                      ),
                    ),
                    ClientQrTag26SheetActions(
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

List<Widget> _spacedFields(List<Widget> fields) {
  if (fields.isEmpty) return fields;
  final spaced = <Widget>[];
  for (var i = 0; i < fields.length; i++) {
    spaced.add(fields[i]);
    if (i < fields.length - 1) {
      spaced.add(const SizedBox(height: ClientQrTag26SheetTheme.fieldGap));
    }
  }
  return spaced;
}
