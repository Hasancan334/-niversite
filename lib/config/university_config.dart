import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'flavor.dart';

class UniversityConfig {
  static const String name = kAmsterdam
      ? "Universiteit van Amsterdam"
      : (kMersin ? "Mersin Üniversitesi" : "Tarsus Üniversitesi");
  static const String appName =
      kAmsterdam ? "Studentengids Amsterdam – UvA" : "Genç Mobil";
  static const String fullName = kAmsterdam
      ? "Studentengids Amsterdam – UvA"
      : (kMersin
          ? "Mersin Üniversitesi Genç Mobil"
          : "Tarsus Üniversitesi Genç Mobil");

  // Öğrenci otomasyonu / portal adresi (Amsterdam: Canvas giriş sayfası)
  static const String obsUrl = kAmsterdam
      ? 'https://login.canvas.uva.nl/'
      : (kMersin ? 'https://obs.mersin.edu.tr' : 'https://obs.tarsus.edu.tr');

  // Ana sayfadaki logo
  static const String logoAsset = kAmsterdam
      ? 'assets/images/amsterdam_logo.png'
      : (kMersin ? 'assets/images/mersin_logo.jpeg' : 'assets/images/1024.png');

  static const Color primaryColor = AppColors.primary;
  static const Color accentColor = AppColors.accent;

  // Firebase Collection Names
  static const String mekanlarCollection = 'mekanlar';
  static const String yemeklerCollection = 'yemekler';
  static const String duyurularCollection = 'duyuru_etkinlik';
}
