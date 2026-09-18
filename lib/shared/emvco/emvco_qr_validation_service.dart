import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../../features/client_qr/models/client_qr_unreserved_signature_template_state.dart';
import '../../features/client_qr/services/client_qr_signature_service.dart';
import '../../features/emvco_generator/services/emvco_private_key_storage_service.dart';
import '../../features/emvco_generator/utils/ed25519_spki_pem.dart';
import 'emvco_crc.dart';
import 'emvco_qr_validation_result.dart';
import 'emvco_tlv_parser.dart';

class EmvcoQrValidationService {
  EmvcoQrValidationService({
    ClientQrSignatureService? signatureService,
    EmvcoPrivateKeyStorageService? keyStorageService,
    Ed25519? ed25519,
  })  : _signatureService = signatureService ?? ClientQrSignatureService(),
        _keyStorageService = keyStorageService ?? EmvcoPrivateKeyStorageService(),
        _ed25519 = ed25519 ?? Ed25519();

  final ClientQrSignatureService _signatureService;
  final EmvcoPrivateKeyStorageService _keyStorageService;
  final Ed25519 _ed25519;

  Future<EmvcoQrValidationResult> validate(String qrText) async {
    Map<String, String> rootTags;
    try {
      rootTags = EmvcoTlvParser.parse(qrText);
    } catch (_) {
      return EmvcoQrValidationResult.notEmvco();
    }

    if (rootTags['00'] != '01') {
      return EmvcoQrValidationResult.notEmvco();
    }

    final crcParts = EmvcoTlvParser.extractCrcParts(qrText);
    if (crcParts == null) {
      return EmvcoQrValidationResult.invalid(
        crcValid: false,
        signaturePresent: false,
        failureReason: EmvcoQrValidationFailureReason.invalidCrc,
      );
    }

    final calculatedCrc = EmvcoCrc.calculate(crcParts.dataForCrc);
    final crcValid = calculatedCrc == crcParts.storedCrc.toUpperCase();
    if (!crcValid) {
      return EmvcoQrValidationResult.invalid(
        crcValid: false,
        signaturePresent: false,
        failureReason: EmvcoQrValidationFailureReason.invalidCrc,
      );
    }

    final hasTag80 = _hasNonEmptyTag(rootTags, '80');
    final hasTag81 = _hasNonEmptyTag(rootTags, '81');

    if (!hasTag80 && !hasTag81) {
      return EmvcoQrValidationResult.valid(
        signaturePresent: false,
        signatureValid: null,
      );
    }

    if (hasTag80 != hasTag81) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.missingSignaturePart,
      );
    }

    return _validateSignature(
      rootTags: rootTags,
    );
  }

  Future<EmvcoQrValidationResult> _validateSignature({
    required Map<String, String> rootTags,
  }) async {
    Map<String, String> tag80Nested;
    Map<String, String> tag81Nested;

    try {
      tag80Nested = EmvcoTlvParser.parse(rootTags['80']!);
      tag81Nested = EmvcoTlvParser.parse(rootTags['81']!);
    } catch (_) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.missingSignaturePart,
      );
    }

    const expectedGuuid =
        ClientQrUnreservedSignatureTemplateState.fixedGloballyUniqueIdentifier;
    if (tag80Nested['00'] != expectedGuuid ||
        tag81Nested['00'] != expectedGuuid) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.invalidSignatureGuuid,
      );
    }

    final part1 = tag80Nested['01'] ?? '';
    final part2 = tag81Nested['01'] ?? '';
    if (part1.length != 44 || part2.length != 44) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.invalidSignatureLength,
      );
    }

    final signatureBase64 = part1 + part2;
    if (signatureBase64.length != 88) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.invalidSignatureLength,
      );
    }

    List<int> signatureBytes;
    try {
      signatureBytes = base64Decode(signatureBase64);
    } catch (_) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.invalidSignatureBase64,
      );
    }

    if (signatureBytes.length != 64) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.invalidSignatureLength,
      );
    }

    final tag26Value = rootTags['26'];
    if (tag26Value == null || tag26Value.isEmpty) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.missingInstitutionData,
      );
    }

    Map<String, String> tag26Nested;
    try {
      tag26Nested = EmvcoTlvParser.parse(tag26Value);
    } catch (_) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.missingInstitutionData,
      );
    }

    final institutionTypeCode = tag26Nested['01'];
    final institutionIdCode = tag26Nested['02'];
    final recipientPan = tag26Nested['03'] ?? '';
    final recipientName = rootTags['59'] ?? '';

    if (institutionTypeCode == null ||
        institutionTypeCode.isEmpty ||
        institutionIdCode == null ||
        institutionIdCode.isEmpty) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.missingInstitutionData,
      );
    }

    if (recipientName.isEmpty || recipientPan.isEmpty) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.missingSignedPayloadData,
      );
    }

    final hasPublicKey = await _keyStorageService.hasPublicKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    if (!hasPublicKey) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.publicKeyNotFound,
      );
    }

    final storedPublicKey = await _keyStorageService.readStoredPublicKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );
    if (storedPublicKey == null) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.publicKeyNotFound,
      );
    }

    List<int> publicKeyBytes;
    try {
      publicKeyBytes = Ed25519SpkiPem.decodePublicKeyBytes(
        storedPublicKey.publicKeyPem,
      );
    } catch (_) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.publicKeyNotFound,
      );
    }

    final payload = _signatureService.buildSigningPayload(
      recipientName: recipientName,
      recipientPan: recipientPan,
    );
    final payloadBytes = utf8.encode(payload);
    final publicKey = SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);
    final signature = Signature(signatureBytes, publicKey: publicKey);
    final signatureValid = await _ed25519.verify(
      payloadBytes,
      signature: signature,
    );

    if (!signatureValid) {
      return EmvcoQrValidationResult.invalid(
        crcValid: true,
        signaturePresent: true,
        signatureValid: false,
        failureReason: EmvcoQrValidationFailureReason.invalidSignature,
      );
    }

    return EmvcoQrValidationResult.valid(
      signaturePresent: true,
      signatureValid: true,
    );
  }

  bool _hasNonEmptyTag(Map<String, String> tags, String tag) {
    final value = tags[tag];
    return value != null && value.isNotEmpty;
  }
}
