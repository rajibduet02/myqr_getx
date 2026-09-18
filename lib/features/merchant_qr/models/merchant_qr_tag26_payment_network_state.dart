import 'package:flutter/material.dart';

class MerchantQrTag26PaymentNetworkState {
  static const fixedGloballyUniqueIdentifier = 'bd.org.bb.npsb';

  final TextEditingController globallyUniqueIdentifier = TextEditingController();
  final TextEditingController recipientsInstitutionType = TextEditingController();
  final TextEditingController recipientsInstitutionId = TextEditingController();
  final TextEditingController recipientPan = TextEditingController();

  MerchantQrTag26PaymentNetworkState() {
    globallyUniqueIdentifier.text = fixedGloballyUniqueIdentifier;
  }

  String? get selectedRecipientsInstitutionTypeCode =>
      recipientsInstitutionType.text.isEmpty ? null : recipientsInstitutionType.text;

  set selectedRecipientsInstitutionTypeCode(String? code) {
    recipientsInstitutionType.text = code ?? '';
  }

  String? get selectedRecipientsInstitutionIdCode =>
      recipientsInstitutionId.text.isEmpty ? null : recipientsInstitutionId.text;

  set selectedRecipientsInstitutionIdCode(String? code) {
    recipientsInstitutionId.text = code ?? '';
  }

  void dispose() {
    globallyUniqueIdentifier.dispose();
    recipientsInstitutionType.dispose();
    recipientsInstitutionId.dispose();
    recipientPan.dispose();
  }

  void clear() {
    globallyUniqueIdentifier.text = fixedGloballyUniqueIdentifier;
    recipientsInstitutionType.clear();
    recipientsInstitutionId.clear();
    recipientPan.clear();
  }

  String buildEncodedValue() {
    String tpl(String tag, String text, {bool preserveCase = false}) {
      if (text.isEmpty) return '';
      final value = preserveCase ? text : text.toUpperCase();
      return '$tag${text.length.toString().padLeft(2, '0')}$value';
    }

    return tpl('00', globallyUniqueIdentifier.text, preserveCase: true) +
        tpl('01', recipientsInstitutionType.text) +
        tpl('02', recipientsInstitutionId.text) +
        tpl('03', recipientPan.text);
  }
}
