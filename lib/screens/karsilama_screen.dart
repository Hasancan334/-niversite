import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/university_config.dart';
import '../l10n/dil.dart';

/// İlk açılış: önce karşılama (Welkom / Welcome), sonra dil seçimi.
class KarsilamaScreen extends StatefulWidget {
  @override
  _KarsilamaScreenState createState() => _KarsilamaScreenState();
}

class _KarsilamaScreenState extends State<KarsilamaScreen> {
  bool _dilAdimi = false;

  Widget _logo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        UniversityConfig.logoAsset,
        height: 110,
        width: 110,
      ),
    );
  }

  Widget _karsilama() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _logo(),
        SizedBox(height: 32),
        Text(
          'Welkom!',
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        SizedBox(height: 4),
        Text(
          'Welcome!',
          style: TextStyle(fontSize: 22, color: AppColors.textSecondary),
        ),
        SizedBox(height: 24),
        Text(
          UniversityConfig.fullName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Alles voor je studentenleven op één plek.\n'
            'Everything for your student life in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, height: 1.5, color: AppColors.textSecondary),
          ),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _dilAdimi = true),
            child: Text('Verder / Continue', style: TextStyle(fontSize: 17)),
          ),
        ),
      ],
    );
  }

  Widget _dilKarti(String kod, String bayrak, String ad) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Dil.sec(kod),
          style: ElevatedButton.styleFrom(
            backgroundColor: kod == 'nl' ? AppColors.primary : AppColors.white,
            foregroundColor: kod == 'nl' ? AppColors.white : AppColors.primary,
            side: BorderSide(color: AppColors.primary, width: 1.5),
            padding: EdgeInsets.symmetric(vertical: 18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bayrak, style: TextStyle(fontSize: 26)),
              SizedBox(width: 12),
              Text(ad,
                  style:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dilSecimi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.language, size: 64, color: AppColors.primary),
        SizedBox(height: 20),
        Text(
          'Kies je taal',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'Choose your language',
          style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
        ),
        SizedBox(height: 36),
        _dilKarti('nl', '🇳🇱', 'Nederlands'),
        _dilKarti('en', '🇬🇧', 'English'),
        SizedBox(height: 8),
        Text(
          'Je kunt dit later wijzigen / You can change this later',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(_dilAdimi),
                child: _dilAdimi ? _dilSecimi() : _karsilama(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Uygulama içinden dil değiştirmek için küçük pencere.
void dilSecimiGoster(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text(tx('Dil', 'Taal', 'Language')),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(ctx);
            Dil.sec('nl');
          },
          child: Text('🇳🇱  Nederlands',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      Dil.kod == 'nl' ? FontWeight.bold : FontWeight.normal)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(ctx);
            Dil.sec('en');
          },
          child: Text('🇬🇧  English',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      Dil.kod == 'en' ? FontWeight.bold : FontWeight.normal)),
        ),
      ],
    ),
  );
}
