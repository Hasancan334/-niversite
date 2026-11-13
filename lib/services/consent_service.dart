import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/flavor.dart';

/// AB/AVG (GDPR) için reklam onayı (Google UMP). Sadece Amsterdam ve Köln flavor'larında
/// kullanılır. AdMob konsolunda Gizlilik ve mesajlaşma > Avrupa düzenlemeleri
/// mesajı yayınlanmış olmalı; yoksa form gösterilmez.
///
/// Reklamlar yalnızca [reklamHazir] true olduktan sonra yüklenir.
class ConsentService {
  /// Debug derlemesinde UMP test cihazı kimliği. Uygulamayı debug modda bir kez
  /// çalıştır, logcat'te "ConsentDebugSettings.Builder().addTestDeviceHashedId"
  /// satırındaki kimliği buraya yaz. Release derlemesinde hiç kullanılmaz.
  static const String _debugTestCihazId = '';

  /// true olunca MobileAds başlatılmıştır ve reklam istenebilir.
  static final ValueNotifier<bool> reklamHazir = ValueNotifier<bool>(false);

  static bool _baslatildi = false;

  /// Tarsus / Mersin: onay akışı yok, reklamlar eskisi gibi başlar.
  static Future<void> onaysizBaslat() async {
    await MobileAds.instance.initialize();
    reklamHazir.value = true;
  }

  /// Amsterdam: açılışta çağrılır (beklemeden). Onay bilgisini günceller,
  /// gerekiyorsa formu gösterir, izin varsa reklamları başlatır.
  static void amsterdamBaslat() {
    ConsentInformation.instance.requestConsentInfoUpdate(
      _parametreler(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? hata) {
          _izinVarsaBaslat();
        });
      },
      (FormError hata) {
        // Güncelleme başarısız: önceki oturumdaki onay hâlâ geçerli olabilir.
        _izinVarsaBaslat();
      },
    );
    // Önceki oturumda verilmiş onay varsa beklemeden başla.
    _izinVarsaBaslat();
  }

  static ConsentRequestParameters _parametreler() {
    // kDebugMode release'de sabit false; bu dal release derlemesine girmez.
    if (kYabanci && kDebugMode) {
      return ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
          debugGeography: DebugGeography.debugGeographyEea,
          testIdentifiers:
              _debugTestCihazId.isEmpty ? null : [_debugTestCihazId],
        ),
      );
    }
    return ConsentRequestParameters();
  }

  static Future<void> _izinVarsaBaslat() async {
    if (_baslatildi) return;
    if (!await ConsentInformation.instance.canRequestAds()) return;
    if (_baslatildi) return;
    _baslatildi = true;
    await MobileAds.instance.initialize();
    reklamHazir.value = true;
  }

  /// Ayarlar ekranındaki "Privacy options" butonu görünsün mü?
  static Future<bool> gizlilikSecenekleriGerekli() async {
    if (!kYabanci) return false;
    final durum =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    return durum == PrivacyOptionsRequirementStatus.required;
  }

  static void gizlilikSecenekleriniGoster() {
    ConsentForm.showPrivacyOptionsForm((FormError? hata) {
      _izinVarsaBaslat();
    });
  }

  /// [f] reklamlar hazır olunca bir kez çalışır (hazırsa hemen).
  static void hazirOlunca(VoidCallback f) {
    if (reklamHazir.value) {
      f();
      return;
    }
    void dinle() {
      if (!reklamHazir.value) return;
      reklamHazir.removeListener(dinle);
      f();
    }

    reklamHazir.addListener(dinle);
  }
}
