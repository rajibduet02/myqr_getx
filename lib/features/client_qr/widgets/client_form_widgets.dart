import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../controller/client_qr_controller.dart';
import '../view/client_dialogs.dart';
import '../view/client_qr_additional_payment_network_dialog.dart';
import '../view/client_qr_unreserved_signature_template_dialog.dart';

class ClientAdditionalFieldTile extends StatelessWidget {
  final ClientQrController controller;
  final dynamic spec;

  const ClientAdditionalFieldTile({
    super.key,
    required this.controller,
    required this.spec,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: TextFormField(
        controller: controller.liControllers[62],
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLength: int.parse(spec.Length as String),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onTap: () => showAdditionalFieldsDialog(context, controller),
        decoration: GlassTheme.inputDecoration(
          labelText: '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}

class ClientLanguageFieldTile extends StatelessWidget {
  final ClientQrController controller;
  final dynamic spec;
  final String? labelText;

  const ClientLanguageFieldTile({
    super.key,
    required this.controller,
    required this.spec,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: TextFormField(
        controller: controller.liControllers[64],
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLength: int.parse(spec.Length as String),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onTap: () => showLanguageTemplateDialog(context, controller),
        decoration: GlassTheme.inputDecoration(
          labelText: labelText ?? '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}

class ClientAdditionalPaymentNetworkFieldTile extends StatelessWidget {
  final ClientQrController controller;
  final dynamic spec;
  final int tagIndex;

  const ClientAdditionalPaymentNetworkFieldTile({
    super.key,
    required this.controller,
    required this.spec,
    required this.tagIndex,
  });

  void _openDialog(BuildContext context) {
    if (tagIndex == 26) {
      showClientQrTag26AdditionalPaymentNetworkDialog(context, controller);
    } else if (tagIndex == 27) {
      showClientQrTag27AdditionalPaymentNetworkDialog(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller.liControllers[tagIndex],
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLength: int.parse(spec.Length as String),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onTap: () => _openDialog(context),
        decoration: GlassTheme.inputDecoration(
          labelText: '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}

class ClientUnreservedSignatureTemplateFieldTile extends StatelessWidget {
  const ClientUnreservedSignatureTemplateFieldTile({
    super.key,
    required this.controller,
    required this.spec,
    required this.tagIndex,
    this.isRequired = false,
  });

  final ClientQrController controller;
  final dynamic spec;
  final int tagIndex;
  final bool isRequired;

  void _openDialog(BuildContext context) {
    if (tagIndex == 80) {
      showClientQrUnreservedSignatureTemplateDialog(
        context: context,
        controller: controller,
        tagIndex: tagIndex,
        state: controller.tag80SignatureTemplate,
        signaturePartLabel: 'Signature Part 1',
        onApply: controller.applyTag80UnreservedSignatureTemplate,
        onClear: controller.clearTag80UnreservedSignatureTemplate,
      );
      return;
    }

    if (tagIndex == 81) {
      showClientQrUnreservedSignatureTemplateDialog(
        context: context,
        controller: controller,
        tagIndex: tagIndex,
        state: controller.tag81SignatureTemplate,
        signaturePartLabel: 'Signature Part 2',
        onApply: controller.applyTag81UnreservedSignatureTemplate,
        onClear: controller.clearTag81UnreservedSignatureTemplate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller.liControllers[tagIndex],
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLength: int.parse(spec.Length as String),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        readOnly: true,
        enableInteractiveSelection: false,
        onTap: () => _openDialog(context),
        decoration: GlassTheme.inputDecoration(
          labelText: isRequired
              ? '${spec.Id}-${spec.Name} *'
              : '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}
