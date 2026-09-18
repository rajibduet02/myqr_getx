enum EmvcoValidationStatus {
  valid,
  invalidCrc,
  invalidSignature,
}

class EmvcoQrValidationFailureReason {
  EmvcoQrValidationFailureReason._();

  static const invalidCrc = 'INVALID_CRC';
  static const missingSignaturePart = 'MISSING_SIGNATURE_PART';
  static const invalidSignatureLength = 'INVALID_SIGNATURE_LENGTH';
  static const invalidSignatureBase64 = 'INVALID_SIGNATURE_BASE64';
  static const invalidSignatureGuuid = 'INVALID_SIGNATURE_GUUID';
  static const missingInstitutionData = 'MISSING_INSTITUTION_DATA';
  static const publicKeyNotFound = 'PUBLIC_KEY_NOT_FOUND';
  static const invalidSignature = 'INVALID_SIGNATURE';
  static const missingSignedPayloadData = 'MISSING_SIGNED_PAYLOAD_DATA';
}

class EmvcoQrValidationResult {
  const EmvcoQrValidationResult({
    required this.isEmvco,
    required this.isValid,
    required this.crcValid,
    required this.signaturePresent,
    this.signatureValid,
    this.failureReason,
  });

  final bool isEmvco;
  final bool isValid;
  final bool crcValid;
  final bool signaturePresent;
  final bool? signatureValid;
  final String? failureReason;

  EmvcoValidationStatus? get displayStatus {
    if (!isEmvco) {
      return null;
    }
    if (isValid) {
      return EmvcoValidationStatus.valid;
    }
    if (!crcValid) {
      return EmvcoValidationStatus.invalidCrc;
    }
    return EmvcoValidationStatus.invalidSignature;
  }

  factory EmvcoQrValidationResult.notEmvco() {
    return const EmvcoQrValidationResult(
      isEmvco: false,
      isValid: false,
      crcValid: false,
      signaturePresent: false,
    );
  }

  factory EmvcoQrValidationResult.invalid({
    required bool crcValid,
    required bool signaturePresent,
    bool? signatureValid,
    required String failureReason,
  }) {
    return EmvcoQrValidationResult(
      isEmvco: true,
      isValid: false,
      crcValid: crcValid,
      signaturePresent: signaturePresent,
      signatureValid: signatureValid,
      failureReason: failureReason,
    );
  }

  factory EmvcoQrValidationResult.valid({
    required bool signaturePresent,
    bool? signatureValid,
  }) {
    return EmvcoQrValidationResult(
      isEmvco: true,
      isValid: true,
      crcValid: true,
      signaturePresent: signaturePresent,
      signatureValid: signatureValid,
    );
  }
}
