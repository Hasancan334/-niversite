import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/flavor.dart';

class AdService {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // TEST ID - Gerçek yayında değiştir!
      if (kAmsterdam) {
        return 'ca-app-pub-5799565273289643/1295368316'; // Amsterdam banner
      }
      return kMersin
          ? 'ca-app-pub-5799565273289643/6386757943' // Mersin banner
          : 'ca-app-pub-5799565273289643/2765238361'; // Tarsus banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // TEST ID - Gerçek yayında değiştir!
      if (kAmsterdam) {
        return 'ca-app-pub-5799565273289643/7286061591'; // Amsterdam geçiş
      }
      return kMersin
          ? 'ca-app-pub-5799565273289643/5073676271' // Mersin geçiş
          : 'ca-app-pub-5799565273289643/1452156699'; // Tarsus geçiş
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Banner Ad Oluştur
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner Ad loaded.'),
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  // Interstitial Ad Yükle
  static Future<InterstitialAd?> loadInterstitialAd() async {
    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          print('✅ Interstitial Ad loaded.');  // EKLE
        },
        onAdFailedToLoad: (error) {
          print('❌ Interstitial Ad failed: $error');  // EKLE
        },
      ),
    );

    return interstitialAd;
  }
}