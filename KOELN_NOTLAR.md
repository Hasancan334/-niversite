# Köln (Studienguide Köln) - yapılacaklar

Flavor: `koeln`  |  Paket: com.hasan.koeln_genc  |  Diller: Almanca (varsayılan) + İngilizce

## Çalıştırma
- flutter run --flavor koeln
- Play AAB:  flutter build appbundle --flavor koeln --release
- Yönetici:  flutter build apk --flavor koeln --release --dart-define=ADMIN=true

## Yayından önce elle yapılacaklar
1. Firebase: yeni proje -> android/app/src/koeln/google-services.json (paket com.hasan.koeln_genc)
   Bu dosya olmadan Köln derlenmez. Authentication (yönetici e-postası) + Firestore kuralları.
2. AdMob: yeni uygulama aç. ŞU AN GOOGLE TEST KİMLİKLERİ VAR:
   - android/app/build.gradle.kts -> koeln admobAppId
   - lib/services/ad_service.dart -> kKoeln banner ve geçiş kimlikleri
   AdMob > Gizlilik ve mesajlaşma > Avrupa düzenlemeleri mesajını yayınla.
3. Keystore: android/key-koeln.properties + .jks (yeni üret, yedekle)
4. Gizlilik politikası: hazırlanınca adresini lib/screens/ayarlar_screen.dart içine yaz
   (boşken Ayarlar'da satır görünmez). Play Console da bu adresi ister.
5. Uygulama simgesi: android/app/src/koeln/res/mipmap-* (şu an Tarsus simgesi kullanılır)
6. Logo: assets/images/koeln_logo.png geçici. Üniversitenin logosunu izinsiz kullanma.

## İçerik
- Veriler: lib/models/koeln_data.dart (kulüpler, kaynaklar, takvim, kampüs, mensa, linkler)
- Takvimi HER DÖNEM güncelle: studierende.uni-koeln.de/studienorganisation/termine
- Mensa: menüler kstw.de / koeln.my-mensa.de üzerinden; uygulama sadece link verir.
- Duyurular: yönetici ekranından (Firestore), metinleri Almanca yaz.

## Kontrol edilecek bilgiler
- Mensa Lindenthal adresi (Robert-Koch-Straße 10 olarak yazıldı; başka kaynakta Universitätsstraße 37 geçiyor)
- Bina adresleri ve kulüp linkleri (arama sonuçlarından derlendi)
