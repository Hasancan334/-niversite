// Amsterdam flavor'u: Ayarlar (dil + reklam gizlilik seçenekleri).
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/dil.dart';
import '../services/consent_service.dart';
import 'karsilama_screen.dart';

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
        title: Text(tx('AYARLAR', 'INSTELLINGEN', 'SETTINGS')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.language, color: AppColors.primary),
              title: Text(tx('Dil', 'Taal', 'Language')),
              subtitle: Text(Dil.kod == 'en' ? 'English' : 'Nederlands'),
              onTap: () => dilSecimiGoster(context),
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
                      'Privacy options')),
                  subtitle: Text(tx(
                      'Reklam onayını değiştir',
                      'Wijzig je toestemming voor advertenties',
                      'Change your ad consent')),
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
