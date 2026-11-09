import 'package:flutter/material.dart';
import '../l10n/dil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_colors.dart';

import '../config/university_config.dart';
import '../services/ad_service.dart';
import '../services/consent_service.dart';
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
import 'karsilama_screen.dart';
import '../config/flavor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hakkinda_screen.dart';
import 'uva_ekstra_screens.dart';
import 'ayarlar_screen.dart';
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

    ConsentService.hazirOlunca(() {
      if (mounted) _loadInterstitialAd();
    });
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
        actions: [
          if (kAmsterdam)
            IconButton(
              tooltip: tx('Dil', 'Taal', 'Language'),
              icon: Icon(Icons.language, color: AppColors.primary),
              onPressed: () => dilSecimiGoster(context),
            ),
          if (kAmsterdam)
            IconButton(
              tooltip: tx('Ayarlar', 'Instellingen', 'Settings'),
              icon: Icon(Icons.settings_outlined, color: AppColors.primary),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AyarlarScreen())),
            ),
        ],
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
                      color: kAmsterdam ? AppColors.primary : Color(0xFF8036E0),
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
                  title: tx('Öğrenci\nOtomasyonu', 'Canvas &\nStudentenportaal', 'Canvas &\nStudent portal'),
                  onTap: () async {
                    final url = Uri.parse(UniversityConfig.obsUrl);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),

                  _buildMenuButton(
                    context,
                    icon: '💸',
                    title: tx('Harçlık\nKapısı', 'Bijbanen\n& klusjes', 'Student\njobs'),
                    onTap: () => _navigateWithAd(context, IsIlanlariScreen()),
                  ),
                  // UvA'da günlük yemekhane menüsü yok; sadece Türk flavor'larında
                  if (!kAmsterdam)
                  _buildMenuButton(
                    context,
                    icon: '🍽️',
                    title: tx('Günlük\nYemek Menüsü', 'Menu van\nde dag', 'Menu of\nthe day'),
                    onTap: () => _navigateWithAd(context, YemekListesiScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '📚',
                    title: tx('Ders\nNotları', 'Studie-\nmateriaal', 'Study\nmaterials'),
                    onTap: () => _navigateWithAd(context, DersNotlariScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '👥',
                    title: tx('Kulüpler', 'Verenigingen', 'Student\nclubs'),
                    onTap: () => _navigateWithAd(context, KuluplerScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '💬',
                    title: tx('Goygoy\nOdası', 'Studenten-\nchat', 'Student\nchat'),
                    onTap: () => _navigateWithAd(context, SohbetScreen()),
                  ),
                  _buildMenuButton(
                    context,
                    icon: '📢',
                    title: tx('Duyurular\n& Etkinlikler', 'Nieuws &\nEvenementen', 'News &\nEvents'),
                    onTap: () => _navigateWithAd(context, DuyurularScreen()),
                  ),
                  // Amsterdam'da anlaşmalı mekan yok; sadece Türk flavor'larında
                  if (!kAmsterdam)
                  _buildMenuButton(
                    context,
                    icon: '🍔',
                    title: tx('Anlaşmalı\nMekanlar', 'Partner-\nplekken', 'Partner\nplaces'),
                    onTap: () => _navigateWithAd(context, MekanlarScreen()),
                  ),

                  if (kAmsterdam) ...[
                    _buildMenuButton(
                      context,
                      icon: '📅',
                      title: tx('Akademik\nTakvim', 'Academische\nkalender', 'Academic\ncalendar'),
                      onTap: () => _navigateWithAd(context, AkademikTakvimScreen()),
                    ),
                    _buildMenuButton(
                      context,
                      icon: '🗺️',
                      title: tx('Kampüsler', 'Campussen\n& gebouwen', 'Campuses\n& buildings'),
                      onTap: () => _navigateWithAd(context, KampusScreen()),
                    ),
                    _buildMenuButton(
                      context,
                      icon: '🔗',
                      title: tx('Önemli\nLinkler', 'Handige\nlinks', 'Useful\nlinks'),
                      onTap: () => _navigateWithAd(context, OnemliLinklerScreen()),
                    ),
                  ],
                  _buildMenuButton(
                    context,
                    icon: 'ℹ️',
                    title: tx('Hakkımızda', 'Over\nons', 'About\nus'),
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