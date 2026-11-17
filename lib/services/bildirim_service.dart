import 'package:firebase_messaging/firebase_messaging.dart';
import '../config/flavor.dart';

/// Push bildirimleri (sadece kBildirimler açık flavor'larda, şu an Toros).
///
/// Bildirimleri sunucu tarafı gönderir (functions/ klasöründeki Cloud Functions):
///  - 'sohbet' : sohbet odasında her 5 mesajda bir
///  - 'yemek'  : her gün 11:00'de günün menüsü
///  - 'duyuru' : yöneticinin "bildirim": true işaretlediği duyuru/etkinlikler
/// Uygulama sadece izin ister ve bu konulara (topic) abone olur.
class BildirimService {
  static const konular = ['sohbet', 'yemek', 'duyuru'];

  static Future<void> baslat() async {
    if (!kBildirimler) return;
    final m = FirebaseMessaging.instance;
    // AndroidManifest'te otomatik başlatma kapalı (diğer flavor'lar için);
    // burada açılıyor.
    await m.setAutoInitEnabled(true);
    await m.requestPermission(alert: true, badge: true, sound: true);
    for (final k in konular) {
      // Beklemeden; servis yoksa Firebase kendisi tekrar dener
      m.subscribeToTopic(k).catchError((e) {
        print('Topic aboneliği başarısız ($k): $e');
      });
    }
  }
}
