import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';

class HakkindaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BİZ KİMİZ & İLETİŞİM'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LOGO/İKON
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                size: 64,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 24),

            // UYGULAMA ADI
            Text(
              'Tarsus Üniversitesi\nGenç Mobil',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Versiyon 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: 32),

            // AÇIKLAMA
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tarsus Üniversitesi öğrencileri için geliştirilmiş mobil uygulamadır. '
                    'Günlük yemek listesi, anlaşmalı mekanlar, ders notları ve daha fazlasını içerir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: 32),

            // GELİŞTİRİCİ BİLGİSİ
            Text(
              'Geliştirici Şirket:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            Text(
              'Bumerang Yazılım',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),



            SizedBox(height: 32),

            // İLETİŞİM BUTONLARI
            Text(
              'İletişim:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  icon: Icons.phone,
                  label: 'WhatsApp',
                  color: AppColors.success,
                  onTap: () async {
                    final url = 'https://wa.me/905383643971';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                SizedBox(width: 16),
                _buildSocialButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: AppColors.error,
                  onTap: () async {
                    final url = 'mailto:mobil.apps.hasancan33@gmail.com';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 40),

            // TELIF HAKKI
            Text(
              '© 2026 Bumerang Yazılım\nTüm hakları saklıdır.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}