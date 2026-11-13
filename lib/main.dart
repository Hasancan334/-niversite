import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tarsus_genc/screens/notification_service.dart';
import 'config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/university_config.dart';
import 'config/flavor.dart';
import 'l10n/dil.dart';
import 'services/consent_service.dart';
import 'screens/karsilama_screen.dart';

import 'screens/ana_sayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tarih biçimleri (tr/nl/en) ve kayıtlı dil
  await initializeDateFormatting();
  await Dil.yukle();

  // Firebase başlat
  await Firebase.initializeApp();

  // Tarsus/Mersin: AdMob eskisi gibi hemen başlar.
  // Amsterdam/Köln: AdMob, UMP onayı alındıktan sonra (canRequestAds) başlar.
  if (!kYabanci) {
    await ConsentService.onaysizBaslat();
  }
  await NotificationService.initialize();  // YENİ!


  runApp(MyApp());

  if (kYabanci) {
    ConsentService.amsterdamBaslat();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dil değişince (Dil.surum artınca) uygulama baştan çizilir
    return ValueListenableBuilder<int>(
      valueListenable: Dil.surum,
      builder: (context, _, __) => MaterialApp(
      key: ValueKey(Dil.surum.value),
      title: UniversityConfig.fullName,

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 4,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: (kYabanci && !Dil.secildiMi) ? KarsilamaScreen() : AnaSayfa(),
    ));
  }
}