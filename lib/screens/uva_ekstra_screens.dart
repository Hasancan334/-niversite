// Amsterdam flavor'una özel ekranlar: akademik takvim, kampüsler, önemli linkler.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../l10n/dil.dart';
import '../models/uva_extra_data.dart';
import '../widgets/banner_ad_widget.dart';

Future<void> _ac(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
}

Widget _bilgiKutusu(String metin, {String? linkMetni, String? url}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.07),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(metin,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        if (url != null)
          TextButton.icon(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () => _ac(url),
            icon: Icon(Icons.open_in_new, size: 16),
            label: Text(linkMetni ?? url),
          ),
      ],
    ),
  );
}

// ---------------------------------------------------------------- Takvim
class AkademikTakvimScreen extends StatelessWidget {
  bool _ayniGun(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _aralik(TakvimItem t) {
    final f = DateFormat('d MMM y', Dil.locale);
    if (_ayniGun(t.begin, t.eind)) {
      return DateFormat('EEEE d MMM y', Dil.locale).format(t.begin);
    }
    return '${f.format(t.begin)} – ${f.format(t.eind)}';
  }

  IconData _ikon(TakvimTur tur) {
    switch (tur) {
      case TakvimTur.periode:
        return Icons.menu_book;
      case TakvimTur.vrij:
        return Icons.beach_access;
      case TakvimTur.feestdag:
        return Icons.celebration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final simdi = DateTime.now();
    final bugun = DateTime(simdi.year, simdi.month, simdi.day);

    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(tx('AKADEMİK TAKVİM', 'ACADEMISCHE KALENDER',
            'ACADEMIC CALENDAR')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _bilgiKutusu(
            tx(
                'Akademik yıl ${UvaExtraData.takvimJaar}. Sınav tarihleri derse göre değişir.',
                'Academisch jaar ${UvaExtraData.takvimJaar}. Tentamendata verschillen per vak; check je rooster.',
                'Academic year ${UvaExtraData.takvimJaar}. Exam dates differ per course; check your timetable.'),
            linkMetni: tx('Resmi takvim', 'Officiële kalender',
                'Official calendar'),
            url: UvaExtraData.takvimUrl,
          ),
          ...UvaExtraData.takvim.map((t) {
            final gecti = t.eind.isBefore(bugun);
            final simdiMi = !t.begin.isAfter(bugun) && !t.eind.isBefore(bugun);
            final renk = t.tur == TakvimTur.periode
                ? AppColors.primary
                : (t.tur == TakvimTur.vrij
                    ? AppColors.success
                    : Colors.orange.shade700);
            return Opacity(
              opacity: gecti ? 0.45 : 1,
              child: Card(
                margin: EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: simdiMi
                      ? BorderSide(color: renk, width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: renk.withOpacity(0.12),
                    child: Icon(_ikon(t.tur), color: renk, size: 20),
                  ),
                  title: Text(tx(t.nl, t.nl, t.en),
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(_aralik(t)),
                  trailing: simdiMi
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: renk,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(tx('Şimdi', 'Nu', 'Now'),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11)),
                        )
                      : null,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Kampüs
class KampusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(tx('KAMPÜSLER', 'CAMPUSSEN', 'CAMPUSES')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _bilgiKutusu(tx(
              'Bir binaya dokun, haritada açılsın.',
              'Tik op een gebouw om het op de kaart te openen.',
              'Tap a building to open it on the map.')),
          ...UvaExtraData.campussen.map((c) {
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                initiallyExpanded: true,
                leading: Icon(Icons.location_city, color: AppColors.primary),
                title: Text(c.naam,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text(tx(c.nl, c.nl, c.en),
                    style: TextStyle(fontSize: 12)),
                children: c.gebouwen.map((g) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                    title: Text(g.naam, style: TextStyle(fontSize: 14)),
                    subtitle: Text('${g.adres}\n${tx(g.nl, g.nl, g.en)}',
                        style: TextStyle(fontSize: 12)),
                    isThreeLine: true,
                    trailing: Icon(Icons.map_outlined,
                        color: AppColors.primary),
                    onTap: () => _ac(g.mapsUrl),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Linkler
class OnemliLinklerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(tx('ÖNEMLİ LİNKLER', 'HANDIGE LINKS', 'USEFUL LINKS')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: UvaExtraData.belangrijkeLinks.map((cat) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(cat.icon, color: AppColors.primary),
              title: Text(tx(cat.nl, cat.nl, cat.en),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              children: cat.items.map((l) {
                final tel = l.url.startsWith('tel:');
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  title: Text(l.naam, style: TextStyle(fontSize: 14)),
                  subtitle: Text(tx(l.nl, l.nl, l.en),
                      style: TextStyle(fontSize: 12)),
                  trailing: Icon(tel ? Icons.phone : Icons.open_in_new,
                      size: 18, color: AppColors.primary),
                  onTap: () => _ac(l.url),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
