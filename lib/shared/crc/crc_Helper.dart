import 'dart:ffi';
import 'package:flutter/services.dart';

class crcHelper{
  static BigInt  ReverseBits(BigInt ul, int valueLength)
  {
    BigInt newValue =BigInt.from(0) ;

    for (int i = valueLength - 1; i >= 0; i--)
    {
      newValue |= (ul & BigInt.from(1)) << i;
      ul >>= 1;
    }

    return newValue;
  }

  //static List<ByteData> ToBigEndianBytes(BigInt value)
  //{
    //var result = BitConverter.GetBytes(value);

    //if/ (BitConverter.IsLittleEndian)
      //Array.Reverse(result);

    //return result;
 // }

}


