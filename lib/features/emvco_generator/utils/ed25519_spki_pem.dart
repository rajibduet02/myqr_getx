import 'dart:convert';
import 'dart:typed_data';

/// Encodes Ed25519 public key material as SubjectPublicKeyInfo PEM (RFC 8410).
///
/// Compatible with `openssl pkey -pubout`.
class Ed25519SpkiPem {
  Ed25519SpkiPem._();

  static const pemHeader = '-----BEGIN PUBLIC KEY-----';
  static const pemFooter = '-----END PUBLIC KEY-----';

  /// Encodes a 32-byte Ed25519 public key as SPKI PEM.
  static String encode(List<int> publicKeyBytes) {
    if (publicKeyBytes.length != 32) {
      throw ArgumentError.value(
        publicKeyBytes.length,
        'publicKeyBytes',
        'Expected a 32-byte Ed25519 public key.',
      );
    }

    final der = _encodeSpkiDer(Uint8List.fromList(publicKeyBytes));
    final base64Body = _wrapBase64(base64Encode(der));
    return '$pemHeader\n$base64Body\n$pemFooter';
  }

  static Uint8List _encodeSpkiDer(Uint8List publicKey) {
    const ed25519Oid = <int>[0x06, 0x03, 0x2b, 0x65, 0x70];
    final algorithmIdentifier = _derSequence(Uint8List.fromList(ed25519Oid));
    final bitString = _derBitString(
      Uint8List.fromList([0x00, ...publicKey]),
    );

    return _derSequence(_concat([algorithmIdentifier, bitString]));
  }

  static Uint8List _derSequence(Uint8List content) {
    return Uint8List.fromList([0x30, ..._derLength(content.length), ...content]);
  }

  static Uint8List _derBitString(Uint8List content) {
    return Uint8List.fromList([0x03, ..._derLength(content.length), ...content]);
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

  /// Extracts the 32-byte Ed25519 public key from an SPKI PEM string.
  static List<int> decodePublicKeyBytes(String pem) {
    final lines = pem
        .split('\n')
        .where((line) => !line.startsWith('-----'))
        .join();
    final derBytes = base64Decode(lines);

    var index = 0;
    if (derBytes[index++] != 0x30) {
      throw const FormatException('Invalid SPKI structure.');
    }
    index += _skipDerLength(derBytes, index);
    if (derBytes[index++] != 0x30) {
      throw const FormatException('Invalid SPKI algorithm identifier.');
    }
    index += _skipDerLength(derBytes, index);
    index += 5;

    if (derBytes[index++] != 0x03) {
      throw const FormatException('Invalid SPKI public key bit string.');
    }
    index += _skipDerLength(derBytes, index);
    if (derBytes[index++] != 0x00) {
      throw const FormatException('Invalid SPKI unused bits marker.');
    }

    final publicKeyBytes = derBytes.sublist(index, index + 32);
    if (publicKeyBytes.length != 32) {
      throw FormatException(
        'Expected a 32-byte Ed25519 public key, got ${publicKeyBytes.length}.',
      );
    }
    return publicKeyBytes;
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
}
