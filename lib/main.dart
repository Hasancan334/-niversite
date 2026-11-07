import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarsus_genc/screens/notification_service.dart';
import 'config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/university_config.dart';

import 'screens/ana_sayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlat
  await Firebase.initializeApp();

  // AdMob başlat
  await MobileAds.instance.initialize();
  await NotificationService.initialize();  // YENİ!


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: AnaSayfa(),
    );
  }
}