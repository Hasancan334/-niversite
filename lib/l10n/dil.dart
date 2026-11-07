import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/flavor.dart';

/// Uygulama dili. Türkçe flavor'lar (tarsus, mersin) hep 'tr' kalır.
/// Amsterdam flavor'u 'nl' (varsayılan) ve 'en' destekler.
class Dil {
  static const String _anahtar = 'dil_kodu';

  /// 'tr', 'nl' veya 'en'
  static String kod = kAmsterdam ? 'nl' : 'tr';

  /// Kullanıcı dil seçti mi? (Amsterdam'da ilk açılışta karşılama + dil ekranı için)
  static bool secildiMi = !kAmsterdam;

  /// Dil değişince arttırılır; uygulamanın kökü bunu dinleyip yeniden çizilir.
  static final ValueNotifier<int> surum = ValueNotifier<int>(0);

  static Future<void> yukle() async {
    if (!kAmsterdam) return;
    try {
      final p = await SharedPreferences.getInstance();
      final k = p.getString(_anahtar);
      if (k == 'nl' || k == 'en') {
        kod = k!;
        secildiMi = true;
      }
    } catch (_) {}
  }

  static Future<void> sec(String k) async {
    kod = k;
    secildiMi = true;
    surum.value++;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_anahtar, k);
    } catch (_) {}
  }

  static String get locale {
    switch (kod) {
      case 'nl':
        return 'nl_NL';
      case 'en':
        return 'en_GB';
      default:
        return 'tr_TR';
    }
  }
}

/// Kısa çeviri yardımcısı: tx('Türkçe', 'Nederlands', 'English')
String tx(String tr, String nl, String en) {
  switch (Dil.kod) {
    case 'nl':
      return nl;
    case 'en':
      return en;
    default:
      return tr;
  }
}
