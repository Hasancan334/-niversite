# Selçuk (Selçuk Üniversitesi Genç Mobil) - yapılacaklar

Flavor: `selcuk`  |  Paket: com.hasan.selcuk_genc  |  Dil: Türkçe

## Çalıştırma
- flutter run --flavor selcuk
- Play AAB:  flutter build appbundle --flavor selcuk --release
- Yönetici:  flutter build apk --flavor selcuk --release --dart-define=ADMIN=true

## Özellikler
- Tarsus ile aynı: günlük yemek menüsü (admin panelinden JSON), Harçlık Kapısı, anlaşmalı mekanlar,
  ders notları, kulüpler, Goygoy Odası, duyurular.
- Push bildirimleri YOK (lib/config/flavor.dart -> kBildirimler sadece Toros).

## Yayından önce elle yapılacaklar
1. Firebase: yeni proje -> android/app/src/selcuk/google-services.json (paket com.hasan.selcuk_genc)
   - Firestore oluştur (konum: europe-west1 ya da eur3), kurallar: firestore.rules (YONETICI_EPOSTASI'nı değiştir)
   - Authentication: e-posta/şifre, yönetici kullanıcısını ekle
2. AdMob: ŞU AN GOOGLE TEST KİMLİKLERİ VAR. Yeni uygulama + banner + geçiş oluştur:
   - android/app/build.gradle.kts -> selcuk admobAppId
   - lib/services/ad_service.dart -> kSelcuk banner ve geçiş
3. Keystore: android/key-selcuk.properties + .jks (yeni üret, yedekle)
4. OBS adresi doğrulanacak: lib/config/university_config.dart (şimdilik https://obs.selcuk.edu.tr/)
5. Logo: assets/images/selcuk_logo.png geçici tasarım. Üniversite logosunu izinsiz kullanma.
   Uygulama simgesi: android/app/src/selcuk/res/mipmap-* (yoksa Tarsus simgesi görünür;
   ic_launcher, ic_launcher_adaptive_back, ic_launcher_adaptive_fore - 5 yoğunluk)
6. Kulüp ve ders notu verileri ŞİMDİLİK TARSUS'UN (kulupler_data.dart, fakulte_data.dart).
   Ekran görüntüsü alırken bu ekranlara dikkat.
7. Gizlilik politikası hazırlanacak; Play Console web sitesi: https://hasancan334.github.io
