// Hangi üniversite sürümü derleniyor?
// flutter run/build ... --flavor tarsus   (ya da mersin)
// Flutter, --flavor değerini FLUTTER_APP_FLAVOR olarak koda geçirir.
const String kFlavor =
    String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'tarsus');

const bool kMersin = kFlavor == 'mersin';
const bool kAmsterdam = kFlavor == 'amsterdam';
const bool kKoeln = kFlavor == 'koeln';
const bool kToros = kFlavor == 'toros';
const bool kTarsus = !kMersin && !kAmsterdam && !kKoeln && !kToros;

// Yurt dışı flavor'ları (Amsterdam, Köln): dil seçimi, AB reklam onayı,
// Türkiye'ye özel bölümler (yemekhane, mekanlar, harçlık) gizli.
const bool kYabanci = kAmsterdam || kKoeln;

// Sadece geliştirici derlemesinde yönetici ekranı açılır:
// flutter build apk --flavor tarsus --dart-define=ADMIN=true
const bool kAdminSurumu = bool.fromEnvironment('ADMIN');

// Push bildirimleri (sohbet, duyuru/etkinlik).
// Şimdilik sadece Toros'ta açık; yayındaki uygulamalar etkilenmez.
// Başka flavor'da açmak için buraya ekle (o projeye Cloud Functions da kurulmalı).
const bool kBildirimler = kToros;

// Günlük yemekhane menüsü: Tarsus ve Mersin. (Toros'ta yemekhane yok.)
const bool kYemekhane = !kYabanci && !kToros;
