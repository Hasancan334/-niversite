import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../config/flavor.dart';
import '../l10n/dil.dart';
import '../widgets/banner_ad_widget.dart';
import '../models/fakulte_data.dart';
import '../models/yerel_data.dart';

Future<void> _linkAc(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class DersNotlariScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(tx('DERS NOTLARI', 'STUDIEMATERIAAL', 'STUDY MATERIALS', 'STUDIUM & BIBLIOTHEK')),
      ),
      body: kYabanci ? _uvaBody() : _turkceBody(),
    );
  }

  // ---- Amsterdam: resmi UvA kaynakları (Canvas, kütüphane, dernekler, destek)
  Widget _uvaBody() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            tx(
              '',
              'Handige links voor je studie. Voor inloggen heb je je UvAnetID nodig.',
              kKoeln
                  ? 'Useful links for your studies. You need your university account to log in.'
                  : 'Useful links for your studies. You need your UvAnetID to log in.',
              'Nützliche Links für dein Studium. Zum Einloggen brauchst du deinen Uni-Account.',
            ),
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        ...YerelData.quellen.map((cat) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(cat.icon, color: AppColors.primary),
              title: Text(
                yx(cat.nl, cat.en),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: cat.items.map((link) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  // Amsterdam verisinde ad = açıklama; Köln'de ad ve açıklama ayrı
                  title: Text(
                    kKoeln ? link.naam : yx(link.nl, link.en),
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: kKoeln
                      ? Text(yx(link.nl, link.en),
                          style: TextStyle(fontSize: 12))
                      : null,
                  trailing: Icon(Icons.open_in_new,
                      size: 18, color: AppColors.primary),
                  onTap: () => _linkAc(link.url),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  // ---- Türkiye (tarsus, mersin): fakülte/bölüm klasörleri
  Widget _turkceBody() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: FakulteData.fakulteler.length,
      itemBuilder: (context, index) {
        String fakulteAdi = FakulteData.fakulteler.keys.elementAt(index);
        Map<String, String> bolumler = FakulteData.fakulteler[fakulteAdi]!;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Icon(
              Icons.school,
              color: AppColors.primary,
            ),
            title: Text(
              fakulteAdi,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: bolumler.entries.map((entry) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.primary,
                ),
                onTap: () => _linkAc(entry.value),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
