import 'package:flutter/material.dart';

class ClientQrUnreservedSignatureTemplateState {
  static const fixedGloballyUniqueIdentifier = 'bb.org.bb.npsp';

  final TextEditingController globallyUniqueIdentifier = TextEditingController();
  final TextEditingController signaturePart = TextEditingController();

  ClientQrUnreservedSignatureTemplateState() {
    globallyUniqueIdentifier.text = fixedGloballyUniqueIdentifier;
  }

  void dispose() {
    globallyUniqueIdentifier.dispose();
    signaturePart.dispose();
  }

  void clear() {
    globallyUniqueIdentifier.text = fixedGloballyUniqueIdentifier;
    signaturePart.clear();
  }

  void setSignaturePart(String value) {
    signaturePart.text = value;
  }

  bool get isComplete =>
      globallyUniqueIdentifier.text == fixedGloballyUniqueIdentifier &&
      signaturePart.text.length == 44;

  String buildEncodedValue() {
    String tpl(String tag, String text, {bool preserveCase = false}) {
      if (text.isEmpty) return '';
      final value = preserveCase ? text : text.toUpperCase();
      return '$tag${text.length.toString().padLeft(2, '0')}$value';
    }

    return tpl('00', globallyUniqueIdentifier.text, preserveCase: true) +
        tpl('01', signaturePart.text, preserveCase: true);
  }
}
