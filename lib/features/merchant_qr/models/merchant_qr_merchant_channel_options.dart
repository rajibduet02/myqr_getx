class MerchantQrMerchantChannelOption {
  const MerchantQrMerchantChannelOption({
    required this.code,
    required this.label,
  });

  final String code;
  final String label;

  String get displayText => '$code - $label';
}

class MerchantQrMerchantChannelOptions {
  MerchantQrMerchantChannelOptions._();

  static const List<MerchantQrMerchantChannelOption> media = [
    MerchantQrMerchantChannelOption(
      code: '0',
      label: 'Print-Merchant sticker',
    ),
    MerchantQrMerchantChannelOption(
      code: '1',
      label: 'Print-Bill/Invoice',
    ),
    MerchantQrMerchantChannelOption(
      code: '2',
      label: 'Print-Magazine/Poster',
    ),
    MerchantQrMerchantChannelOption(
      code: '3',
      label: 'Print-Other',
    ),
    MerchantQrMerchantChannelOption(
      code: '4',
      label: 'Screen/Electronic-Merchant POS/POI',
    ),
    MerchantQrMerchantChannelOption(
      code: '5',
      label: 'Screen/Electronic-Website',
    ),
    MerchantQrMerchantChannelOption(
      code: '6',
      label: 'Screen/Electronic-App',
    ),
    MerchantQrMerchantChannelOption(
      code: '7',
      label: 'Screen/Electronic-Other',
    ),
  ];

  static const List<MerchantQrMerchantChannelOption> transactionLocation = [
    MerchantQrMerchantChannelOption(
      code: '0',
      label: 'At Merchant premise/registered address',
    ),
    MerchantQrMerchantChannelOption(
      code: '1',
      label: 'Not at Merchant premise/registered address',
    ),
    MerchantQrMerchantChannelOption(
      code: '2',
      label: 'Remote Commerce',
    ),
    MerchantQrMerchantChannelOption(
      code: '3',
      label: 'Other',
    ),
  ];

  static const List<MerchantQrMerchantChannelOption> merchantPresence = [
    MerchantQrMerchantChannelOption(
      code: '0',
      label: 'Attended POI',
    ),
    MerchantQrMerchantChannelOption(
      code: '1',
      label: 'Unattended',
    ),
    MerchantQrMerchantChannelOption(
      code: '2',
      label: 'Semi-attended (Self-checkout)',
    ),
    MerchantQrMerchantChannelOption(
      code: '3',
      label: 'Other',
    ),
  ];

  static MerchantQrMerchantChannelOption? findMedia(String? code) =>
      _find(media, code);

  static MerchantQrMerchantChannelOption? findTransactionLocation(String? code) =>
      _find(transactionLocation, code);

  static MerchantQrMerchantChannelOption? findMerchantPresence(String? code) =>
      _find(merchantPresence, code);

  static MerchantQrMerchantChannelOption? _find(
    List<MerchantQrMerchantChannelOption> items,
    String? code,
  ) {
    if (code == null || code.isEmpty) return null;
    for (final item in items) {
      if (item.code == code) return item;
    }
    return null;
  }
}
