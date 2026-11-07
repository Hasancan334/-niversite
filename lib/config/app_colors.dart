import 'package:flutter/material.dart';
import 'flavor.dart';

class AppColors {
  // Ana Renkler
  static const Color primary = kAmsterdam ? Color(0xFFBC0031) : Color(0xFF182850);      // Tarsus Üni lacivert
  static const Color primaryDark = kAmsterdam ? Color(0xFF2B2B2B) : Color(0xFFE87000);  // Tarsus Üni turuncu
  static const Color primaryLight = kAmsterdam ? Color(0xFFE8899F) : Color(0xFFF5A55C); // Açık turuncu

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);

  // Vurgu Renkleri
  static const Color accent = kAmsterdam ? Color(0xFF2B2B2B) : Color(0xFFE87000);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
}