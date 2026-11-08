# Amsterdam (UvA Student App) - yapılacaklar

Flavor: `amsterdam`  |  Paket: com.hasan.amsterdam_genc (değiştirmek için build.gradle.kts)

## Çalıştırma
- flutter run --flavor amsterdam
- Play AAB:  flutter build appbundle --flavor amsterdam --release
- Yönetici:  flutter build apk --flavor amsterdam --release --dart-define=ADMIN=true

## Elle yapılacaklar
1. Firebase: yeni proje -> android/app/src/amsterdam/google-services.json (paket com.hasan.amsterdam_genc)
   Authentication (yönetici e-postası) + Firestore kuralları (Tarsus'takiyle aynı)
2. AdMob: gerçek kimlikler girildi (ad_service.dart kAmsterdam bölümü, build.gradle.kts admobAppId)
3. AB onayı (GDPR/UMP): AdMob > Gizlilik ve mesajlaşma > "Avrupa düzenlemeleri" mesajı oluştur ve yayınla
4. Android keystore: key-amsterdam özelinde ayrı üret ve yedekle
5. Logo: assets/images/amsterdam_logo.png geçici, kendi tasarımımız. UvA logosunu izinsiz kullanma.
   Uygulama simgesi (launcher icon) flavor için henüz ayrılmadı.
6. Mağaza metinleri (NL + EN), gizlilik politikası (İngilizce, GDPR/AVG)

## İçerik
- Kulüpler ve kaynaklar lib/models/uva_data.dart (kaynak: student.uva.nl). Linkler zamanla değişebilir, kontrol et.
- Yemek, duyuru, mekan, iş ilanı verisi yönetici ekranından (Firestore) girilir; metinleri Hollandaca yaz.
- Yemek tarihi: "2 november maandag" ya da "02.11.2026" biçimi desteklenir.

## Dil
- Varsayılan Hollandaca, ilk açılışta Karşılama + dil seçimi; ana ekran sağ üstte dil simgesi.
- Metinler kodda tx('Türkçe','Nederlands','English') ile; yeni metin eklerken üçünü de yaz.
