import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myqr_getx/features/client_qr/models/client_qr_unreserved_signature_template_state.dart';
import 'package:myqr_getx/features/client_qr/services/client_qr_signature_service.dart';
import 'package:myqr_getx/shared/emvco/emvco_crc.dart';
import 'package:myqr_getx/shared/emvco/emvco_qr_validation_result.dart';
import 'package:myqr_getx/shared/emvco/emvco_qr_validation_service.dart';
import 'package:myqr_getx/shared/emvco/emvco_tlv_parser.dart';

String _buildNestedTlv(Map<String, String> subtags) {
  final buffer = StringBuffer();
  subtags.forEach((tag, value) {
    buffer
      ..write(tag.padLeft(2, '0'))
      ..write(value.length.toString().padLeft(2, '0'))
      ..write(value);
  });
  return buffer.toString();
}

String _buildQr({
  required Map<String, String> rootTags,
}) {
  final body = StringBuffer()..write('000201');
  rootTags.forEach((tag, value) {
    body
      ..write(tag.padLeft(2, '0'))
      ..write(value.length.toString().padLeft(2, '0'))
      ..write(value);
  });

  final withoutCrcValue = '${body}6304';
  final crc = EmvcoCrc.calculate(withoutCrcValue);
  return '$withoutCrcValue$crc';
}

void main() {
  group('EmvcoTlvParser', () {
    test('extractCrcParts returns data ending with 6304', () {
      const qr = '0002010102116304ABCD';
      final parts = EmvcoTlvParser.extractCrcParts(qr);

      expect(parts, isNotNull);
      expect(parts!.dataForCrc.endsWith('6304'), isTrue);
      expect(parts.storedCrc, 'ABCD');
    });
  });

  group('EmvcoQrValidationService', () {
    test('valid CRC without signature tags is valid', () async {
      final service = EmvcoQrValidationService();
      final qr = _buildQr(rootTags: {'01': '11'});

      final result = await service.validate(qr);

      expect(result.isEmvco, isTrue);
      expect(result.isValid, isTrue);
      expect(result.crcValid, isTrue);
      expect(result.signaturePresent, isFalse);
    });

    test('invalid CRC is invalid', () async {
      final service = EmvcoQrValidationService();
      final qr = _buildQr(rootTags: {'01': '11'});
      final invalidQr = '${qr.substring(0, qr.length - 4)}FFFF';

      final result = await service.validate(invalidQr);

      expect(result.isValid, isFalse);
      expect(result.failureReason, EmvcoQrValidationFailureReason.invalidCrc);
      expect(result.displayStatus, EmvcoValidationStatus.invalidCrc);
    });

    test('invalid CRC takes priority over invalid signature', () async {
      final service = EmvcoQrValidationService();
      final tag80 = _buildNestedTlv({
        '00': ClientQrUnreservedSignatureTemplateState.fixedGloballyUniqueIdentifier,
        '01': 'A' * 44,
      });
      final qr = _buildQr(rootTags: {
        '01': '11',
        '80': tag80,
      });
      final invalidQr = '${qr.substring(0, qr.length - 4)}FFFF';

      final result = await service.validate(invalidQr);

      expect(result.isValid, isFalse);
      expect(result.crcValid, isFalse);
      expect(result.displayStatus, EmvcoValidationStatus.invalidCrc);
    });

    test('valid CRC without signature tags shows valid status', () async {
      final service = EmvcoQrValidationService();
      final qr = _buildQr(rootTags: {'01': '11'});

      final result = await service.validate(qr);

      expect(result.displayStatus, EmvcoValidationStatus.valid);
    });

    test('only tag 80 present is invalid', () async {
      final service = EmvcoQrValidationService();
      final tag80 = _buildNestedTlv({
        '00': ClientQrUnreservedSignatureTemplateState.fixedGloballyUniqueIdentifier,
        '01': 'A' * 44,
      });
      final qr = _buildQr(rootTags: {
        '01': '11',
        '80': tag80,
      });

      final result = await service.validate(qr);

      expect(result.isValid, isFalse);
      expect(
        result.failureReason,
        EmvcoQrValidationFailureReason.missingSignaturePart,
      );
      expect(result.displayStatus, EmvcoValidationStatus.invalidSignature);
    });

    test('invalid base64 signature length is invalid', () async {
      final service = EmvcoQrValidationService();
      final tag80 = _buildNestedTlv({
        '00': ClientQrUnreservedSignatureTemplateState.fixedGloballyUniqueIdentifier,
        '01': 'A' * 44,
      });
      final tag81 = _buildNestedTlv({
        '00': ClientQrUnreservedSignatureTemplateState.fixedGloballyUniqueIdentifier,
        '01': 'B' * 43,
      });
      final qr = _buildQr(rootTags: {
        '01': '11',
        '80': tag80,
        '81': tag81,
      });

      final result = await service.validate(qr);

      expect(result.isValid, isFalse);
      expect(
        result.failureReason,
        EmvcoQrValidationFailureReason.invalidSignatureLength,
      );
      expect(result.displayStatus, EmvcoValidationStatus.invalidSignature);
    });

    test('split signature reconstructs 88-character base64', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final service = ClientQrSignatureService(ed25519: ed25519);
      final parts = await service.signPayloadWithKeyPair(
        recipientName: 'JOHN DOE',
        recipientPan: '1234567890123456',
        keyPair: keyPair,
      );

      expect(parts.part1.length, 44);
      expect(parts.part2.length, 44);
      expect('${parts.part1}${parts.part2}', parts.signatureBase64);
      expect(base64Decode(parts.signatureBase64).length, 64);
    });
  });
}
