import 'package:flutter/material.dart';
import '../l10n/dil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_colors.dart';
import '../services/firebase_service.dart';
import '../services/ad_service.dart';
import '../widgets/banner_ad_widget.dart';

class YemekListesiScreen extends StatefulWidget {
  @override
  _YemekListesiScreenState createState() => _YemekListesiScreenState();
}

class _YemekListesiScreenState extends State<YemekListesiScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
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

  static const _aylar = {
    'ocak': 1, 'şubat': 2, 'mart': 3, 'nisan': 4, 'mayıs': 5, 'haziran': 6,
    'temmuz': 7, 'ağustos': 8, 'eylül': 9, 'ekim': 10, 'kasım': 11,
    'aralık': 12,
    'april': 4, 'september': 9, 'november': 11,
    'januari': 1, 'februari': 2, 'maart': 3, 'mei': 5, 'juni': 6, 'juli': 7,
    'augustus': 8, 'oktober': 10, 'december': 12,
    'january': 1, 'february': 2, 'march': 3, 'may': 5, 'june': 6, 'july': 7,
    'august': 8, 'october': 10,
  };

  /// Dokümanın gününü bulur: önce "sira" (20261103), yoksa "tarih" metni
  /// ("03.11.2026" ya da "3 Kasım Pazartesi"). Bulunamazsa null.
  DateTime? _tarihBul(QueryDocumentSnapshot d, DateTime bugun) {
    final m = d.data() as Map<String, dynamic>;

    final sira = m['sira'];
    if (sira is num) {
      final v = sira.toInt();
      final y = v ~/ 10000, ay = (v ~/ 100) % 100, g = v % 100;
      if (y > 2000 && ay >= 1 && ay <= 12 && g >= 1 && g <= 31) {
        return DateTime(y, ay, g);
      }
    }

    final t = (m['tarih'] ?? '').toString();
    final r1 = RegExp(r'(\d{1,2})[./-](\d{1,2})[./-](\d{4})').firstMatch(t);
    if (r1 != null) {
      return DateTime(int.parse(r1.group(3)!), int.parse(r1.group(2)!),
          int.parse(r1.group(1)!));
    }
    final r2 = RegExp(r'(\d{1,2})\s+([A-Za-zÇĞİÖŞÜçğıöşü]+)').firstMatch(t);
    if (r2 != null) {
      final ay = _aylar[r2.group(2)!.toLowerCase()];
      if (ay != null) {
        final g = int.parse(r2.group(1)!);
        // Yıl: bugüne en yakın olanı seç (yıl sonu/başı geçişi için)
        DateTime enYakin = DateTime(bugun.year, ay, g);
        for (final y in [bugun.year - 1, bugun.year + 1]) {
          final c = DateTime(y, ay, g);
          if (c.difference(bugun).abs() < enYakin.difference(bugun).abs()) {
            enYakin = c;
          }
        }
        return enYakin;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(tx('YEMEK LİSTESİ', 'MENU', 'MENU')),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getYemekler(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: AppColors.error),
                        SizedBox(height: 16),
                        Text(
                          tx('Bir hata oluştu', 'Er is een fout opgetreden', 'An error occurred'),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          tx('Lütfen daha sonra tekrar deneyin', 'Probeer het later opnieuw', 'Please try again later'),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          tx('Henüz yemek listesi eklenmemiş', 'Er is nog geen menu toegevoegd', 'No menu has been added yet'),
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Her dokümanın tarihini bul (sira -> tarih metni)
                final simdi = DateTime.now();
                final bugun = DateTime(simdi.year, simdi.month, simdi.day);
                final haftaBasi =
                bugun.subtract(Duration(days: bugun.weekday - 1));
                final haftaSonu = haftaBasi.add(Duration(days: 6));

                final liste = <MapEntry<DateTime?, QueryDocumentSnapshot>>[];
                for (final d in snapshot.data!.docs) {
                  liste.add(MapEntry(_tarihBul(d, bugun), d));
                }
                // Tarihi bilinenler sıralı; bilinmeyenler en sonda
                liste.sort((x, y) {
                  if (x.key == null && y.key == null) return 0;
                  if (x.key == null) return 1;
                  if (y.key == null) return -1;
                  return x.key!.compareTo(y.key!);
                });
                // Sadece bu haftanın (Pzt-Paz) günleri
                final gorunen = liste.where((e) {
                  final t = e.key;
                  if (t == null) return false;
                  return !t.isBefore(haftaBasi) && !t.isAfter(haftaSonu);
                }).toList();

                if (gorunen.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        tx('Bu hafta için yemek listesi henüz eklenmemiş', 'Voor deze week is nog geen menu toegevoegd', 'No menu has been added for this week yet'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: gorunen.length,
                  itemBuilder: (context, index) {
                    var yemek = gorunen[index].value;
                    final bugunMu = gorunen[index].key == bugun;
                    final anaRenk =
                    bugunMu ? Colors.red.shade700 : AppColors.primary;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: bugunMu
                            ? Colors.red.withOpacity(0.07)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: bugunMu
                            ? Border.all(color: Colors.red.shade700, width: 2)
                            : Border(
                          bottom: BorderSide(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TARİH
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: anaRenk,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                yemek['tarih'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: anaRenk,
                                ),
                              ),
                              if (bugunMu) ...[
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    tx('BUGÜN', 'VANDAAG', 'TODAY'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 8),

                          // YEMEK (virgülle ayrılmış, tek satır)
                          Text(
                            (yemek['yemek'] ?? '').replaceAll('\n', ', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                            maxLines: bugunMu ? 4 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}