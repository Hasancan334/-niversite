import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../config/flavor.dart';
import '../l10n/dil.dart';
import '../models/kulupler_data.dart';
import '../models/yerel_data.dart';
import '../widgets/banner_ad_widget.dart';

Future<void> _linkAc(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class KuluplerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(tx('KULÜPLER', 'VERENIGINGEN', 'STUDENT CLUBS', 'VEREINE & GRUPPEN')),
      ),
      body: kYabanci ? _uvaBody() : _turkceBody(),
    );
  }

  // ---- Amsterdam: kategorilere ayrılmış topluluklar (resmi web/Instagram linkleri)
  IconData _linkIkonu(String url) {
    if (url.contains('instagram.com')) return Icons.camera_alt_outlined;
    if (url.contains('facebook.com')) return Icons.facebook;
    return Icons.language;
  }

  Widget _uvaBody() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            tx(
              '',
              'Ontdek verenigingen en studentenorganisaties. Tik op een naam om de website of het social-mediakanaal te openen.',
              'Discover student associations and organisations. Tap a name to open their website or social media page.',
              'Entdecke Vereine und studentische Gruppen. Tippe auf einen Namen, um die Website zu öffnen.',
            ),
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        ...YerelData.vereine.map((cat) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(cat.icon, color: AppColors.primary),
              title: Text(
                yx(cat.nl, cat.en),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${cat.items.length}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              children: cat.items.map((link) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Icon(_linkIkonu(link.url),
                      color: AppColors.primary, size: 22),
                  title: Text(
                    link.naam,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    yx(link.nl, link.en),
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
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

  // ---- Türkiye (tarsus, mersin): WhatsApp grupları
  Widget _turkceBody() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: KuluplerData.kulupler.length,
      itemBuilder: (context, index) {
        String kulupAdi = KuluplerData.kulupler.keys.elementAt(index);
        String whatsappLink = KuluplerData.kulupler[kulupAdi]!;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.groups,
                color: AppColors.success,
              ),
            ),
            title: Text(
              kulupAdi,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'WhatsApp grubuna katıl',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.success,
            ),
            onTap: () => _linkAc(whatsappLink),
          ),
        );
      },
    );
  }
}
