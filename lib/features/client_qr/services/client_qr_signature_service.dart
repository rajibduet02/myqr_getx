import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class ClientQrSignatureParts {
  const ClientQrSignatureParts({
    required this.signatureBase64,
    required this.part1,
    required this.part2,
  });

  final String signatureBase64;
  final String part1;
  final String part2;
}

class ClientQrSignatureService {
  ClientQrSignatureService({Ed25519? ed25519}) : _ed25519 = ed25519 ?? Ed25519();

  final Ed25519 _ed25519;

  String buildSigningPayload({
    required String recipientName,
    required String recipientPan,
  }) {
    final normalizedName = recipientName.replaceAll(RegExp(r'\s+'), '');
    final normalizedPan = recipientPan.replaceAll(RegExp(r'\s+'), '');
    return '$normalizedName$normalizedPan';
  }

  Future<ClientQrSignatureParts> signPayloadWithKeyPair({
    required String recipientName,
    required String recipientPan,
    required SimpleKeyPair keyPair,
  }) async {
    final signingText = buildSigningPayload(
      recipientName: recipientName,
      recipientPan: recipientPan,
    );
    final messageBytes = utf8.encode(signingText);
    final signature = await _ed25519.sign(
      messageBytes,
      keyPair: keyPair,
    );

    final signatureBytes = signature.bytes;
    if (signatureBytes.length != 64) {
      throw StateError(
        'Expected a 64-byte Ed25519 signature, got ${signatureBytes.length}.',
      );
    }

    final signatureBase64 = base64Encode(signatureBytes);
    if (signatureBase64.length != 88) {
      throw StateError(
        'Expected an 88-character Base64 signature, got ${signatureBase64.length}.',
      );
    }

    return splitSignatureBase64(signatureBase64);
  }

  ClientQrSignatureParts splitSignatureBase64(String signatureBase64) {
    if (signatureBase64.length != 88) {
      throw StateError(
        'Expected an 88-character Base64 signature, got ${signatureBase64.length}.',
      );
    }

    final part1 = signatureBase64.substring(0, 44);
    final part2 = signatureBase64.substring(44, 88);
    if (part1.length != 44 || part2.length != 44) {
      throw StateError('Expected two 44-character signature parts.');
    }

    return ClientQrSignatureParts(
      signatureBase64: signatureBase64,
      part1: part1,
      part2: part2,
    );
  }
}
