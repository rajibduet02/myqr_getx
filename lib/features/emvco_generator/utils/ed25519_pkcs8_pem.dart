import 'dart:convert';
import 'dart:typed_data';

/// Encodes Ed25519 private key material as PKCS#8 PEM (RFC 8410).
///
/// Compatible with `openssl genpkey -algorithm Ed25519`.
class Ed25519Pkcs8Pem {
  Ed25519Pkcs8Pem._();

  static const pemHeader = '-----BEGIN PRIVATE KEY-----';
  static const pemFooter = '-----END PRIVATE KEY-----';

  /// Encodes a 32-byte Ed25519 seed as PKCS#8 PEM.
  static String encode(List<int> seedBytes) {
    if (seedBytes.length != 32) {
      throw ArgumentError.value(
        seedBytes.length,
        'seedBytes',
        'Expected a 32-byte Ed25519 seed.',
      );
    }

    final der = _encodePkcs8Der(Uint8List.fromList(seedBytes));
    final base64Body = _wrapBase64(base64Encode(der));
    return '$pemHeader\n$base64Body\n$pemFooter';
  }

  /// Extracts the 32-byte Ed25519 seed from a PKCS#8 PEM string.
  static List<int> decodeSeed(String pem) {
    final lines = pem
        .split('\n')
        .where((line) => !line.startsWith('-----'))
        .join();
    final derBytes = base64Decode(lines);

    var index = 0;
    if (derBytes[index++] != 0x30) {
      throw const FormatException('Invalid PKCS#8 structure.');
    }
    index += _skipDerLength(derBytes, index);
    index += 3; // version INTEGER 0

    if (derBytes[index++] != 0x30) {
      throw const FormatException('Invalid PKCS#8 algorithm identifier.');
    }
    index += _skipDerLength(derBytes, index);
    index += 5; // Ed25519 OID

    if (derBytes[index++] != 0x04) {
      throw const FormatException('Invalid PKCS#8 private key wrapper.');
    }
    index += _skipDerLength(derBytes, index);

    if (derBytes[index++] != 0x04) {
      throw const FormatException('Invalid PKCS#8 seed wrapper.');
    }
    final seedLength = _readDerLength(derBytes, index);
    index += _derLengthSize(derBytes, index);

    final seedBytes = derBytes.sublist(index, index + seedLength);
    if (seedBytes.length != 32) {
      throw FormatException(
        'Expected a 32-byte Ed25519 seed, got ${seedBytes.length}.',
      );
    }
    return seedBytes;
  }

  static Uint8List _encodePkcs8Der(Uint8List seed) {
    final innerSeedOctetString = _derOctetString(seed);
    const ed25519Oid = <int>[0x06, 0x03, 0x2b, 0x65, 0x70];
    final algorithmIdentifier = _derSequence(Uint8List.fromList(ed25519Oid));
    final version = Uint8List.fromList([0x02, 0x01, 0x00]);
    final privateKeyOctetString = _derOctetString(innerSeedOctetString);

    return _derSequence(_concat([version, algorithmIdentifier, privateKeyOctetString]));
  }

  static Uint8List _derSequence(Uint8List content) {
    return Uint8List.fromList([0x30, ..._derLength(content.length), ...content]);
  }

  static Uint8List _derOctetString(Uint8List content) {
    return Uint8List.fromList([0x04, ..._derLength(content.length), ...content]);
  }

  static List<int> _derLength(int length) {
    if (length < 0x80) {
      return [length];
    }
    if (length <= 0xff) {
      return [0x81, length];
    }
    if (length <= 0xffff) {
      return [0x82, length >> 8, length & 0xff];
    }
    throw ArgumentError('DER length too large: $length');
  }

  static Uint8List _concat(List<Uint8List> parts) {
    final totalLength = parts.fold<int>(0, (sum, part) => sum + part.length);
    final result = Uint8List(totalLength);
    var offset = 0;
    for (final part in parts) {
      result.setRange(offset, offset + part.length, part);
      offset += part.length;
    }
    return result;
  }

  static String _wrapBase64(String base64, {int lineLength = 64}) {
    final buffer = StringBuffer();
    for (var index = 0; index < base64.length; index += lineLength) {
      final end = index + lineLength < base64.length
          ? index + lineLength
          : base64.length;
      buffer.writeln(base64.substring(index, end));
    }
    return buffer.toString().trimRight();
  }

  static int _skipDerLength(List<int> bytes, int index) {
    return _derLengthSize(bytes, index);
  }

  static int _derLengthSize(List<int> bytes, int index) {
    final firstByte = bytes[index];
    if (firstByte < 0x80) {
      return 1;
    }
    if (firstByte == 0x81) {
      return 2;
    }
    if (firstByte == 0x82) {
      return 3;
    }
    throw const FormatException('Unsupported DER length encoding.');
  }

  static int _readDerLength(List<int> bytes, int index) {
    final firstByte = bytes[index];
    if (firstByte < 0x80) {
      return firstByte;
    }
    if (firstByte == 0x81) {
      return bytes[index + 1];
    }
    if (firstByte == 0x82) {
      return (bytes[index + 1] << 8) | bytes[index + 2];
    }
    throw const FormatException('Unsupported DER length encoding.');
  }
}
