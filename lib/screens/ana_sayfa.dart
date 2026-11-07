import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_colors.dart';

import '../config/university_config.dart';
import '../services/ad_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/haber_slider.dart';
import 'yemek_listesi_screen.dart';
import 'is_ilanlari_screen.dart';
import 'mekanlar_screen.dart';
import 'duyurular_screen.dart';
import 'ders_notlari_screen.dart';
import 'kulupler_screen.dart';
import 'sohbet_screen.dart';
import 'admin_screen.dart';
import '../config/flavor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hakkinda_screen.dart';
class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  InterstitialAd? _interstitialAd;
  int _navigationCounter = 0;

  @override
  void initState() {
    super.initState();

    _loadInterstitialAd();
  }

  DateTime _sonReklam = DateTime.now(); // açılışta reklam çıkmasın

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialAd() {
    _navigationCounter++;
    final aradanGecen = DateTime.now().difference(_sonReklam);

    if (_navigationCounter % 5 == 0 &&
        aradanGecen.inMinutes >= 1 &&
        _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _sonReklam = DateTime.now();
    }
  }

  void _navigateWithAd(BuildContext context, Widget screen) {
    _showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

// ... mevcut importlar aynı kalsın ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                UniversityConfig.logoAsset,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UniversityConfig.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onLongPress: kAdminSurumu
                      ? () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AdminScreen()))
                      : null,
                  child: Text(
                    UniversityConfig.appName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8036E0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          HaberSlider(onTap: () => _navigateWithAd(context, DuyurularScreen())),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.28, // Daha dengeli ve kompakt
                children: [_buildMenuButton(
                  context,
                  icon: '🎓',
                  title: 'Öğrenci\nOtomasyonu',
                  onTap: () async {
                    final url = Uri.parse(UniversityConfig.obsUrl);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),

                  _buildMenuButton(
                    context,
                    icon: '💸',
                    title: 'Harçlık\nKapısı',
                    onTap: () => _navigateWithAd(context, IsIlanlariScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '🍽️',
                    title: 'Günlük\nYemek Menüsü',
                    onTap: () => _navigateWithAd(context, YemekListesiScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '📚',
                    title: 'Ders\nNotları',
                    onTap: () => _navigateWithAd(context, DersNotlariScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '👥',
                    title: 'Kulüpler',
                    onTap: () => _navigateWithAd(context, KuluplerScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '💬',
                    title: 'Goygoy\nOdası',
                    onTap: () => _navigateWithAd(context, SohbetScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '📢',
                    title: 'Duyurular\n& Etkinlikler',
                    onTap: () => _navigateWithAd(context, DuyurularScreen()),
                  ),_buildMenuButton(
                    context,
                    icon: '🍔',
                    title: 'Anlaşmalı\nMekanlar',
                    onTap: () => _navigateWithAd(context, MekanlarScreen()),
                  ),

                  _buildMenuButton(
                    context,
                    icon: 'ℹ️',
                    title: 'Hakkımızda',
                    onTap: () => _navigateWithAd(context, HakkindaScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, {
        required String icon,
        required String title,
        required VoidCallback onTap,
      }) {
    const primaryColor = Color(0xFF8036E0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primaryColor.withOpacity(0.18),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container (hafif arka planlı)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}