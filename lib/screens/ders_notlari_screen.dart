import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../widgets/banner_ad_widget.dart';
import '../models/fakulte_data.dart';

class DersNotlariScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text('DERS NOTLARI'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: FakulteData.fakulteler.length,
        itemBuilder: (context, index) {
          String fakulteAdi = FakulteData.fakulteler.keys.elementAt(index);
          Map<String, String> bolumler =
          FakulteData.fakulteler[fakulteAdi]!;

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
                  onTap: () async {
                    final url = entry.value;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}