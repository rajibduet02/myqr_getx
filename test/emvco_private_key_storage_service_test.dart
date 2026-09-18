import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myqr_getx/features/emvco_generator/services/emvco_private_key_storage_service.dart';
import 'package:myqr_getx/features/emvco_generator/utils/ed25519_pkcs8_pem.dart';
import 'package:myqr_getx/features/emvco_generator/utils/ed25519_spki_pem.dart';

void main() {
  group('EmvcoPrivateKeyStorageService identifiers', () {
    test('buildKeyId concatenates institution codes without separators', () {
      expect(
        EmvcoPrivateKeyStorageService.buildKeyId(
          institutionTypeCode: '00',
          institutionIdCode: '0060',
        ),
        '000060',
      );
    });

    test('buildStorageKey and logical filename follow requested format', () {
      const keyId = '000060';

      expect(
        EmvcoPrivateKeyStorageService.buildStorageKey(keyId),
        'ed25519_private_000060',
      );
      expect(
        EmvcoPrivateKeyStorageService.buildLogicalFilename(keyId),
        '000060-private.pem',
      );
      expect(
        EmvcoPrivateKeyStorageService.buildPublicStorageKey(keyId),
        'ed25519_public_000060',
      );
      expect(
        EmvcoPrivateKeyStorageService.buildPublicLogicalFilename(keyId),
        '000060-public.pem',
      );
    });
  });

  group('Ed25519SpkiPem', () {
    test('encodes SPKI PEM with standard headers', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final publicKey = await keyPair.extractPublicKey();

      final pem = Ed25519SpkiPem.encode(publicKey.bytes);

      expect(pem.startsWith('${Ed25519SpkiPem.pemHeader}\n'), isTrue);
      expect(pem.endsWith('\n${Ed25519SpkiPem.pemFooter}'), isTrue);
    });

    test('public key PEM corresponds to the same key pair as private key seed', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final seedBytes = await keyPair.extractPrivateKeyBytes();
      final originalPublicKey = await keyPair.extractPublicKey();

      final privatePem = Ed25519Pkcs8Pem.encode(seedBytes);
      final restoredKeyPair = await ed25519.newKeyPairFromSeed(
        Ed25519Pkcs8Pem.decodeSeed(privatePem),
      );
      final derivedPublicKey = await restoredKeyPair.extractPublicKey();
      final publicPem = Ed25519SpkiPem.encode(derivedPublicKey.bytes);

      expect(publicPem.contains('BEGIN PUBLIC KEY'), isTrue);
      expect(derivedPublicKey.bytes, originalPublicKey.bytes);
    });
  });

  group('Ed25519Pkcs8Pem', () {
    test('encodes PKCS#8 PEM with standard headers', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final seedBytes = await keyPair.extractPrivateKeyBytes();

      final pem = Ed25519Pkcs8Pem.encode(seedBytes);

      expect(pem.startsWith('${Ed25519Pkcs8Pem.pemHeader}\n'), isTrue);
      expect(pem.endsWith('\n${Ed25519Pkcs8Pem.pemFooter}'), isTrue);
    });

    test('PKCS#8 DER payload is 48 bytes for Ed25519', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final seedBytes = await keyPair.extractPrivateKeyBytes();
      final pem = Ed25519Pkcs8Pem.encode(seedBytes);

      final base64Body = pem
          .split('\n')
          .where((line) => !line.startsWith('-----'))
          .join();
      final derBytes = base64Decode(base64Body);

      expect(derBytes.length, 48);
      expect(derBytes.first, 0x30);
    });

    test('decodeSeed restores the same Ed25519 public key', () async {
      final ed25519 = Ed25519();
      final keyPair = await ed25519.newKeyPair();
      final seedBytes = await keyPair.extractPrivateKeyBytes();
      final pem = Ed25519Pkcs8Pem.encode(seedBytes);

      final decodedSeed = Ed25519Pkcs8Pem.decodeSeed(pem);
      final restoredKeyPair = await ed25519.newKeyPairFromSeed(decodedSeed);

      expect(decodedSeed, seedBytes);
      expect(
        (await restoredKeyPair.extractPublicKey()).bytes,
        (await keyPair.extractPublicKey()).bytes,
      );
    });
  });
}
