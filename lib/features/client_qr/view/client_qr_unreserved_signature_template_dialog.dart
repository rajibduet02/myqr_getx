import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/client_qr_controller.dart';
import '../models/client_qr_unreserved_signature_template_state.dart';
import '../widgets/client_qr_tag26_sheet_theme.dart';

void showClientQrUnreservedSignatureTemplateDialog({
  required BuildContext context,
  required ClientQrController controller,
  required int tagIndex,
  required ClientQrUnreservedSignatureTemplateState state,
  required String signaturePartLabel,
  required VoidCallback onApply,
  required VoidCallback onClear,
}) {
  final tagLabel = tagIndex.toString().padLeft(2, '0');

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
                      title: '$tagLabel - Unreserved Template',
                      subtitle: 'Signature template for Ed25519 digital signature',
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
                        children: [
                          ClientQrTag26FieldGroup(
                            tag: '00',
                            label: 'Globally Unique Identifier',
                            child: ClientQrTag26ReadOnlyField(
                              controller: state.globallyUniqueIdentifier,
                            ),
                          ),
                          const SizedBox(height: ClientQrTag26SheetTheme.fieldGap),
                          ClientQrTag26FieldGroup(
                            tag: '01',
                            label: signaturePartLabel,
                            child: ClientQrTag26ReadOnlyField(
                              controller: state.signaturePart,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClientQrTag26SheetActions(
                      onSave: onApply,
                      onCancel: onClear,
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
