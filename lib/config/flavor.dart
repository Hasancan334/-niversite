// Hangi üniversite sürümü derleniyor?
// flutter run/build ... --flavor tarsus   (ya da mersin)
// Flutter, --flavor değerini FLUTTER_APP_FLAVOR olarak koda geçirir.
const String kFlavor =
    String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'tarsus');

const bool kMersin = kFlavor == 'mersin';
const bool kTarsus = !kMersin;

// Sadece geliştirici derlemesinde yönetici ekranı açılır:
// flutter build apk --flavor tarsus --dart-define=ADMIN=true
const bool kAdminSurumu = bool.fromEnvironment('ADMIN');
