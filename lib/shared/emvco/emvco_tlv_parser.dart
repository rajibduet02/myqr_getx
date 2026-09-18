class EmvcoTlvParser {
  EmvcoTlvParser._();

  static Map<String, String> parse(String data) {
    final tags = <String, String>{};
    var index = 0;

    while (index + 4 <= data.length) {
      final tag = data.substring(index, index + 2);
      index += 2;
      final length = int.parse(data.substring(index, index + 2));
      index += 2;

      if (index + length > data.length) {
        throw FormatException('Invalid TLV length for tag $tag.');
      }

      final value = data.substring(index, index + length);
      index += length;
      tags[tag] = value;
    }

    return tags;
  }

  static ({String dataForCrc, String storedCrc})? extractCrcParts(String qrText) {
    var index = 0;

    while (index + 4 <= qrText.length) {
      final tag = qrText.substring(index, index + 2);
      index += 2;
      final length = int.parse(qrText.substring(index, index + 2));
      index += 2;

      if (tag == '63') {
        if (length != 4 || index + 4 > qrText.length) {
          return null;
        }

        final storedCrc = qrText.substring(index, index + 4);
        final dataForCrc = qrText.substring(0, index);
        return (dataForCrc: dataForCrc, storedCrc: storedCrc);
      }

      if (index + length > qrText.length) {
        return null;
      }

      index += length;
    }

    return null;
  }
}
