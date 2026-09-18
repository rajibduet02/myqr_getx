import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

class AdBannerSlot {
  AdBannerSlot._(this.banner);

  final BannerAd banner;
}

class AdService {
  late final AdBannerSlot scanTab;
  late final AdBannerSlot generateTab;
  late final AdBannerSlot overlay;
  late final AdBannerSlot clientQrTab;
  late final AdBannerSlot qrImage;

  void init() {
    scanTab = _createSlot();
    generateTab = _createSlot();
    overlay = _createSlot();
    clientQrTab = _createSlot();
    qrImage = _createSlot();
  }

  AdBannerSlot _createSlot() {
    final banner = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();

    return AdBannerSlot._(banner);
  }

  void dispose() {
    scanTab.banner.dispose();
    generateTab.banner.dispose();
    overlay.banner.dispose();
    clientQrTab.banner.dispose();
    qrImage.banner.dispose();
  }
}
