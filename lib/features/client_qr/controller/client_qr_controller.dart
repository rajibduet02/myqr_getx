import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/crc/crc.dart';
import '../../../shared/crc/crc_std_parameters.dart';
import '../../../shared/models/emvco_spec_list.dart';
import '../../../shared/models/emv_spec.dart';
import '../../../shared/repositories/emvco_repository.dart';
import '../../emvco_generator/services/emvco_private_key_storage_service.dart';
import '../../emvco_generator/view/generate_keys_bottom_sheet.dart';
import '../models/client_qr_additional_payment_network_state.dart';
import '../models/client_qr_tag26_payment_network_state.dart';
import '../models/client_qr_unreserved_signature_template_state.dart';
import '../services/client_qr_signature_service.dart';
import '../view/client_qr_keys_required_dialog.dart';
import '../widgets/client_form_widgets.dart';

class ClientQrController extends GetxController {
  final EmvcoRepository _repository = EmvcoRepository();
  final AdService adService = Get.find<AdService>();
  final ClientQrSignatureService _signatureService = ClientQrSignatureService();
  final EmvcoPrivateKeyStorageService _keyStorageService =
      EmvcoPrivateKeyStorageService();

  final formKey = GlobalKey<FormState>();
  final liControllers = List.generate(100, (_) => TextEditingController());

  final languagePreference = TextEditingController();
  final merchantNameAl = TextEditingController();
  final merchantCityAl = TextEditingController();
  final billNumber = TextEditingController();
  final mobileNumber = TextEditingController();
  final storeLabel = TextEditingController();
  final loyalityNumber = TextEditingController();
  final referenceLabel = TextEditingController();
  final consumerLabel = TextEditingController();
  final terminalLabel = TextEditingController();
  final purposeOfTransaction = TextEditingController();
  final additionalConsumerRequest = TextEditingController();

  final tag26PaymentNetwork = ClientQrTag26PaymentNetworkState();
  final tag27PaymentNetwork = ClientQrAdditionalPaymentNetworkState();
  final tag80SignatureTemplate = ClientQrUnreservedSignatureTemplateState();
  final tag81SignatureTemplate = ClientQrUnreservedSignatureTemplateState();

  static const _additionalPaymentNetworkTags = {26, 27};
  static const _signatureTemplateTags = {80, 81};

  final initiationMethod = '11'.obs;
  final tipConvenienceIndicator = ''.obs;
  final showTransactionAmount = false.obs;
  final showFixedTip = false.obs;
  final showPercentTip = false.obs;
  final selectedClientField = RxnString();
  final selectedUnreserved = RxnString();

  final clientInformation = <Widget>[].obs;
  final unreserved = <Widget>[].obs;

  EMVCOSpecList get specList => _repository.specList;

  bool get isField80Selected =>
      unreserved.any((widget) => widget.key == const Key('80'));

  bool get isField81Selected =>
      unreserved.any((widget) => widget.key == const Key('81'));

  @override
  void onInit() {
    super.onInit();
    liControllers[0].text = '01';
    liControllers[1].text = initiationMethod.value;
    liControllers[52].text = '4829';
    _ensureMandatorySignatureTemplates();
  }

  void _ensureMandatorySignatureTemplates() {
    if (!isField80Selected) {
      addUnreservedField('80');
    }
    if (!isField81Selected) {
      addUnreservedField('81');
    }
  }

  @override
  void onClose() {
    for (final c in liControllers) {
      c.dispose();
    }
    languagePreference.dispose();
    merchantNameAl.dispose();
    merchantCityAl.dispose();
    billNumber.dispose();
    mobileNumber.dispose();
    storeLabel.dispose();
    loyalityNumber.dispose();
    referenceLabel.dispose();
    consumerLabel.dispose();
    terminalLabel.dispose();
    purposeOfTransaction.dispose();
    additionalConsumerRequest.dispose();
    tag26PaymentNetwork.dispose();
    tag27PaymentNetwork.dispose();
    tag80SignatureTemplate.dispose();
    tag81SignatureTemplate.dispose();
    super.onClose();
  }

  EMVSpec getSpec(int index) => _repository.getSpecByIndex(index, 'root');

  void setInitiationMethod(String? value) {
    initiationMethod.value = value ?? '';
    liControllers[1].text = value ?? '';
    showTransactionAmount.value = value == '12';
  }

  void setTipIndicator(String? value) {
    tipConvenienceIndicator.value = value ?? '';
    liControllers[55].text = value ?? '';
    showFixedTip.value = value == '02';
    showPercentTip.value = value == '03';
    if (value == null || value.isEmpty || value == '01') {
      showFixedTip.value = false;
      showPercentTip.value = false;
    }
  }

  void addClientField(String id) {
    final exists = clientInformation.any((w) => w.key == Key(id));
    if (exists) {
      _showDuplicateToast();
      return;
    }
    clientInformation.add(_buildClientRow(int.parse(id)));
  }

  void addUnreservedField(String id) {
    if (_signatureTemplateTags.contains(int.parse(id))) {
      final exists = unreserved.any((w) => w.key == Key(id));
      if (exists) {
        return;
      }
    } else {
      final exists = unreserved.any((w) => w.key == Key(id));
      if (exists) {
        _showDuplicateToast();
        return;
      }
    }
    unreserved.add(_buildUnreservedRow(int.parse(id)));
  }

  void _showDuplicateToast() {
    Fluttertoast.showToast(
      msg: 'Field Already Added!!Pllease enter values.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildClientRow(int indx) {
    final o = getSpec(indx);
    if (_additionalPaymentNetworkTags.contains(indx)) {
      return Row(
        key: Key(o.Id),
        children: [
          Expanded(
            child: ClientAdditionalPaymentNetworkFieldTile(
              controller: this,
              spec: o,
              tagIndex: indx,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeClientField(indx, o.Id),
          ),
        ],
      );
    }

    return Row(
      key: Key(o.Id),
      children: [
        Expanded(
          child: TextFormField(
            controller: liControllers[indx],
            cursorColor: AppColors.primary,
            maxLength: int.parse(o.Length),
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(labelText: '${o.Id}-${o.Name}'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeClientField(indx, o.Id),
        ),
      ],
    );
  }

  void _removeClientField(int indx, String id) {
    clientInformation.removeWhere((e) => e.key == Key(id));
    liControllers[indx].text = '';
    if (indx == 26) {
      tag26PaymentNetwork.clear();
    } else if (indx == 27) {
      tag27PaymentNetwork.clear();
    }
    clientInformation.refresh();
  }

  Widget _buildUnreservedRow(int indx) {
    final o = getSpec(indx);
    if (_signatureTemplateTags.contains(indx)) {
      return Row(
        key: Key(o.Id),
        children: [
          Expanded(
            child: ClientUnreservedSignatureTemplateFieldTile(
              controller: this,
              spec: o,
              tagIndex: indx,
              isRequired: true,
            ),
          ),
        ],
      );
    }

    return Row(
      key: Key(o.Id),
      children: [
        Expanded(
          child: TextFormField(
            controller: liControllers[indx],
            cursorColor: AppColors.primary,
            maxLength: int.parse(o.Length),
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(labelText: '${o.Id}-${o.Name}'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeUnreservedField(indx, o.Id),
        ),
      ],
    );
  }

  void _removeUnreservedField(int indx, String id) {
    if (_signatureTemplateTags.contains(indx)) {
      return;
    }
    unreserved.removeWhere((e) => e.key == Key(id));
    liControllers[indx].text = '';
    if (indx == 80) {
      tag80SignatureTemplate.clear();
    } else if (indx == 81) {
      tag81SignatureTemplate.clear();
    }
    unreserved.refresh();
  }

  String createQrString() {
    var qrString = '';
    for (var i = 0; i <= 99; i++) {
      if (liControllers[i].text.isNotEmpty) {
        qrString += getSpec(i).Id;
        qrString += liControllers[i].text.length.toString().padLeft(2, '0');
        qrString += liControllers[i].text;
      }
    }
    return '${qrString}6304';
  }

  String generateCrc(String qr) {
    final params =
        crcStandardParameters.StandardParams[crcAlgorithms.Crc16CcittFalse]!;
    final crc = CRC(Params: params).HashCore(utf8.encode(qr), qr.length);
    return _toHex(crc).padLeft(4, '0');
  }

  String _toHex(List<int> bytes) {
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).toUpperCase());
    }
    return sb.toString();
  }

  String? validateClientQrBeforeGeneration() {
    if (!tag80SignatureTemplate.isComplete ||
        liControllers[80].text.isEmpty) {
      return 'Required Signature Templates Missing\n\n'
          'Please generate the signature before creating the Client QR.\n\n'
          'Both:\n'
          '80 - Unreserved Template\n'
          '81 - Unreserved Template\n\n'
          'are required.';
    }

    if (!tag81SignatureTemplate.isComplete ||
        liControllers[81].text.isEmpty) {
      return 'Required Signature Templates Missing\n\n'
          'Please generate the signature before creating the Client QR.\n\n'
          'Both:\n'
          '80 - Unreserved Template\n'
          '81 - Unreserved Template\n\n'
          'are required.';
    }

    return null;
  }

  bool attemptGenerateClientQr() {
    final validationError = validateClientQrBeforeGeneration();
    if (validationError != null) {
      _showMessageToast(validationError);
      return false;
    }
    return true;
  }

  String buildFinalQr() {
    final qr = createQrString();
    return qr + generateCrc(qr);
  }

  void applyLanguageTemplate() {
    final pref = languagePreference.text.isNotEmpty
        ? '0002${languagePreference.text.toUpperCase()}'
        : '';
    final name = merchantNameAl.text.isNotEmpty
        ? '01${merchantNameAl.text.length.toString().padLeft(2, '0')}${merchantNameAl.text.toUpperCase()}'
        : '';
    final city = merchantCityAl.text.isNotEmpty
        ? '02${merchantCityAl.text.length.toString().padLeft(2, '0')}${merchantCityAl.text.toUpperCase()}'
        : '';
    liControllers[64].text = pref + name + city;
    Get.back();
  }

  void clearLanguageTemplate() {
    liControllers[64].text = '';
    languagePreference.clear();
    merchantNameAl.clear();
    merchantCityAl.clear();
    Get.back();
  }

  void applyAdditionalFields() {
    String tpl(String tag, String text) => text.isNotEmpty
        ? '$tag${text.length.toString().padLeft(2, '0')}${text.toUpperCase()}'
        : '';

    liControllers[62].text = tpl('01', billNumber.text) +
        tpl('02', mobileNumber.text) +
        tpl('03', storeLabel.text) +
        tpl('04', loyalityNumber.text) +
        tpl('05', referenceLabel.text) +
        tpl('06', consumerLabel.text) +
        tpl('07', terminalLabel.text) +
        tpl('08', purposeOfTransaction.text) +
        tpl('09', additionalConsumerRequest.text);
    Get.back();
  }

  void clearAdditionalFields() {
    liControllers[62].text = '';
    billNumber.clear();
    mobileNumber.clear();
    storeLabel.clear();
    loyalityNumber.clear();
    referenceLabel.clear();
    consumerLabel.clear();
    terminalLabel.clear();
    purposeOfTransaction.clear();
    additionalConsumerRequest.clear();
    Get.back();
  }

  void applyTag26AdditionalPaymentNetwork() {
    liControllers[26].text = tag26PaymentNetwork.buildEncodedValue();
    Get.back();
  }

  void clearTag26AdditionalPaymentNetwork() {
    liControllers[26].text = '';
    tag26PaymentNetwork.clear();
    Get.back();
  }

  void applyTag27AdditionalPaymentNetwork() {
    liControllers[27].text = tag27PaymentNetwork.buildEncodedValue();
    Get.back();
  }

  void clearTag27AdditionalPaymentNetwork() {
    liControllers[27].text = '';
    tag27PaymentNetwork.clear();
    Get.back();
  }

  void applyTag80UnreservedSignatureTemplate() {
    liControllers[80].text = tag80SignatureTemplate.buildEncodedValue();
    Get.back();
  }

  void clearTag80UnreservedSignatureTemplate() {
    liControllers[80].text = '';
    tag80SignatureTemplate.clear();
    Get.back();
  }

  void applyTag81UnreservedSignatureTemplate() {
    liControllers[81].text = tag81SignatureTemplate.buildEncodedValue();
    Get.back();
  }

  void clearTag81UnreservedSignatureTemplate() {
    liControllers[81].text = '';
    tag81SignatureTemplate.clear();
    Get.back();
  }

  void _applySignaturePartsToTemplates({
    required String part1,
    required String part2,
  }) {
    tag80SignatureTemplate.setSignaturePart(part1);
    tag81SignatureTemplate.setSignaturePart(part2);
    liControllers[80].text = tag80SignatureTemplate.buildEncodedValue();
    liControllers[81].text = tag81SignatureTemplate.buildEncodedValue();
  }

  Future<void> generateRecipientSignature(BuildContext context) async {
    final institutionTypeCode =
        tag26PaymentNetwork.selectedRecipientsInstitutionTypeCode;
    if (institutionTypeCode == null || institutionTypeCode.isEmpty) {
      _showMessageToast('Please select a Recipient Institution Type.');
      return;
    }

    final institutionIdCode =
        tag26PaymentNetwork.selectedRecipientsInstitutionIdCode;
    if (institutionIdCode == null || institutionIdCode.isEmpty) {
      _showMessageToast('Please select a Recipient Institution ID.');
      return;
    }

    final hasPrivateKey = await _keyStorageService.hasPrivateKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final hasPublicKey = await _keyStorageService.hasPublicKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );

    if (!hasPrivateKey || !hasPublicKey) {
      if (!context.mounted) return;
      final shouldOpenGenerateKeys = await showClientQrKeysRequiredDialog(context);
      if (shouldOpenGenerateKeys == true && context.mounted) {
        showGenerateKeysBottomSheet(context);
      }
      return;
    }

    final recipientName = liControllers[59].text.trim();
    if (recipientName.isEmpty) {
      _showMessageToast('Recipient Name is required.');
      return;
    }

    final recipientPan = tag26PaymentNetwork.recipientPan.text.trim();
    if (recipientPan.isEmpty) {
      _showMessageToast('Recipient PAN is required.');
      return;
    }

    if (!isField80Selected || !isField81Selected) {
      _showMessageToast(
        'Signature Templates Required\n\n'
        'Please select both:\n\n'
        '80 - Unreserved Template\n'
        '81 - Unreserved Template\n\n'
        'from the 80–99 Unreserved Templates dropdown before generating the signature.',
      );
      return;
    }

    try {
      final keyPair = await _keyStorageService.readKeyPair(
        institutionTypeCode: institutionTypeCode,
        institutionIdCode: institutionIdCode,
      );
      final signatureParts = await _signatureService.signPayloadWithKeyPair(
        recipientName: recipientName,
        recipientPan: recipientPan,
        keyPair: keyPair,
      );

      _applySignaturePartsToTemplates(
        part1: signatureParts.part1,
        part2: signatureParts.part2,
      );

      _showMessageToast(
        'Signature Generated\n\n'
        'The Ed25519 signature has been generated and stored in '
        'Unreserved Templates 80 and 81.',
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (_) {
      _showMessageToast('Failed to generate signature.');
    }
  }

  void _showMessageToast(
    String message, {
    Toast toastLength = Toast.LENGTH_LONG,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
