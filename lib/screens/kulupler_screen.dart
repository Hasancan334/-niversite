import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../models/kulupler_data.dart';
import '../widgets/banner_ad_widget.dart';

class KuluplerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text('KULÜPLER'),
      ),
      body: ListView.builder(
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
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(whatsappLink))) {
                  await launchUrl(
                    Uri.parse(whatsappLink),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}