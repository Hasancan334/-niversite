# Toros (Toros Üniversitesi Genç Mobil) - yapılacaklar

Flavor: `toros`  |  Paket: com.hasan.toros_genc  |  Dil: Türkçe

## Çalıştırma
- flutter run --flavor toros
- Play AAB:  flutter build appbundle --flavor toros --release
- Yönetici:  flutter build apk --flavor toros --release --dart-define=ADMIN=true

## Özellikler (Tarsus'tan farklı olanlar)
- Push bildirimleri (sadece Toros'ta açık; lib/config/flavor.dart -> kBildirimler):
  - Sohbet odası: her 5 mesajda bir "Sohbet odasında sohbet başladı, sen de katıl!"
    (iki bildirim arası en az 10 dakika; functions/index.js içinde SOHBET_* ile değiştir)
  - Duyuru/etkinlik: yönetici ekranında "Kullanıcılara bildirim gönder" kutusunu işaretle
    ya da JSON'a "bildirim": true yaz. Sadece YENİ kayıtta gider (aynı kimlikle tekrar
    yüklemek yeniden göndermez).
- Yemek menüsü YOK (Toros'ta yemekhane yok; lib/config/flavor.dart -> kYemekhane).
- Harçlık Kapısı: Tarsus'taki gibi (is_ilanlari).

## Yayından önce elle yapılacaklar
1. Firebase: yeni proje -> android/app/src/toros/google-services.json (paket com.hasan.toros_genc)
   - Authentication: e-posta/şifre, yönetici kullanıcısını ekle
   - Firestore oluştur; kurallar: firestore.rules (içindeki YONETICI_EPOSTASI'nı değiştir)
2. Bildirimler (Cloud Functions) - projeyi Blaze planına geçir (ücretsiz kota bu kullanım için yeter):
   ```
   npm install -g firebase-tools
   firebase login
   firebase use --add            (Toros projesini seç)
   cd functions && npm install && cd ..
   firebase deploy --only functions,firestore:rules
   ```
   Firestore konumu eur3 değilse functions/index.js içindeki BOLGE'yi değiştir
   (nam5 -> us-central1, tek bölge -> aynı bölge adı).
   Not: Bu functions sadece Toros projesine yüklenmeli; diğer projelere `firebase use` ile dikkat.
3. AdMob: şu an Google TEST kimlikleri. Gerçek kimlikleri gir:
   build.gradle.kts (toros admobAppId) ve lib/services/ad_service.dart (kToros)
4. Keystore: android/key-toros.properties + .jks (yeni üret, yedekle)
5. OBS adresi doğrulanacak: lib/config/university_config.dart (şimdilik https://obsogrenci.toros.edu.tr/)
6. Logo: assets/images/toros_logo.png bizim geçici tasarımımız. Üniversite logosunu izinsiz kullanma.
   Uygulama simgesi: android/app/src/toros/res/mipmap-* (şu an Tarsus simgesi kullanılır)
7. Fakülte/ders notu ve kulüp verileri Tarsus'tan geliyor (fakulte_data.dart, kulupler_data.dart); Toros'a göre düzenle.
8. Play Console: Veri güvenliği formunda "kullanıcı içeriği (sohbet, yorum)" ve bildirimleri belirt.
