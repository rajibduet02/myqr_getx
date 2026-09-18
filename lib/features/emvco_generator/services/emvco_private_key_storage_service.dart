import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/ed25519_pkcs8_pem.dart';
import '../utils/ed25519_spki_pem.dart';

class EmvcoPrivateKeyAlreadyExistsException implements Exception {
  EmvcoPrivateKeyAlreadyExistsException(this.keyId);

  final String keyId;

  @override
  String toString() => 'A private key already exists for key ID $keyId.';
}

class EmvcoPrivateKeyGenerationResult {
  const EmvcoPrivateKeyGenerationResult({
    required this.keyId,
    required this.logicalFilename,
  });

  final String keyId;
  final String logicalFilename;
}

class EmvcoPublicKeyAlreadyExistsException implements Exception {
  EmvcoPublicKeyAlreadyExistsException(this.keyId);

  final String keyId;

  @override
  String toString() => 'A public key already exists for key ID $keyId.';
}

class EmvcoPrivateKeyNotFoundException implements Exception {
  EmvcoPrivateKeyNotFoundException(this.keyId);

  final String keyId;

  @override
  String toString() => 'No private key exists for key ID $keyId.';
}

class EmvcoPublicKeyGenerationResult {
  const EmvcoPublicKeyGenerationResult({
    required this.keyId,
    required this.logicalFilename,
  });

  final String keyId;
  final String logicalFilename;
}

class EmvcoStoredPrivateKeyRecord {
  const EmvcoStoredPrivateKeyRecord({
    required this.keyId,
    required this.logicalFilename,
    required this.privateKeyPem,
    required this.institutionTypeCode,
    required this.institutionIdCode,
  });

  final String keyId;
  final String logicalFilename;
  final String privateKeyPem;
  final String institutionTypeCode;
  final String institutionIdCode;

  Map<String, String> toJson() => {
        'keyId': keyId,
        'logicalFilename': logicalFilename,
        'privateKeyPem': privateKeyPem,
        'institutionTypeCode': institutionTypeCode,
        'institutionIdCode': institutionIdCode,
      };

  factory EmvcoStoredPrivateKeyRecord.fromJson(Map<String, dynamic> json) {
    return EmvcoStoredPrivateKeyRecord(
      keyId: json['keyId'] as String,
      logicalFilename: json['logicalFilename'] as String,
      privateKeyPem: json['privateKeyPem'] as String,
      institutionTypeCode: json['institutionTypeCode'] as String,
      institutionIdCode: json['institutionIdCode'] as String,
    );
  }
}

class EmvcoStoredPublicKeyRecord {
  const EmvcoStoredPublicKeyRecord({
    required this.keyId,
    required this.logicalFilename,
    required this.publicKeyPem,
    required this.institutionTypeCode,
    required this.institutionIdCode,
    required this.privateKeyAlias,
    required this.publicKeyAlias,
    this.algorithm = 'Ed25519',
  });

  final String keyId;
  final String logicalFilename;
  final String publicKeyPem;
  final String institutionTypeCode;
  final String institutionIdCode;
  final String privateKeyAlias;
  final String publicKeyAlias;
  final String algorithm;

  Map<String, String> toJson() => {
        'keyId': keyId,
        'logicalFilename': logicalFilename,
        'publicKeyPem': publicKeyPem,
        'institutionTypeCode': institutionTypeCode,
        'institutionIdCode': institutionIdCode,
        'privateKeyAlias': privateKeyAlias,
        'publicKeyAlias': publicKeyAlias,
        'algorithm': algorithm,
      };

  factory EmvcoStoredPublicKeyRecord.fromJson(Map<String, dynamic> json) {
    return EmvcoStoredPublicKeyRecord(
      keyId: json['keyId'] as String,
      logicalFilename: json['logicalFilename'] as String,
      publicKeyPem: json['publicKeyPem'] as String,
      institutionTypeCode: json['institutionTypeCode'] as String,
      institutionIdCode: json['institutionIdCode'] as String,
      privateKeyAlias: json['privateKeyAlias'] as String,
      publicKeyAlias: json['publicKeyAlias'] as String,
      algorithm: json['algorithm'] as String? ?? 'Ed25519',
    );
  }
}

class EmvcoPrivateKeyStorageService {
  EmvcoPrivateKeyStorageService({
    Ed25519? ed25519,
    FlutterSecureStorage? secureStorage,
  })  : _ed25519 = ed25519 ?? Ed25519(),
        _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  final Ed25519 _ed25519;
  final FlutterSecureStorage _secureStorage;

  static String buildKeyId({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) {
    return institutionTypeCode + institutionIdCode;
  }

  static String buildStorageKey(String keyId) => 'ed25519_private_$keyId';

  static String buildLogicalFilename(String keyId) => '$keyId-private.pem';

  static String buildPublicStorageKey(String keyId) => 'ed25519_public_$keyId';

  static String buildPublicLogicalFilename(String keyId) => '$keyId-public.pem';

  Future<bool> hasPrivateKey({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final keyId = buildKeyId(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final storedValue = await _secureStorage.read(key: buildStorageKey(keyId));
    return storedValue != null && storedValue.isNotEmpty;
  }

  Future<bool> hasPublicKey({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final keyId = buildKeyId(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final storedValue = await _secureStorage.read(key: buildPublicStorageKey(keyId));
    return storedValue != null && storedValue.isNotEmpty;
  }

  Future<EmvcoPrivateKeyGenerationResult> generateAndStorePrivateKey({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final keyId = buildKeyId(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final storageKey = buildStorageKey(keyId);
    final logicalFilename = buildLogicalFilename(keyId);

    if (await hasPrivateKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    )) {
      throw EmvcoPrivateKeyAlreadyExistsException(keyId);
    }

    final keyPair = await _ed25519.newKeyPair();
    final seedBytes = await keyPair.extractPrivateKeyBytes();
    final privateKeyPem = Ed25519Pkcs8Pem.encode(seedBytes);

    final record = EmvcoStoredPrivateKeyRecord(
      keyId: keyId,
      logicalFilename: logicalFilename,
      privateKeyPem: privateKeyPem,
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );

    await _secureStorage.write(
      key: storageKey,
      value: jsonEncode(record.toJson()),
    );

    return EmvcoPrivateKeyGenerationResult(
      keyId: keyId,
      logicalFilename: logicalFilename,
    );
  }

  Future<EmvcoStoredPrivateKeyRecord?> readStoredPrivateKey({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final keyId = buildKeyId(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final storedValue = await _secureStorage.read(key: buildStorageKey(keyId));
    if (storedValue == null || storedValue.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(storedValue) as Map<String, dynamic>;
    return EmvcoStoredPrivateKeyRecord.fromJson(decoded);
  }

  Future<SimpleKeyPair> readKeyPair({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final record = await readStoredPrivateKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    if (record == null) {
      throw StateError('No stored private key for the selected institution.');
    }

    final seedBytes = Ed25519Pkcs8Pem.decodeSeed(record.privateKeyPem);
    return _ed25519.newKeyPairFromSeed(seedBytes);
  }

  Future<EmvcoPublicKeyGenerationResult> deriveAndStorePublicKey({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final keyId = buildKeyId(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );

    if (!await hasPrivateKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    )) {
      throw EmvcoPrivateKeyNotFoundException(keyId);
    }

    if (await hasPublicKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    )) {
      throw EmvcoPublicKeyAlreadyExistsException(keyId);
    }

    final keyPair = await readKeyPair(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final publicKey = await keyPair.extractPublicKey();
    final publicKeyPem = Ed25519SpkiPem.encode(publicKey.bytes);
    final privateKeyAlias = buildStorageKey(keyId);
    final publicKeyAlias = buildPublicStorageKey(keyId);
    final logicalFilename = buildPublicLogicalFilename(keyId);

    final record = EmvcoStoredPublicKeyRecord(
      keyId: keyId,
      logicalFilename: logicalFilename,
      publicKeyPem: publicKeyPem,
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
      privateKeyAlias: privateKeyAlias,
      publicKeyAlias: publicKeyAlias,
    );

    await _secureStorage.write(
      key: publicKeyAlias,
      value: jsonEncode(record.toJson()),
    );

    return EmvcoPublicKeyGenerationResult(
      keyId: keyId,
      logicalFilename: logicalFilename,
    );
  }

  Future<EmvcoStoredPublicKeyRecord?> readStoredPublicKey({
    required String institutionTypeCode,
    required String institutionIdCode,
  }) async {
    final keyId = buildKeyId(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    final storedValue = await _secureStorage.read(key: buildPublicStorageKey(keyId));
    if (storedValue == null || storedValue.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(storedValue) as Map<String, dynamic>;
    return EmvcoStoredPublicKeyRecord.fromJson(decoded);
  }
}
