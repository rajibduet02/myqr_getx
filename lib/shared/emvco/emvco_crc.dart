import 'dart:convert';

import '../crc/crc.dart';
import '../crc/crc_std_parameters.dart';

class EmvcoCrc {
  EmvcoCrc._();

  static String calculate(String qrWithoutCrcValue) {
    final params =
        crcStandardParameters.StandardParams[crcAlgorithms.Crc16CcittFalse]!;
    final crc = CRC(Params: params).HashCore(
      utf8.encode(qrWithoutCrcValue),
      qrWithoutCrcValue.length,
    );
    return _toHex(crc).padLeft(4, '0');
  }

  static String _toHex(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).toUpperCase());
    }
    return buffer.toString();
  }
}
