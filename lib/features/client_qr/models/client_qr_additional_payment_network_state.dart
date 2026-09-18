import 'package:flutter/material.dart';

class ClientQrAdditionalPaymentNetworkState {
  final TextEditingController billNumber = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController storeLabel = TextEditingController();
  final TextEditingController loyalityNumber = TextEditingController();
  final TextEditingController referenceLabel = TextEditingController();
  final TextEditingController consumerLabel = TextEditingController();
  final TextEditingController terminalLabel = TextEditingController();
  final TextEditingController purposeOfTransaction = TextEditingController();
  final TextEditingController additionalConsumerRequest = TextEditingController();

  void dispose() {
    billNumber.dispose();
    mobileNumber.dispose();
    storeLabel.dispose();
    loyalityNumber.dispose();
    referenceLabel.dispose();
    consumerLabel.dispose();
    terminalLabel.dispose();
    purposeOfTransaction.dispose();
    additionalConsumerRequest.dispose();
  }

  void clear() {
    billNumber.clear();
    mobileNumber.clear();
    storeLabel.clear();
    loyalityNumber.clear();
    referenceLabel.clear();
    consumerLabel.clear();
    terminalLabel.clear();
    purposeOfTransaction.clear();
    additionalConsumerRequest.clear();
  }

  String buildEncodedValue() {
    String tpl(String tag, String text) => text.isNotEmpty
        ? '$tag${text.length.toString().padLeft(2, '0')}${text.toUpperCase()}'
        : '';

    return tpl('01', billNumber.text) +
        tpl('02', mobileNumber.text) +
        tpl('03', storeLabel.text) +
        tpl('04', loyalityNumber.text) +
        tpl('05', referenceLabel.text) +
        tpl('06', consumerLabel.text) +
        tpl('07', terminalLabel.text) +
        tpl('08', purposeOfTransaction.text) +
        tpl('09', additionalConsumerRequest.text);
  }
}
