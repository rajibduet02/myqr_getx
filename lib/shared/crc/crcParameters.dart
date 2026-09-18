class crcParameters {
  final BigInt check;
  final int hashSize;
  final BigInt init;
  final String name;
  final BigInt poly;
  final bool refIn;
  final bool refOut;
  final BigInt xorOut;

  crcParameters({
    required String Name,
    required BigInt Check,
    required BigInt Init,
    required BigInt Poly,
    required bool RefIn,
    required bool RefOut,
    required BigInt XorOut,
    required int HashSize,
  })  : name = Name,
        check = Check,
        init = Init,
        poly = Poly,
        refIn = RefIn,
        refOut = RefOut,
        xorOut = XorOut,
        hashSize = HashSize;

  // Legacy accessors used by CRC implementation
  BigInt get Check => check;
  int get HashSize => hashSize;
  BigInt get Init => init;
  String get Name => name;
  BigInt get Poly => poly;
  bool get RefIn => refIn;
  bool get RefOut => refOut;
  BigInt get XorOut => xorOut;
}
