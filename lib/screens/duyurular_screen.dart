import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../services/firebase_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class DuyurularScreen extends StatefulWidget {
  @override
  _DuyurularScreenState createState() => _DuyurularScreenState();
}

class _DuyurularScreenState extends State<DuyurularScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseService _firebaseService = FirebaseService();
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBannerAd(); // YENİ!
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd()
      ..load().then((_) {
        setState(() {
          _isBannerAdLoaded = true;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerAd?.dispose(); // YENİ!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DUYURULAR & ETKİNLİKLER'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          tabs: [
            Tab(text: 'Hepsi'),
            Tab(text: 'Duyurular'),
            Tab(text: 'Etkinlikler'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(null),
                _buildList('duyuru'),
                _buildList('etkinlik'),
              ],
            ),
          ),

          // BANNER REKLAM - YENİ!
          if (_isBannerAdLoaded && _bannerAd != null)
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
  Widget _buildList(String? tip) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getDuyurular(tip: tip),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                SizedBox(height: 16),
                Text('Bir hata oluştu', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  tip == null
                      ? 'Henüz duyuru veya etkinlik yok'
                      : tip == 'duyuru'
                      ? 'Henüz duyuru yok'
                      : 'Henüz etkinlik yok',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var item = snapshot.data!.docs[index];
            bool isEtkinlik = _f(item, 'tip') == 'etkinlik';

            return Card(
              margin: EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => _showDetay(context, item),
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FOTOĞRAF (Sadece etkinliklerde)
                    if (isEtkinlik &&
                        _f(item, 'fotograf') != null &&
                        _f(item, 'fotograf') != '')
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: _f(item, 'fotograf'),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 150,
                            color: AppColors.background,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 150,
                            color: AppColors.background,
                            child: Icon(Icons.event, size: 48),
                          ),
                        ),
                      ),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TİP BADGE
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isEtkinlik
                                  ? AppColors.accent.withOpacity(0.1)
                                  : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isEtkinlik ? Icons.event : Icons.campaign,
                                  size: 14,
                                  color: isEtkinlik
                                      ? AppColors.accent
                                      : AppColors.primary,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  isEtkinlik ? 'ETKİNLİK' : 'DUYURU',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isEtkinlik
                                        ? AppColors.accent
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          // BAŞLIK
                          Text(
                            _f(item, 'baslik') ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          // TARİH & YER
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 6),
                              Text(
                                _formatDate(_f(item, 'tarih')),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (isEtkinlik &&
                                  _f(item, 'yer') != null &&
                                  _f(item, 'yer') != '') ...[
                                SizedBox(width: 16),
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _f(item, 'yer'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 8),

                          // İÇERİK (Önizleme)
                          Text(
                            _f(item, 'icerik') ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Alan eksikse hata vermesin (Firestore'da olmayan alan -> null)
  dynamic _f(DocumentSnapshot doc, String key) {
    final data = doc.data();
    if (data is Map<String, dynamic>) return data[key];
    return null;
  }

  String _formatDate(dynamic tarih) {
    if (tarih == null) return '';

    try {
      if (tarih is Timestamp) {
        return DateFormat('d MMMM y', 'tr_TR').format(tarih.toDate());
      } else if (tarih is String) {
        return tarih;
      }
    } catch (e) {
      return tarih.toString();
    }

    return '';
  }

  void _showDetay(BuildContext context, DocumentSnapshot item) {
    bool isEtkinlik = _f(item, 'tip') == 'etkinlik';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FOTOĞRAF
                    if (isEtkinlik &&
                        _f(item, 'fotograf') != null &&
                        _f(item, 'fotograf') != '')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: _f(item, 'fotograf'),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    SizedBox(height: 16),

                    // TİP BADGE
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isEtkinlik
                            ? AppColors.accent.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEtkinlik ? Icons.event : Icons.campaign,
                            size: 16,
                            color: isEtkinlik
                                ? AppColors.accent
                                : AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isEtkinlik ? 'ETKİNLİK' : 'DUYURU',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isEtkinlik
                                  ? AppColors.accent
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // BAŞLIK
                    Text(
                      _f(item, 'baslik') ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16),

                    // TARİH
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatDate(_f(item, 'tarih')),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // YER (Sadece etkinlik)
                    if (isEtkinlik &&
                        _f(item, 'yer') != null &&
                        _f(item, 'yer') != '') ...[
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _f(item, 'yer'),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: 20),

                    // İÇERİK
                    Text(
                      _f(item, 'icerik') ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),

                    // LİNK BUTONU
                    if (_f(item, 'link') != null && _f(item, 'link') != '') ...[
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final url = _f(item, 'link');
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          icon: Icon(Icons.open_in_new),
                          label: Text('Detaylı Bilgi'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}