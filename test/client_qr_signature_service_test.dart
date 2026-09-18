import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myqr_getx/features/client_qr/services/client_qr_signature_service.dart';

void main() {
  group('ClientQrSignatureService', () {
    test('buildSigningPayload removes spaces and concatenates directly', () {
      final service = ClientQrSignatureService();

      expect(
        service.buildSigningPayload(
          recipientName: 'JOHN DOE',
          recipientPan: '1234567890123456',
        ),
        'JOHNDOE1234567890123456',
      );
    });

    test('signPayloadWithKeyPair produces 64-byte signature and 88-char Base64', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final service = ClientQrSignatureService(ed25519: ed25519);

      final parts = await service.signPayloadWithKeyPair(
        recipientName: 'ALICE SMITH',
        recipientPan: '9876543210123456',
        keyPair: keyPair,
      );

      expect(base64Decode(parts.signatureBase64).length, 64);
      expect(parts.signatureBase64.length, 88);
      expect(parts.part1.length, 44);
      expect(parts.part2.length, 44);
      expect('${parts.part1}${parts.part2}', parts.signatureBase64);
    });

    test('splitSignatureBase64 splits 88 characters into two 44-character parts', () {
      final service = ClientQrSignatureService();
      const signatureBase64 =
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqr'
          'stuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWX==';

      final parts = service.splitSignatureBase64(signatureBase64);

      expect(parts.part1, signatureBase64.substring(0, 44));
      expect(parts.part2, signatureBase64.substring(44, 88));
    });
  });
}
