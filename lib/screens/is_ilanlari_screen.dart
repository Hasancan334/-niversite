import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../widgets/banner_ad_widget.dart';

/// Firestore koleksiyonu: is_ilanlari
/// Alanlar:
///   aktif    (boolean)  -> true olanlar görünür
///   tip      (string)   -> 'gunluk' veya 'yari_zamanli'
///   baslik   (string)   -> "Garson aranıyor"
///   sirket   (string)   -> işyeri / veren kişi (opsiyonel)
///   konum    (string)   -> "Tarsus Merkez" (opsiyonel)
///   ucret    (string)   -> "Günlük 800 TL" (opsiyonel)
///   tarih    (string)   -> "5 Kasım" / "Her hafta sonu" (opsiyonel)
///   aciklama (string)   -> detay metni
///   telefon  (string)   -> "05xx xxx xx xx" (opsiyonel)
///   whatsapp (string)   -> "905xxxxxxxxx" (opsiyonel, başında + olmadan)
///   link     (string)   -> başvuru linki (opsiyonel)
///   eklenme  (timestamp)-> sıralama için (opsiyonel, yeni olan üstte)
class IsIlanlariScreen extends StatelessWidget {
  static const String koleksiyon = 'is_ilanlari';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BannerAdWidget(),
        appBar: AppBar(
          title: Text('HARÇLIK KAPISI'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: '⚡ Günlük İşler'),
              Tab(text: '🕒 Yarı Zamanlı'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _IlanListesi(tip: 'gunluk'),
            _IlanListesi(tip: 'yari_zamanli'),
          ],
        ),
      ),
    );
  }
}

class _IlanListesi extends StatelessWidget {
  final String tip;
  _IlanListesi({required this.tip});

  dynamic _f(DocumentSnapshot doc, String key) {
    final data = doc.data();
    if (data is Map<String, dynamic>) return data[key];
    return null;
  }

  String _s(DocumentSnapshot doc, String key) {
    final v = _f(doc, key);
    if (v == null) return '';
    if (v is Timestamp) {
      final d = v.toDate();
      return '${d.day}.${d.month}.${d.year}';
    }
    return v.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(IsIlanlariScreen.koleksiyon)
          .where('aktif', isEqualTo: true)
          .where('tip', isEqualTo: tip)
          .snapshots(),
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

        final docs = [...(snapshot.data?.docs ?? <QueryDocumentSnapshot>[])];
        if (docs.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_outline,
                      size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    'Şu an bu kategoride ilan yok.\nSık sık göz at, yeni ilanlar ekleniyor!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        // Yeni eklenen üstte (eklenme alanı varsa)
        docs.sort((a, b) {
          final x = _f(a, 'eklenme');
          final y = _f(b, 'eklenme');
          if (x is Timestamp && y is Timestamp) return y.compareTo(x);
          if (x is Timestamp) return -1;
          if (y is Timestamp) return 1;
          return 0;
        });

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) => _kart(context, docs[i]),
        );
      },
    );
  }

  Widget _bilgi(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kart(BuildContext context, DocumentSnapshot doc) {
    final baslik = _s(doc, 'baslik');
    final sirket = _s(doc, 'sirket');
    final konum = _s(doc, 'konum');
    final ucret = _s(doc, 'ucret');
    final tarih = _s(doc, 'tarih');
    final aciklama = _s(doc, 'aciklama');

    return Card(
      margin: EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _detay(context, doc),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(baslik,
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (sirket.isNotEmpty) _bilgi(Icons.storefront, sirket),
              if (konum.isNotEmpty) _bilgi(Icons.location_on, konum),
              if (tarih.isNotEmpty) _bilgi(Icons.calendar_today, tarih),
              if (ucret.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('💰 $ucret',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success)),
                  ),
                ),
              if (aciklama.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: AppColors.textPrimary)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _ac(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _detay(BuildContext context, DocumentSnapshot doc) {
    final baslik = _s(doc, 'baslik');
    final sirket = _s(doc, 'sirket');
    final konum = _s(doc, 'konum');
    final ucret = _s(doc, 'ucret');
    final tarih = _s(doc, 'tarih');
    final aciklama = _s(doc, 'aciklama');
    final telefon = _s(doc, 'telefon');
    final whatsapp = _s(doc, 'whatsapp').replaceAll(RegExp(r'[^0-9]'), '');
    final link = _s(doc, 'link');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(baslik,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              if (sirket.isNotEmpty) _bilgi(Icons.storefront, sirket),
              if (konum.isNotEmpty) _bilgi(Icons.location_on, konum),
              if (tarih.isNotEmpty) _bilgi(Icons.calendar_today, tarih),
              if (ucret.isNotEmpty) _bilgi(Icons.payments, ucret),
              if (aciklama.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(aciklama, style: TextStyle(fontSize: 15, height: 1.5)),
              ],
              SizedBox(height: 20),
              if (telefon.isNotEmpty)
                _buton(Icons.call, 'Ara: $telefon', AppColors.primary,
                        () => _ac('tel:${telefon.replaceAll(' ', '')}')),
              if (whatsapp.isNotEmpty)
                _buton(Icons.chat, 'WhatsApp ile yaz', Color(0xFF25D366),
                        () => _ac('https://wa.me/$whatsapp')),
              if (link.isNotEmpty)
                _buton(Icons.open_in_new, 'Başvuru linki', AppColors.accent,
                        () => _ac(link)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buton(IconData icon, String text, Color color, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(text, style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}