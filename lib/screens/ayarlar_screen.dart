// Amsterdam flavor'u: Ayarlar (dil + reklam gizlilik seçenekleri).
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../config/flavor.dart';
import '../l10n/dil.dart';
import '../services/consent_service.dart';
import 'karsilama_screen.dart';

// TODO Köln: kendi gizlilik politikası hazırlanınca adresini yaz (boşken satır gizli).
const String _gizlilikPolitikasiUrl = kKoeln
    ? ''
    : 'https://claude.ai/artifact/Q92sYX1EihTvRbrtKvTmrL';

class AyarlarScreen extends StatefulWidget {
  @override
  _AyarlarScreenState createState() => _AyarlarScreenState();
}

class _AyarlarScreenState extends State<AyarlarScreen> {
  late Future<bool> _gizlilikGerekli;

  @override
  void initState() {
    super.initState();
    _gizlilikGerekli = ConsentService.gizlilikSecenekleriGerekli();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tx('AYARLAR', 'INSTELLINGEN', 'SETTINGS', 'EINSTELLUNGEN')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.language, color: AppColors.primary),
              title: Text(tx('Dil', 'Taal', 'Language', 'Sprache')),
              subtitle: Text(Dil.kod == 'en'
                  ? 'English'
                  : (kKoeln ? 'Deutsch' : 'Nederlands')),
              onTap: () => dilSecimiGoster(context),
            ),
          ),
          if (_gizlilikPolitikasiUrl.isNotEmpty)
          Card(
            child: ListTile(
              leading: Icon(Icons.description_outlined, color: AppColors.primary),
              title: Text(tx('Gizlilik politikası', 'Privacybeleid',
                  'Privacy policy', 'Datenschutzerklärung')),
              trailing: Icon(Icons.open_in_new,
                  size: 18, color: AppColors.primary),
              onTap: () => launchUrl(Uri.parse(_gizlilikPolitikasiUrl),
                  mode: LaunchMode.externalApplication),
            ),
          ),
          // Sadece UMP "required" dediğinde görünür (AB/EER kullanıcıları)
          FutureBuilder<bool>(
            future: _gizlilikGerekli,
            builder: (context, snap) {
              if (snap.data != true) return SizedBox.shrink();
              return Card(
                child: ListTile(
                  leading:
                      Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: Text(tx('Gizlilik seçenekleri', 'Privacyopties',
                      'Privacy options', 'Datenschutzoptionen')),
                  subtitle: Text(tx(
                      'Reklam onayını değiştir',
                      'Wijzig je toestemming voor advertenties',
                      'Change your ad consent', 'Werbe-Einwilligung ändern')),
                  onTap: ConsentService.gizlilikSecenekleriniGoster,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
