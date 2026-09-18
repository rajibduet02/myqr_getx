import 'emvco_crc.dart';
import 'emvco_tlv_parser.dart';

class EmvcoCrcGenerationOutput {
  const EmvcoCrcGenerationOutput({
    required this.dataForCrc,
    required this.crc,
    required this.completePayload,
  });

  final String dataForCrc;
  final String crc;
  final String completePayload;
}

class EmvcoCrcGenerator {
  EmvcoCrcGenerator._();

  static const emptyInputMessage = 'Please paste an EMVCo payload first.';
  static const missingCrcTagMessage =
      'Payload must end with CRC Tag and Length: 6304';
  static const existingCrcMessage =
      'The payload already contains a CRC value.\nPlease paste the payload ending with 6304 only.';
  static const malformedCrcMessage =
      'The payload has a malformed CRC ending.\nPlease paste the payload ending with 6304 only.';
  static const invalidStructureMessage =
      'The pasted payload does not appear to be a valid EMVCo TLV string.';

  static String normalizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), '');
  }

  static ({EmvcoCrcGenerationOutput? output, String? errorMessage}) generate(
    String rawInput,
  ) {
    final normalized = normalizeInput(rawInput);
    if (normalized.isEmpty) {
      return (output: null, errorMessage: emptyInputMessage);
    }

    try {
      return _generateNormalized(normalized);
    } on FormatException {
      return (output: null, errorMessage: invalidStructureMessage);
    }
  }

  static ({EmvcoCrcGenerationOutput? output, String? errorMessage})
      _generateNormalized(String normalized) {
    if (_hasCompleteCrcSuffix(normalized)) {
      return (output: null, errorMessage: existingCrcMessage);
    }

    if (_hasPartialCrcSuffix(normalized)) {
      return (output: null, errorMessage: malformedCrcMessage);
    }

    if (!normalized.endsWith('6304')) {
      return (output: null, errorMessage: missingCrcTagMessage);
    }

    final dataForCrc = normalized;

    if (!_isStructurallyValid(dataForCrc)) {
      return (output: null, errorMessage: invalidStructureMessage);
    }

    final crc = EmvcoCrc.calculate(dataForCrc);
    return (
      output: EmvcoCrcGenerationOutput(
        dataForCrc: dataForCrc,
        crc: crc,
        completePayload: dataForCrc + crc,
      ),
      errorMessage: null,
    );
  }

  static bool _hasCompleteCrcSuffix(String value) {
    final existingCrc = EmvcoTlvParser.extractCrcParts(value);
    if (existingCrc == null) {
      return false;
    }

    return value == existingCrc.dataForCrc + existingCrc.storedCrc;
  }

  static bool _hasPartialCrcSuffix(String value) {
    return RegExp(r'6304[0-9A-Fa-f]{1,3}$').hasMatch(value);
  }

  static bool _isStructurallyValid(String dataForCrc) {
    try {
      EmvcoTlvParser.parse('$dataForCrc${'0' * 4}');
      return true;
    } catch (_) {
      return false;
    }
  }
}
