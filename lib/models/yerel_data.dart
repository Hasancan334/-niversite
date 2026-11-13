// Yurt dışı flavor'larında (Amsterdam, Köln) ekranların kullandığı veriyi seçer.
// Veri sınıflarındaki "nl" alanları flavor'ın yerel dilidir (Köln'de Almanca).
import '../config/flavor.dart';
import 'koeln_data.dart';
import 'uva_data.dart';
import 'uva_extra_data.dart';

class YerelData {
  static List<UvaCategorie> get vereine =>
      kKoeln ? KoelnData.vereine : UvaData.verenigingen;
  static List<UvaCategorie> get quellen =>
      kKoeln ? KoelnData.quellen : UvaData.bronnen;
  static List<UvaCategorie> get links =>
      kKoeln ? KoelnData.links : UvaExtraData.belangrijkeLinks;
  static List<TakvimItem> get takvim =>
      kKoeln ? KoelnData.kalender : UvaExtraData.takvim;
  static String get takvimUrl =>
      kKoeln ? KoelnData.kalenderUrl : UvaExtraData.takvimUrl;
  static String get takvimYil =>
      kKoeln ? KoelnData.kalenderJahr : UvaExtraData.takvimJaar;
  static List<Campus> get kampusler =>
      kKoeln ? KoelnData.campusse : UvaExtraData.campussen;
}
