import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/services/ad_service.dart';
import '../../../shared/crc/crc.dart';
import '../../../shared/crc/crc_std_parameters.dart';
import '../../../shared/models/emvco_spec_list.dart';
import '../../../shared/models/emv_spec.dart';
import '../../../shared/repositories/emvco_repository.dart';
import '../models/merchant_qr_merchant_channel_state.dart';
import '../models/merchant_qr_tag26_payment_network_state.dart';
import '../widgets/merchant_form_widgets.dart';

class MerchantQrController extends GetxController {
  final EmvcoRepository _repository = EmvcoRepository();
  final AdService adService = Get.find<AdService>();

  final formKey = GlobalKey<FormState>();
  final liControllers =
      List.generate(100, (_) => TextEditingController());

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
  final merchantTaxId = TextEditingController();
  final merchantChannel = TextEditingController();

  final tag26PaymentNetwork = MerchantQrTag26PaymentNetworkState();
  final merchantChannelState = MerchantQrMerchantChannelState();

  final initiationMethod = '11'.obs;
  final tipConvenienceIndicator = ''.obs;
  final showTransactionAmount = false.obs;
  final showFixedTip = false.obs;
  final showPercentTip = false.obs;
  final selectedMerchant = RxnString();
  final selectedUnreserved = RxnString();

  final merchantInformation = <Widget>[].obs;
  final unreserved = <Widget>[].obs;

  EMVCOSpecList get specList => _repository.specList;

  @override
  void onInit() {
    super.onInit();
    liControllers[0].text = '01';
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
    merchantTaxId.dispose();
    merchantChannel.dispose();
    tag26PaymentNetwork.dispose();
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

  void addMerchantField(String id) {
    final exists = merchantInformation.any((w) => w.key == Key(id));
    if (exists) {
      _showDuplicateToast();
      return;
    }
    merchantInformation.add(_buildMerchantRow(int.parse(id)));
  }

  void addUnreservedField(String id) {
    final exists = unreserved.any((w) => w.key == Key(id));
    if (exists) {
      _showDuplicateToast();
      return;
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

  Widget _buildMerchantRow(int indx) {
    final o = getSpec(indx);
    if (indx == 26) {
      return Row(
        key: Key(o.Id),
        children: [
          Expanded(
            child: MerchantTag26AdditionalPaymentNetworkFieldTile(
              controller: this,
              spec: o,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeMerchantField(indx, o.Id),
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
          onPressed: () => _removeMerchantField(indx, o.Id),
        ),
      ],
    );
  }

  void _removeMerchantField(int indx, String id) {
    merchantInformation.removeWhere((e) => e.key == Key(id));
    liControllers[indx].text = '';
    if (indx == 26) {
      tag26PaymentNetwork.clear();
    }
    merchantInformation.refresh();
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

  Widget _buildUnreservedRow(int indx) {
    final o = getSpec(indx);
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
          onPressed: () {
            unreserved.removeWhere((e) => e.key == Key(o.Id));
            liControllers[indx].text = '';
            unreserved.refresh();
          },
        ),
      ],
    );
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
        tpl('09', additionalConsumerRequest.text) +
        tpl('10', merchantTaxId.text) +
        tpl('11', merchantChannel.text);
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
    merchantTaxId.clear();
    merchantChannel.clear();
    merchantChannelState.clear();
    Get.back();
  }

  void prepareMerchantChannelSheet() {
    final stored = merchantChannel.text.trim();
    if (stored.length == 3) {
      merchantChannelState.hydrateFromChannelValue(stored);
      return;
    }
    if (stored.isEmpty) {
      merchantChannelState.clear();
    }
  }

  String? applyMerchantChannel() {
    if (merchantChannelState.mediaCode == null ||
        merchantChannelState.mediaCode!.isEmpty) {
      return 'Please select Media.';
    }
    if (merchantChannelState.transactionLocationCode == null ||
        merchantChannelState.transactionLocationCode!.isEmpty) {
      return 'Please select Transaction Location.';
    }
    if (merchantChannelState.merchantPresenceCode == null ||
        merchantChannelState.merchantPresenceCode!.isEmpty) {
      return 'Please select Merchant Presence.';
    }

    final value = merchantChannelState.generatedValue;
    if (value == null || value.isEmpty) {
      return 'Please select Media.';
    }

    merchantChannel.text = value;
    Get.back();
    return null;
  }

  void clearMerchantChannel() {
    merchantChannelState.clear();
    merchantChannel.clear();
    Get.back();
  }
}
