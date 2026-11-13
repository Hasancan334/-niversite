import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/flavor.dart';

/// Uygulama dili. Türkçe flavor'lar (tarsus, mersin) hep 'tr' kalır.
/// Amsterdam: 'nl' (varsayılan) ve 'en'. Köln: 'de' (varsayılan) ve 'en'.
class Dil {
  static const String _anahtar = 'dil_kodu';

  /// Flavor'ın yerel dili: 'nl' (Amsterdam), 'de' (Köln), 'tr' (Türkiye)
  static const String yerelKod = kAmsterdam ? 'nl' : (kKoeln ? 'de' : 'tr');

  /// 'tr', 'nl', 'de' veya 'en'
  static String kod = yerelKod;

  /// Kullanıcı dil seçti mi? (Yurt dışı flavor'larda ilk açılışta karşılama + dil ekranı için)
  static bool secildiMi = !kYabanci;

  /// Dil değişince arttırılır; uygulamanın kökü bunu dinleyip yeniden çizilir.
  static final ValueNotifier<int> surum = ValueNotifier<int>(0);

  static Future<void> yukle() async {
    if (!kYabanci) return;
    try {
      final p = await SharedPreferences.getInstance();
      final k = p.getString(_anahtar);
      if (k == yerelKod || k == 'en') {
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
      case 'de':
        return 'de_DE';
      case 'en':
        return 'en_GB';
      default:
        return 'tr_TR';
    }
  }
}

/// Kısa çeviri yardımcısı: tx('Türkçe', 'Nederlands', 'English', 'Deutsch')
/// Almanca verilmezse İngilizce gösterilir.
String tx(String tr, String nl, String en, [String? de]) {
  switch (Dil.kod) {
    case 'nl':
      return nl;
    case 'de':
      return de ?? en;
    case 'en':
      return en;
    default:
      return tr;
  }
}

/// Yerel veri metinleri için: [yerel] flavor'ın kendi dilinde (nl ya da de),
/// [en] İngilizce. Dil İngilizce ise [en], değilse [yerel] döner.
String yx(String yerel, String en) => Dil.kod == 'en' ? en : yerel;
