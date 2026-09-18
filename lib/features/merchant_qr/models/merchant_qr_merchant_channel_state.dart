import 'merchant_qr_merchant_channel_options.dart';

class MerchantQrMerchantChannelState {
  String? mediaCode;
  String? transactionLocationCode;
  String? merchantPresenceCode;

  String? get generatedValue {
    final media = mediaCode;
    final location = transactionLocationCode;
    final presence = merchantPresenceCode;
    if (media == null ||
        media.isEmpty ||
        location == null ||
        location.isEmpty ||
        presence == null ||
        presence.isEmpty) {
      return null;
    }
    return '$media$location$presence';
  }

  void clear() {
    mediaCode = null;
    transactionLocationCode = null;
    merchantPresenceCode = null;
  }

  void hydrateFromChannelValue(String value) {
    final trimmed = value.trim();
    if (trimmed.length != 3) {
      return;
    }

    final media = trimmed[0];
    final location = trimmed[1];
    final presence = trimmed[2];

    if (MerchantQrMerchantChannelOptions.findMedia(media) == null ||
        MerchantQrMerchantChannelOptions.findTransactionLocation(location) ==
            null ||
        MerchantQrMerchantChannelOptions.findMerchantPresence(presence) == null) {
      return;
    }

    mediaCode = media;
    transactionLocationCode = location;
    merchantPresenceCode = presence;
  }
}
