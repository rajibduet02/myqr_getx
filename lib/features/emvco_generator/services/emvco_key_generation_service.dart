import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class EmvcoKeyGenerationService {
  EmvcoKeyGenerationService({Ed25519? ed25519}) : _ed25519 = ed25519 ?? Ed25519();

  final Ed25519 _ed25519;
  SimpleKeyPair? _cachedKeyPair;

  Future<SimpleKeyPair> _getOrCreateKeyPair() async {
    _cachedKeyPair ??= await _ed25519.newKeyPair();
    return _cachedKeyPair!;
  }

  Future<String> generatePrivateKeyBase64() async {
    final keyPair = await _getOrCreateKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    return base64Encode(privateKeyBytes);
  }

  Future<String> generatePublicKeyBase64() async {
    final keyPair = await _getOrCreateKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    return base64Encode(publicKey.bytes);
  }
}
