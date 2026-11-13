import 'package:flutter/material.dart';
import 'flavor.dart';

class AppColors {
  // Ana Renkler
  // Köln: kendi seçtiğimiz petrol mavisi (üniversitenin kurumsal renklerini taklit etmiyoruz)
  static const Color primary = kAmsterdam ? Color(0xFFBC0031) : (kKoeln ? Color(0xFF0E5A73) : Color(0xFF182850));      // Tarsus Üni lacivert
  static const Color primaryDark = kAmsterdam ? Color(0xFF2B2B2B) : (kKoeln ? Color(0xFF263238) : Color(0xFFE87000));  // Tarsus Üni turuncu
  static const Color primaryLight = kAmsterdam ? Color(0xFFE8899F) : (kKoeln ? Color(0xFF7FB3C4) : Color(0xFFF5A55C)); // Açık turuncu

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);

  // Vurgu Renkleri
  static const Color accent = kAmsterdam ? Color(0xFF2B2B2B) : (kKoeln ? Color(0xFF263238) : Color(0xFFE87000));
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
}