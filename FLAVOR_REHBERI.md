# Üniversite Genç Mobil - Flavor Rehberi

Tek kod, her üniversite bir "flavor". Şu an: `tarsus`, `mersin`, `amsterdam`, `koeln`, `toros`, `selcuk`. `toros`.
Ayrıntılar: AMSTERDAM_NOTLAR.md, KOELN_NOTLAR.md, TOROS_NOTLAR.md

Push bildirimleri sadece Toros'ta açık, yemek menüsü Toros'ta yok (lib/config/flavor.dart: kBildirimler, kYemekhane).
Sunucu tarafı: functions/ (Cloud Functions), kurallar: firestore.rules

## Çalıştırma / derleme
- Çalıştır:        flutter run --flavor tarsus
- Play için AAB:   flutter build appbundle --flavor tarsus --release
- Yönetici APK:    flutter build apk --flavor tarsus --release --dart-define=ADMIN=true
  (sadece kendi telefonun için; mağazaya gönderme)

Android Studio: Run > Edit Configurations > "Build flavor" alanına tarsus veya mersin yaz.

## Gizli dosyalar (GitHub'da YOK, her flavor için elle konur)
- android/app/src/tarsus/google-services.json
- android/app/src/mersin/google-services.json
- android/app/src/amsterdam, koeln, toros/google-services.json
- android/key-tarsus.properties, android/key-mersin.properties, android/key-amsterdam.properties, android/key-koeln.properties, android/key-toros.properties (+ ilgili .jks dosyaları)
  Biçim: storePassword, keyPassword, keyAlias, storeFile (yolda / kullan)
  Tarsus/Mersin için dosya yoksa eski android/key.properties kullanılır; Amsterdam için kullanılmaz.

## Yeni üniversite eklemek
1. android/app/build.gradle.kts -> productFlavors içine yeni create("ad") bloğu
   (applicationId, versionCode, app_name, admobAppId)
2. lib/config/flavor.dart ve lib/config/university_config.dart -> yeni flavor için ad, OBS, logo
3. lib/services/ad_service.dart -> AdMob birim kimlikleri
4. assets/ içine logo, pubspec.yaml assets listesine ekle
5. android/app/src/<ad>/google-services.json (yeni Firebase projesi)
6. Gerekirse renkler: lib/config/app_colors.dart
