import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../controller/merchant_qr_controller.dart';
import '../view/merchant_qr_tag26_additional_payment_network_bottom_sheet.dart';
import '../view/merchant_qr_tag62_additional_data_field_bottom_sheet.dart';
import '../view/merchant_qr_tag64_language_template_bottom_sheet.dart';

class MerchantTag26AdditionalPaymentNetworkFieldTile extends StatelessWidget {
  const MerchantTag26AdditionalPaymentNetworkFieldTile({
    super.key,
    required this.controller,
    required this.spec,
  });

  final MerchantQrController controller;
  final dynamic spec;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller.liControllers[26],
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLength: int.parse(spec.Length as String),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        readOnly: true,
        onTap: () => showMerchantQrTag26AdditionalPaymentNetworkBottomSheet(
          context,
          controller,
        ),
        decoration: GlassTheme.inputDecoration(
          labelText: '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}

class MerchantAdditionalFieldTile extends StatelessWidget {
  final MerchantQrController controller;
  final dynamic spec;

  const MerchantAdditionalFieldTile({
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
        onTap: () => showMerchantQrTag62AdditionalDataFieldBottomSheet(
          context,
          controller,
        ),
        decoration: GlassTheme.inputDecoration(
          labelText: '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}

class MerchantLanguageFieldTile extends StatelessWidget {
  final MerchantQrController controller;
  final dynamic spec;

  const MerchantLanguageFieldTile({
    super.key,
    required this.controller,
    required this.spec,
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
        onTap: () => showMerchantQrTag64LanguageTemplateBottomSheet(
          context,
          controller,
        ),
        decoration: GlassTheme.inputDecoration(
          labelText: '${spec.Id}-${spec.Name}',
        ),
      ),
    );
  }
}
