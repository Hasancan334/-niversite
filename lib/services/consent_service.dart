import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AB/AVG (GDPR) için reklam onayı (UMP). Sadece Amsterdam flavor'unda çağrılır.
/// AdMob konsolunda Gizlilik ve mesajlaşma > Avrupa düzenlemeleri mesajı oluşturulmalı;
/// mesaj yoksa form gösterilmez.
class ConsentService {
  static Future<void> hazirla() async {
    final tamam = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? hata) {
          if (!tamam.isCompleted) tamam.complete();
        });
      },
      (FormError hata) {
        if (!tamam.isCompleted) tamam.complete();
      },
    );
    await tamam.future.timeout(Duration(seconds: 10), onTimeout: () {});
  }
}
