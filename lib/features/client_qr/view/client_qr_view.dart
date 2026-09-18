import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart' as app;
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/glass_container.dart';
import '../controller/client_qr_controller.dart';
import '../widgets/client_form_widgets.dart';

class ClientQrView extends GetView<ClientQrController> {
  const ClientQrView({super.key});

  static const _fieldLabelOverrides = <int, String>{
    59: '59-Recipient Name',
    60: '60-Recipient City',
  };

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ClientQrController());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: c.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              strong: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _commonField(c, 0),
                  _pointOfInitiation(c),
                  _clientSelector(c),
                  _commonField(c, 2),
                ],
              ),
            ),
            GlassContainer(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              strong: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  for (var i = 52; i <= 64; i++) _fieldByIndex(context, c, i),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '65-79 RFU(Reserved for Future Use) by EMVCO',
                  style: AppStyles.normalText,
                ),
              ),
            ),
            GlassContainer(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              strong: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _unreservedSelector(c),
                  _fieldByIndex(context, c, 80),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 220,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
                        style: AppStyles.secondaryButtonStyle,
                        onPressed: () => c.generateRecipientSignature(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.draw_outlined),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Generate Signature',
                                style: AppStyles.buttonText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: AppStyles.primaryButtonStyle,
                        onPressed: () {
                          if (!c.attemptGenerateClientQr()) {
                            return;
                          }
                          final qr = c.buildFinalQr();
                          Get.toNamed(AppRoutes.qrGeneratedImage, arguments: qr);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_sharp),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('Generate', style: AppStyles.buttonText),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AdBannerWidget(slot: c.adService.clientQrTab),
          ],
        ),
      ),
    );
  }

  Widget _fieldByIndex(BuildContext context, ClientQrController c, int indx) {
    final o = c.getSpec(indx);
    if (indx == 54) {
      return Obx(
        () => Visibility(
          visible: app.disableValidation || c.showTransactionAmount.value,
          child: _commonField(c, indx),
        ),
      );
    }
    if (indx == 55 && !app.disableValidation) return _tipIndicator(c);
    if (indx == 56 && !app.disableValidation) {
      return Obx(
        () => Visibility(
          visible: c.showFixedTip.value,
          child: _commonField(c, indx),
        ),
      );
    }
    if (indx == 57 && !app.disableValidation) {
      return Obx(
        () => Visibility(
          visible: c.showPercentTip.value,
          child: _commonField(c, indx),
        ),
      );
    }
    if (indx == 62) {
      return ClientAdditionalFieldTile(controller: c, spec: o);
    }
    if (indx == 63) {
      return const Center(
        child: Text('63-Auto Generated CRC', style: AppStyles.normalText),
      );
    }
    if (indx == 64) {
      return ClientLanguageFieldTile(
        controller: c,
        spec: o,
        labelText: '64-Recipient Information-Language Template',
      );
    }
    if (indx == 52) {
      return _commonField(c, indx, readOnly: true);
    }
    if (indx >= 65 && indx <= 79) return const SizedBox.shrink();
    if (indx >= 80 && indx <= 99) {
      return Obx(
        () => Column(children: c.unreserved.toList()),
      );
    }
    return _commonField(c, indx);
  }

  Widget _commonField(ClientQrController c, int indx, {bool readOnly = false}) {
    final o = c.getSpec(indx);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: TextFormField(
        controller: c.liControllers[indx],
        enabled: app.disableValidation ? true : indx != 0,
        readOnly: readOnly,
        enableInteractiveSelection: !readOnly,
        cursorColor: AppColors.primary,
        style: AppStyles.formTextStyle,
        maxLength: app.disableValidation ? 100 : int.parse(o.Length),
        maxLengthEnforcement: app.disableValidation
            ? MaxLengthEnforcement.none
            : MaxLengthEnforcement.enforced,
        keyboardType: app.disableValidation
            ? TextInputType.text
            : o.Format == 'N'
                ? TextInputType.number
                : TextInputType.text,
        decoration: GlassTheme.inputDecoration(
          labelText: _fieldLabelOverrides[indx] ?? '${o.Id}-${o.Name}',
        ),
      ),
    );
  }

  Widget _pointOfInitiation(ClientQrController c) {
    if (app.disableValidation) return _commonField(c, 1);
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('01-Point of Initiation Method', style: AppStyles.normalText),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Radio<String>(
                    value: '',
                    groupValue: c.initiationMethod.value,
                    activeColor: AppColors.primary,
                    onChanged: c.setInitiationMethod,
                  ),
                  const Text('None', style: AppStyles.formTextStyle),
                  const SizedBox(width: 60),
                  Radio<String>(
                    value: '11',
                    groupValue: c.initiationMethod.value,
                    activeColor: AppColors.primary,
                    onChanged: c.setInitiationMethod,
                  ),
                  const Text('11-Static QR', style: AppStyles.formTextStyle),
                  const SizedBox(width: 60),
                  Radio<String>(
                    value: '12',
                    groupValue: c.initiationMethod.value,
                    activeColor: AppColors.primary,
                    onChanged: c.setInitiationMethod,
                  ),
                  const Text('12-Dyanamic QR', style: AppStyles.formTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipIndicator(ClientQrController c) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('55-Tip or Convenience indicator', style: AppStyles.normalText),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final entry in [
                    ('', 'None'),
                    ('01', '01-Prompt'),
                    ('02', '02-Fixed'),
                    ('03', '03-Percentage'),
                  ])
                    ...[
                      Radio<String>(
                        value: entry.$1,
                        groupValue: c.tipConvenienceIndicator.value,
                        activeColor: AppColors.primary,
                        onChanged: c.setTipIndicator,
                      ),
                      Text(entry.$2, style: AppStyles.formTextStyle),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clientSelector(ClientQrController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 8, 15, 4),
          child: Text('02-51 (Merchant Informations)', style: AppStyles.normalText),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Obx(
            () => AppDropdown<String>(
              value: c.selectedClientField.value,
              hint: const Text('Select merchant field', style: AppStyles.normalText),
              icon: const FaIcon(FontAwesomeIcons.angleDown, color: AppColors.primary),
              menuMaxHeight: 360,
              items: c.specList.SpecList
                  .getRange(2, 52)
                  .where((e) => !e.Name.contains('AMAR NAM RAJIB'))
                  .map(
                    (spec) => DropdownMenuItem<String>(
                      value: spec.Id,
                      child: Text(
                        '${spec.Id.padLeft(2, '0')}-${spec.Name}',
                        style: AppStyles.normalText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  c.selectedClientField.value = v;
                  c.addClientField(v);
                }
              },
            ),
          ),
        ),
        Obx(() => Column(children: c.clientInformation.toList())),
      ],
    );
  }

  Widget _unreservedSelector(ClientQrController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 8, 15, 4),
          child: Text('80-99 Unreserved Templates', style: AppStyles.normalText),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Obx(
            () => AppDropdown<String>(
              value: c.selectedUnreserved.value,
              hint: const Text('Select unreserved template', style: AppStyles.normalText),
              icon: const FaIcon(FontAwesomeIcons.angleDown, color: AppColors.primary),
              menuMaxHeight: 360,
              items: c.specList.SpecList
                  .getRange(80, 99)
                  .where((e) => !e.Name.contains('EMVCO'))
                  .where((e) => e.Id != '80' && e.Id != '81')
                  .map(
                    (spec) => DropdownMenuItem<String>(
                      value: spec.Id,
                      child: Text(
                        '${spec.Id.padLeft(2, '0')}-${spec.Name}',
                        style: AppStyles.normalText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  c.selectedUnreserved.value = v;
                  c.addUnreservedField(v);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
