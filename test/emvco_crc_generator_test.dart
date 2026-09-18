import 'package:flutter_test/flutter_test.dart';
import 'package:myqr_getx/shared/emvco/emvco_crc.dart';
import 'package:myqr_getx/shared/emvco/emvco_crc_generator.dart';

String _buildPayloadEndingWith6304({
  required Map<String, String> rootTags,
}) {
  final body = StringBuffer()..write('000201');
  rootTags.forEach((tag, value) {
    body
      ..write(tag.padLeft(2, '0'))
      ..write(value.length.toString().padLeft(2, '0'))
      ..write(value);
  });
  return '${body}6304';
}

void main() {
  group('EmvcoCrcGenerator', () {
    test('returns error for empty input', () {
      final result = EmvcoCrcGenerator.generate('   ');

      expect(result.output, isNull);
      expect(result.errorMessage, EmvcoCrcGenerator.emptyInputMessage);
    });

    test('requires payload ending with 6304', () {
      const payload = '000201010211';
      final result = EmvcoCrcGenerator.generate(payload);

      expect(result.output, isNull);
      expect(result.errorMessage, EmvcoCrcGenerator.missingCrcTagMessage);
    });

    test('calculates crc over pasted string ending with 6304', () {
      const payload = '0002010102116304';
      final result = EmvcoCrcGenerator.generate(payload);

      expect(result.errorMessage, isNull);
      expect(result.output, isNotNull);
      expect(result.output!.dataForCrc, payload);
      expect(result.output!.crc, hasLength(4));
      expect(result.output!.crc, result.output!.crc.toUpperCase());
      expect(result.output!.completePayload, '$payload${result.output!.crc}');
      expect(result.output!.crc, EmvcoCrc.calculate(payload));
    });

    test('does not append another 6304', () {
      const payload = '0002010102116304';
      final result = EmvcoCrcGenerator.generate(payload);

      expect(result.errorMessage, isNull);
      expect(result.output!.completePayload.startsWith(payload), isTrue);
      expect(result.output!.completePayload.contains('63046304'), isFalse);
    });

    test('normalizes pasted whitespace before validating 6304 suffix', () {
      const payload = '0002010102116304';
      final result = EmvcoCrcGenerator.generate('  000201010211\n6304  ');

      expect(result.errorMessage, isNull);
      expect(result.output!.dataForCrc, payload);
    });

    test('rejects payload that already contains a complete crc', () {
      const payload = '0002010102116304';
      final crc = EmvcoCrc.calculate(payload);
      final complete = '$payload$crc';

      final result = EmvcoCrcGenerator.generate(complete);

      expect(result.output, isNull);
      expect(result.errorMessage, EmvcoCrcGenerator.existingCrcMessage);
    });

    test('rejects malformed partial crc suffix', () {
      final result = EmvcoCrcGenerator.generate('0002010102116304A1');

      expect(result.output, isNull);
      expect(result.errorMessage, EmvcoCrcGenerator.malformedCrcMessage);
    });

    test('rejects invalid tlv payload without throwing', () {
      final result = EmvcoCrcGenerator.generate('000201Dh6304');

      expect(result.output, isNull);
      expect(result.errorMessage, EmvcoCrcGenerator.invalidStructureMessage);
    });

    test('keeps tags 80 and 81 before crc', () {
      final payload = _buildPayloadEndingWith6304(rootTags: {
        '01': '11',
        '80': 'AA',
        '81': 'BB',
      });
      final result = EmvcoCrcGenerator.generate(payload);

      expect(result.errorMessage, isNull);
      expect(result.output!.completePayload.endsWith(result.output!.crc), isTrue);
      expect(result.output!.completePayload.contains('80'), isTrue);
      expect(result.output!.completePayload.contains('81'), isTrue);
      expect(result.output!.completePayload.endsWith('6304${result.output!.crc}'), isTrue);
    });
  });
}
