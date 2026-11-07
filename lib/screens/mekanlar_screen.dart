import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_colors.dart';
import '../services/user_service.dart';
import '../services/firebase_service.dart';
import '../services/ad_service.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/kullanim_service.dart';

class MekanlarScreen extends StatefulWidget {
  @override
  _MekanlarScreenState createState() => _MekanlarScreenState();
}

class _MekanlarScreenState extends State<MekanlarScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  static const Color primaryColor = Color(0xFF8036E0);

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
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
    _bannerAd?.dispose();
    super.dispose();
  }

  String _getMekanData(DocumentSnapshot mekan, String field) {
    try {
      Map<String, dynamic> data = mekan.data() as Map<String, dynamic>;
      if (!data.containsKey(field)) return '';
      var value = data[field];
      if (value == null) return '';
      if (value is List && value.isNotEmpty) return value[0].toString();
      return value.toString();
    } catch (e) {
      print('Error getting field $field: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Anlaşmalı Mekanlar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMekanlar(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildEmptyState(
                    icon: Icons.error_outline,
                    text: 'Bir hata oluştu',
                    color: Colors.redAccent,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    icon: Icons.store_outlined,
                    text: 'Henüz anlaşmalı mekan eklenmemiş',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final mekan = snapshot.data!.docs[index];
                    return _buildMekanCard(mekan);
                  },
                );
              },
            ),
          ),
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

  Widget _buildEmptyState({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: color ?? Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMekanCard(DocumentSnapshot mekan) {
    final isim = mekan['isim'] ?? '';
    final kategori = mekan['kategori'] ?? '';
    final fotograf = mekan['fotograf'] ?? '';
    final indirimOrani = mekan['indirimOrani'] ?? '';
    final indirimKodu = mekan['indirimKodu'] ?? '';
    final aciklama = mekan['aciklama'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryColor.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => _showMekanDetay(context, mekan),
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fotoğraf
              if (fotograf.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: CachedNetworkImage(
                    imageUrl: fotograf,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 170,
                      color: const Color(0xFFF3F0FA),
                      child: const Center(
                        child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 170,
                      color: const Color(0xFFF3F0FA),
                      child: Icon(Icons.store_outlined, size: 48, color: Colors.grey[400]),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // İsim + Kategori
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            isim,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        if (kategori.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              kategori,
                              style: const TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // İndirim kutusu (sade)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: primaryColor.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_offer_outlined, color: primaryColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$indirimOrani İndirim',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Kod: $indirimKodu',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: primaryColor.withOpacity(0.7), size: 22),
                        ],
                      ),
                    ),

                    if (aciklama.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        aciklama,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMekanDetay(BuildContext context, DocumentSnapshot mekan) {
    final KullanimService _kullanimService = KullanimService();

    String isim = _getMekanData(mekan, 'isim');
    String kategori = _getMekanData(mekan, 'kategori');
    String fotograf = _getMekanData(mekan, 'fotograf');
    String indirimOrani = _getMekanData(mekan, 'indirimOrani');
    String indirimKodu = _getMekanData(mekan, 'indirimKodu');
    String aciklama = _getMekanData(mekan, 'aciklama');
    String adres = _getMekanData(mekan, 'adres');
    String telefon = _getMekanData(mekan, 'telefon');
    String googleMapsLink = _getMekanData(mekan, 'googleMapsLink');

    Map<String, dynamic> data = mekan.data() as Map<String, dynamic>;
    double? mekanLat = data['latitude']?.toDouble();
    double? mekanLon = data['longitude']?.toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fotoğraf
                    if (fotograf.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: fotograf,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // İsim & Kategori
                    Text(
                      isim,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    if (kategori.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        kategori,
                        style: const TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // İndirim kartı
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$indirimOrani İndirim',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              indirimKodu,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Kasada bu kodu söyleyin',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // İndirimi Kullandım butonu
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // ... mevcut tüm mantık aynı kalacak (konum, kayıt vs.)
                          // Buraya senin orijinal onPressed kodunu olduğu gibi koyabilirsin
                          String userId = await UserService.getUserId();
                          bool bugunKullanildi = await _kullanimService.bugunKullanimVarMi(mekan.id, userId);

                          if (bugunKullanildi) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.info_outline, color: primaryColor),
                                    SizedBox(width: 8),
                                    Text('Zaten Kullandınız'),
                                  ],
                                ),
                                content: const Text(
                                  'Bugün bu mekanda zaten indirim kullandınız. Yarın tekrar kullanabilirsiniz!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tamam'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          // Konum kontrolü (orijinal mantık)
                          if (mekanLat != null && mekanLon != null) {
                            bool izinVerildi = await LocationService.requestPermission();
                            if (!izinVerildi) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Konum İzni Gerekli'),
                                  content: const Text('İndirimi kullanmak için konum izni vermelisiniz.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            Position? position = await LocationService.getCurrentLocation();
                            if (position == null) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Konum Alınamadı'),
                                  content: const Text('Konumunuz alınamadı. Lütfen konum servisinizi açın.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            double mesafe = LocationService.calculateDistance(
                              position.latitude,
                              position.longitude,
                              mekanLat,
                              mekanLon,
                            );

                            if (mesafe > 100) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.location_off, color: Colors.redAccent),
                                      SizedBox(width: 8),
                                      Text('Çok Uzaksınız'),
                                    ],
                                  ),
                                  content: Text(
                                    'İndirimi kullanmak için mekana yakın olmalısınız.\n\nMesafe: ${mesafe.toInt()} metre',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                          }

                          Position? currentPosition = await LocationService.getCurrentLocation();
                          if (currentPosition == null) {
                            currentPosition = Position(
                              latitude: 0,
                              longitude: 0,
                              timestamp: DateTime.now(),
                              accuracy: 0,
                              altitude: 0,
                              heading: 0,
                              speed: 0,
                              speedAccuracy: 0,
                              altitudeAccuracy: 0,
                              headingAccuracy: 0,
                            );
                          }

                          bool basarili = await _kullanimService.kullanimKaydet(
                            mekanId: mekan.id,
                            mekanAdi: isim,
                            userId: userId,
                            indirimOrani: indirimOrani,
                            latitude: currentPosition.latitude,
                            longitude: currentPosition.longitude,
                          );

                          if (basarili) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 28),
                                    SizedBox(width: 10),
                                    Text('Başarılı!'),
                                  ],
                                ),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('İndirim kullanımınız kaydedildi.'),
                                    SizedBox(height: 12),
                                    Text(
                                      '🎉 Afiyet olsun!',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Tamam'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Hata'),
                                content: const Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tamam'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 22),
                        label: const Text(
                          'İndirimi Kullandım',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bilgi notu
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: primaryColor, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'İndirimi aldıktan sonra bu butona basın',
                              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Açıklama
                    if (aciklama.isNotEmpty) ...[
                      const Text(
                        'Açıklama',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        aciklama,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Adres & Telefon
                    if (adres.isNotEmpty) _buildInfoRow(Icons.location_on_outlined, 'Adres', adres),
                    if (telefon.isNotEmpty) _buildInfoRow(Icons.phone_outlined, 'Telefon', telefon),

                    const SizedBox(height: 24),

                    // Aksiyon butonları
                    Row(
                      children: [
                        if (googleMapsLink.isNotEmpty)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(googleMapsLink))) {
                                  await launchUrl(
                                    Uri.parse(googleMapsLink),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              icon: const Icon(Icons.directions_outlined, size: 20),
                              label: const Text('Yol Tarifi'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: BorderSide(color: primaryColor.withOpacity(0.4)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        if (googleMapsLink.isNotEmpty && telefon.isNotEmpty)
                          const SizedBox(width: 12),
                        if (telefon.isNotEmpty)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final url = 'tel:$telefon';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                              icon: const Icon(Icons.phone_outlined, size: 20),
                              label: const Text('Ara'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}