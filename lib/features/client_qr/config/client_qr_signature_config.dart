import 'dart:convert';

/// Ed25519 signing seed for Client QR recipient signatures.
///
/// Supply at build/run time via:
/// `--dart-define=CLIENT_QR_ED25519_SEED_BASE64=<base64-of-32-byte-seed>`
///
/// Do not commit production private-key material to source control.
class ClientQrSignatureConfig {
  ClientQrSignatureConfig._();

  static const _seedBase64 = String.fromEnvironment('CLIENT_QR_ED25519_SEED_BASE64');

  static const seedLengthBytes = 32;

  static bool get isConfigured => _seedBase64.isNotEmpty;

  static List<int> get privateKeySeed {
    if (_seedBase64.isEmpty) {
      throw ClientQrSignatureKeyNotConfiguredException();
    }

    List<int> decoded;
    try {
      decoded = base64Decode(_seedBase64);
    } on FormatException {
      throw ClientQrSignatureConfigurationException(
        'CLIENT_QR_ED25519_SEED_BASE64 is not valid Base64.',
      );
    }

    if (decoded.length != seedLengthBytes) {
      throw ClientQrSignatureConfigurationException(
        'CLIENT_QR_ED25519_SEED_BASE64 must decode to exactly '
        '$seedLengthBytes bytes.',
      );
    }

    return decoded;
  }
}

class ClientQrSignatureKeyNotConfiguredException implements Exception {
  ClientQrSignatureKeyNotConfiguredException();

  final String message =
      'Ed25519 signing key is not configured. Set '
      'CLIENT_QR_ED25519_SEED_BASE64 to a Base64-encoded 32-byte seed.';
}

class ClientQrSignatureConfigurationException implements Exception {
  ClientQrSignatureConfigurationException(this.message);

  final String message;
}
