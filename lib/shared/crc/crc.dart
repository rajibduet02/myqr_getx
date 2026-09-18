import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'crc_Helper.dart';

import 'crcParameters.dart';

class CRC {
  late BigInt _mask;
  late BigInt _currentValue;

  List<BigInt> _table = <BigInt>[BigInt.from(256)];

  int get HashSize => Params.HashSize;

  String get Name => Params.Name;

  final crcParameters Params;

  CRC({required this.Params}) {
    final maxValue = BigInt.parse('18446744073709551615');
    _mask = maxValue >> (64 - HashSize);
    Init();
  }

  void Init() {
    CreateTable();

    Initialize();
  }

  void Initialize() {
    _currentValue = Params.RefOut
        ? crcHelper.ReverseBits(Params.Init, HashSize)
        : Params.Init;
  }

  void CreateTable() {
    for (int i = 0; i < 256; i++) {
      _table.insert(i, CreateTableEntry(i));
    }
  }

  List<int> HashCore(List<int> array, int Length) {
    _currentValue = ComputeCrc(_currentValue, array, 0, Length);
    print("Current Value:" + _currentValue.toString());
    return bigIntToUint8List(_currentValue).map((i) => i).toList();
  }

  Uint8List bigIntToUint8List(BigInt bigInt) =>
      bigIntToByteData(bigInt).buffer.asUint8List();

  ByteData bigIntToByteData(BigInt bigInt) {
    final data = ByteData((bigInt.bitLength / 8).ceil());
    var _bigInt = bigInt;

    for (var i = 1; i <= data.lengthInBytes; i++) {
      data.setUint8(data.lengthInBytes - i, _bigInt.toUnsigned(8).toInt());
      _bigInt = _bigInt >> 8;
    }

    return data;
  }

  BigInt ComputeCrc(BigInt init, List<int> data, int offset, int length) {
    BigInt crc = init;
    BigInt FinalCRC = init;
    if (Params.RefOut) {
      for (int i = offset; i < (offset + length) - 1; i++) {
        crc = (_table[
                ((crc ^ BigInt.parse(data[i].toString()) & BigInt.parse("0xFF"))
                    .toInt())] ^
            (crc >> 8));
        crc &= _mask;
      }
    } else {
      int toRight = (HashSize - 8);
      toRight = toRight < 0 ? 0 : toRight;
      for (int i = offset; i < offset + length; i++) {
        var indx = (((crc >> toRight) ^ BigInt.parse(data[i].toString())) &
                BigInt.parse("0xFF"))
            .toInt();

        crc = (_table[(((crc >> toRight) ^ BigInt.parse(data[i].toString())) &
                    BigInt.parse("0xFF"))
                .toInt()] ^
            (crc << 8));
        crc &= _mask;
        if (crc != null) {
          FinalCRC = crc;
        }
      }
    }

    return FinalCRC;
  }

  BigInt CreateTableEntry(int index) {
    BigInt r = BigInt.from(index);

    if (Params.RefIn)
      r = crcHelper.ReverseBits(r, HashSize);
    else if (HashSize > 8) r <<= (HashSize - 8);

    BigInt lastBit = (BigInt.parse("1") << (HashSize - 1));

    for (int i = 0; i < 8; i++) {
      //print("R: ${r}");
      //print("Last Bit : ${lastBit}");
      //print("(r & lastBit) : ${(r & lastBit)}");
      if ((r & lastBit).toString() != "0") {
        r = ((r << 1) ^ Params.Poly);
      } else {
        r <<= 1;
      }
    }

    if (Params.RefIn) r = crcHelper.ReverseBits(r, HashSize);
    //print("R after reverse bits :${r}");

    //var x= r & _mask;

    return r & _mask;
  }

  @override
  // TODO: implement blockLengthInBytes
  int get blockLengthInBytes => throw UnimplementedError();

  @override
  // TODO: implement hashLengthInBytes
  int get hashLengthInBytes {
    return HashSize;
  } //throw UnimplementedError();

  @override
  // TODO: implement name
  String get name {
    return Name;
  } //=> throw UnimplementedError();

  @override
  HashSink newSink() => throw UnimplementedError();
  String ToHex(List<ByteData> bytes, bool upperCase) {
    var sb = new StringBuffer(bytes.length * 2);

    for (int i = 0; i < bytes.length; i++) {
      sb.write(bytes[i].toString());
    }

    return sb.toString();
  }
}
